---
layout: post
title: "Swift Performance: Too Slow For Production"
date: 2014-12-10 21:19:41 +1100
comments: true
categories: [Programming]
---

Much and more has been written about Apple's new programming language, Swift.
I even did a talk about it at [Yow: Connected 2014][Yow]. If you saw me there,
you'd know that I'm not the biggest fan of Swift. I think the rollout of it has
been an absolute disaster: the [compiler][BugReport] is a [shambles][Issues], 
the language design is inconsistent in places[^1] and it's stupidly difficult
to get working in libraries, particularly if you want to support iOS 7. Surely
though, at the very least its performance would be all right, after all, it's
designed to be more static and do more checking at compile-time and is _meant_
to be made with the LLVM optimiser in mind...

Let's talk about performance in Swift, then.

<!--more-->

Like many people I was lulled into a false sense of security about Swift's
performance by a combination of factors:

- [This][PerformancePost] post. It shows Swift as approaching the performance
of _C_ when it comes to sorting arrays. Very impressive. Surely the rest of
Swift is this fast too, right?
- Apple's own [marketing][Marketing] about it, which claims an impressive
"2.6x" faster than Objective-C and "8.4x" faster than Python 2.7.
- The name. Come on, they called it _Swift_. They wouldn't call it that if it
was slow.

I got about 1,000 lines into my project before thinking to myself that I should
really performance test what I've written on the off-chance it wasn't fast
enough. At the time, the project was entirely Swift, and it made use of the
pretty nice [JSONHelper] library to make the deserialisers look nicer. An
example of what my Swift-like solution looked like:

```Swift
import Foundation

public class User : ModelObject, UpdatableFromJSON {
    public var name: String?
    public var handle: String?
    
    public required init(data: [String : AnyObject]) {
        super.init(data: data)
        updateWithJSON(data)
    }
    
    public override func updateWithJSON(data: [String : AnyObject]) {
        super.updateWithJSON(data)
        name <<< data["name"]
        handle <<< data["handle"]
    }
}
```

So far, so nice. 

At this point I devised a test, which would parse about 500kb of JSON, which 
is pretty far into "worst-case scenario" territory for our app, but isn't 
outside the realm of possibility. It's indicative JSON, very much like 
something the API would really return. You can find a copy of the sample JSON
[here][SampleJSON]. It shows a user who has a membership in 1,000 
conversations. The model parser should read this JSON, create `Membership` 
objects which point directly to the corresponding instance of `User` and 
`Convo`, and create (or update) a heap of `Convo` objects based on the contents
of the `convos` key. In the the `Convo`s, the `creator` key should point to 
the corresponding instance of `User`. Nothing here's unusual for a relatively
sophisticated production iOS app.

I wrote a performance test using XCTest's new performance testing feature.
The test itself looked like this:

```Swift
func testUserConvosSwiftParsingPerformance() {
    let filePath = NSBundle(forClass: PerformanceTests.self).pathForResource("convos", ofType: "json")
    let jsonData = NSData(contentsOfFile: filePath!)
    var error: NSError?
    let jsonObject = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: &error)! as [String : AnyObject]
    self.measureBlock() {
        let resp = ChatspryClient.UserConvosResponse(data: jsonObject)
    }
}
```

