---
layout: post
title: "Swift 1.2 Performance: Pretty Much Fine"
date: 2015-02-10 20:50:27 +1100
comments: true
categories: [Programming]
---

I inadvertently kicked up a big stink two months ago by pointing out how slow
Swift was, which was version 1.1 at the time. Apple has since responded
with a new beta version of Xcode which includes a shiny new version of Swift,
version 1.2. Since it promised to:

> ... produce binaries that run considerably faster, and new optimizations 
> deliver even better Release build performance.

I thought it would be prudent to re-run my tests and see just how much Swift
has improved, if at all. 

<!--more-->

The process to update the code to Swift 1.2 wasn't
completely painless; for a "minor" version increment an awful lot of code was
made broken by 1.2. I'm not complaining, there's still plenty that's wrong
with the language and I'd prefer they be fast-moving, not afarid to make
breaking changes if it can improve the language.

If you recall from my previous post, I was using the JSONHelper library to
assist with JSON parsing. Surprisingly, I didn't have to make a single change
to this library to support Swift 1.2, everything in it seemed to be compliant.
Most of the issues I had were around the changes to `let`, specifically it not
allowing me to pass constants defined with `let` by reference to the JSONHelper
operations. There'll probably be a workaround for this eventually but for the
time being I've simply changed all my constants to variables, just to get the
tests working again. Pretty much everything else was picked up by the Swift
1.2 migration tool, or with fix-its on the build errors.

First thing I noticed after running the tests was that the Objective-C style
Swift code which previously segfaulted if compiled with optimisations turned
on would now run just fine with optimisations turned on! This is good, this
means I can finally do a fair comparison! This also pretty much confirms that
this segfault was through no fault of my own, since I've made literally no 
changes to any of this code since Swift 1.1.

Here are the results:

| Style            | Swift 1.1  | Swift 1.2 |
| ---------------- | ---------- | --------- |
| ObjC             |  0.09      | 0.06      |
| Swift            |  1.42      | 0.35      |
| ObjC-like Swift  |  0.29      | 0.13      |
| RubyMotion       |  0.21      | 0.21      |

This is an incredible improvement over the previous generation! I believe most
of this remaining deficit is simply inefficiencies in the JSONHelper library
now, as evidenced by the fact that the ObjC-style Swift is roughly twice as
fast. This code is much more Objective-C bridging heavy, but it also doesn't
require the use of the JSONHelper library, so any performance deficit from the
additional bridging is more than made up by the gains from losing the library.
JSONHelper is still slow, but that's not unexpected, this just shows that the
vast majority of the slowness back in December was from **Swift itself**, not
from JSONHelper.

At this stage I'm more than happy to retract my previous conclusion of Swift
being too slow for production use. Swift 1.2 seems more than up-to the task and
if they keep updates like this one coming, it may even eventually live up to
its namesake. Sadly, it's a bit too late in my project to switch back to using
it for my data model, but I no longer have any concerns about using it for
every other part of my app. At the time of writing, according to GitHub, my 
project is 49% Swift and 50% Objective-C, with the Swift parts quickly gaining
ground.

I've been about as cynical as you can possibly get when it comes to Swift,
especially since it came out of beta status. However, even I have to admit that
after this latest release, Apple has shown that they're capable of rapidly
improving the language. Even though Apple is still notoriously bad at
acknowledging issues and making promises to correct them, this release at least
shows that they are listening, and making sound decisions in terms of
prioritising fixes. Some of the most debilitating and productivity-crushing
bugs were fixed and it's starting to feel like something we can actually use
daily without feeling like we're fighting it every step of the way.

I'm actually excited about what could possibly be in Swift 1.3!