Making sure I had `-O` turned on in the build settings, I pulled out my iPod
Touch 5th generation, which is realistically the slowest device we'll be 
supporting, since it runs iOS 8 and has the same dual-core A5 as the iPhone 
4S (which I don't have). This made for a reasonable worst-case scenario: huge
JSON payload, slow device.

Want to know how Swift did?

...

Guess.

...

Nope, higher. Try again.

...

Nope, _higher_, try again!

...

Oh fine I'll just tell you! It took 1.42 _seconds_. One-point-four-two 
*_seconds_*. That can't be right! Horrified by this, I decided to quickly whip
up an Objective-C version of the same performance test. It was just the bare
minimum code to implement the test, written in a distinctly Objective-C style,
just like the Swift code was written in a distinctly Swift style.

An example of what the Objective-C looked like:

```Objective-C
@interface CSUser : CSModelObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *handle;
@end
@implementation CSUser
- (void) updateWithJSON:(NSDictionary *)json
{
    [super updateWithJSON: json];
    self.name = json[@"name"];
    self.handle = json[@"handle"];
}
@end
```

There were also implementations for `CSMembership` and `CSConvo` among others,
and superclasses too. It was a pretty representative parser. So I whipped out
my trusty XCTest case and created a new performance test which used the 
Objective-C classes instead, again making sure that `-Os` was enabled in the
build settings.

You'll never guess. This version runs on my device in just 0.09 seconds. Which
makes the Objective-C version about 15x _faster_ than the Swift version.
Remember, the LLVM optimiser is turned _on_ for both of these cases.

Ridiculous! I'd wasted most of my weekend at this point, so I figured why not
waste some more. I wasn't sure if Swift was slow or if it was just JSONHelper
that was slow. The only way to rule it out for sure would be to write a version
of the Swift code that is basically a line-for-line translation of the
Objective-C so I could do a true Apples-to-Apples test. This is absolutely
_not_ how you'd write Swift, since it was full of `NSDictionary` references
everywhere instead of Swift dictionaries, to name an example.

An example of what this looked like:
```Swift
public class CSSwiftUser : CSSwiftModelObject {
    public var name: String?
    public var handle: String?
    
    public override func updateWithJSON(json: NSDictionary) {
        super.updateWithJSON(json)
        name = json["name"] as String?
        handle = json["handle"] as String?
    }
}
```

Now, one caveat about the results here. I simply couldn't get the Swift to run
with `-O` turned on without segfaulting. So, I figured to be fair, I'd turn off
the optimiser for Objective-C this time around too. Here's the result:

- Objective-C: 0.06 seconds
- Objective-C-like Swift: 0.29 seconds

I have no idea why the Objective-C runs faster with the optimiser turned off,
but OK, sure. This proves that Swift is only acceptably fast if you basically
write it exactly like you'd write Objective-C, but if you do, you'll probably
get segfaults that can't be fixed, and it'll still be about 5x slower anyway.

For one last test just for fun, I decided to rewrite the Objective-C test in
Ruby by using [RubyMotion]. If you haven't heard of RubyMotion, it allows you
to write iOS and Android apps using Ruby, which compiles down into the same
native code that you'd get when compiling Swift or Objective-C. It's meant to
be pretty fast, but I've never really benchmarked it with real production-like
code before. I've always suspected it was significantly slower than Objective-C
since it can't do the crazy `objc_msgSend` tricks that the Objective-C compiler
can do thanks to it doing all sorts of weird static analysis on method
dispatches to see if it can be sped up. This is just because Ruby is a really
dynamic language. Anyway...

Here's an example of what that Ruby looked like:

```Ruby
class CSUser < CSModelObject
  attr_accessor :name, :handle

  def updateWithJSON(json)
    super
    self.name = json[:name]
    self.handle = json[:handle]
  end
end
```

RubyMotion doesn't seem to have any options for the optimiser. It seems to just
default to having optmisation on if you build for device, which would be in
keeping with the convention-over-configuration mentality.

Here are the final results:

| Style                   | Optimisation | Time |
| -----                   | ------------ | ---- |
| Objective-C             | `-Os`        | 0.09 |
| Objective-C-like Swift  | `-Onone`     | 0.29 |
| Swift                   | `-O`         | 1.42 |
| RubyMotion              | ???          | 0.21 |

So RubyMotion is faster than Swift, then? The same _Ruby_, a language notorious
in the programmer community for being quite slow[^2] is _faster_ than a
language called _Swift_ which is _marketed_ as being a fast language?

If your language is _slower_ than a language that isn't even _trying_ to be
fast, I'm sorry, but you're just too far up shit creek. At this point, I wave
goodbye to Swift. The Objective-C models I've written make for a pretty good
starting point, so for now I'm just going to build that out.

I would love to provide all the source code used in this post, but
unfortunately our product isn't open source, and it _will_ in fact be our
production code someday. Feel free to leave a comment if you want to know more
about what the code did, and I'll tell you what I can.


[^1]: Like [subscripting](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Subscripts.html), which uses `get` and `set` syntax just like a _property_, but they are declared with a _function_ style syntax? There's no good reason for this that I can see...
[^2]: This isn't a criticism. I understand that it's just an extension of the idea that computer time is less valuable than human time, and Ruby lets you write programs faster to save human time. I appreciate, and even respect that world-view.

[Yow]: https://a.confui.com/public/conferences/533ec7198cc0a36c75000001/locations/533ec7198cc0a36c75000002/topics/53ce20d9513b88d51d00009c?framehost=http://connected.yowconference.com.au
[BugReport]: https://dl.dropboxusercontent.com/s/c0zhhy57sqst4hs/Screenshot%202014-11-05%2019.01.19.png?dl=0
[Issues]: https://github.com/practicalswift/swift-compiler-crashes
[PerformancePost]: http://www.jessesquires.com/apples-to-apples-part-three/
[Marketing]: https://www.apple.com/au/swift/
[JSONHelper]: https://github.com/isair/JSONHelper
[SampleJSON]: /images/convos.json
[RubyMotion]: http://www.rubymotion.com
