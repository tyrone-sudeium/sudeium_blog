---
layout: post
title: "This Octopress Thingy"
date: 2013-10-22 21:14
comments: true
categories: [Meta]
---

My first mistake was buying a *cheap* server from [CloudAtCost][] without 
knowing beforehand if I'd have any particular use for it.  As is usual for 
nerds like me, I immediately had to find something to put on there.

Owncloud
========

My first port of call was to try out [OwnCloud][].  I'd [heard][1]
[rumblings][2] about it on the interwebs previously and figured -- despite 
having a premium [Dropbox][] subscription -- that I should have a go
at setting it up.  Fortunately, getting it working in Ubuntu is pretty much as
simple as:

```
    sudo apt-get install owncloud
```

At this point I can pretty much consider that plan a failure.  Open Source 
guys, listen up: if your software isn't at least as nice to use as the 
proprietary stuff, why do you even bother?  You shouldn't just settle for
mediocrity and hope that because you're open source you'll get a decent
userbase of digital hipsters.  

<!--more-->

The client for OS X is horribly ugly.  Did you lot just hand this to the
intern uni student to do?  Seriously, get a load of this uggo -- and this is
the image they chose show on their homepage!

![OwnCloud sync client - Mac][3]

Yikes!  The website that runs on the server isn't especially fast or reliable,
either.  Second-hand reports from various sources say that OwnCloud has a knack
for randomly corrupting the database or handling sync states between clients
poorly.  Investigating these issues on the internet reveal it's most likely
improved in newer versions and could've been caused by misconfiguring the
server.  

At this point, I feel I've spent way more time on this than I need
to.  Especially considering the end result is an uglier, slower, less reliable
monstrosity which would require my constant attention.

Octopress
=========

After giving up on OwnCloud and happily going back to Dropbox, I decided to
check out [Octopress][], the blogging framework for hackers.  I've seen it used
in the wild by some pretty [prominent][4] figures.  The [list][5] on their 
GitHub Wiki is impressively long.

It sounds like my kind of bag.

- Ruby!  Check.

- Jekyll!  Check.

- Markdown! Check.

- No need to write HTML or CSS! Check.

The fact that it simply produces a `public` folder that you can host with any
old web server is pretty slick as well.  It means -- theoretically one day, 
when I can be bothered -- I could pretty much host the entire thing on a CDN, 
which is kinda cool since I have a heap of spare data on [MaxCDN][].

I do have some concerns though.

"For Hackers"
-------------

The thing is designed to be used by *hackers*, which to me feels a little bit
like a rationalisation for making its user interface deliberately obtuse.
I do know my way around the ruby toolchain well enough, but I know that if I
leave this thing alone for a while, I'm going to forget which `rake` command
creates a new post, which command regenerates the `public` folder, which
command `rsync`s stuff up to the production, etc.

Markdown
--------

I do like Markdown, but I don't write nearly enough of it to be fluent in it.
This means whenever I want to write a post, I'll have to pull up Gruber's
trusty [Markdown Guide][6] as a reference so I can remember how the fucking
links work.

No HTML or CSS!
---------------

I've been bitten by frameworks in the past which claim "no HTML or CSS, 
promise!"  They typically end up being really fugly, or can't do something 
I critically need (read: it does something that rustles my jimmies) without
cracking open the CSS.  I'm already noticing that pungent smell of bullshit
in the air.  While writing this very post I had to crack open the CSS of the
theme I'm using<sup>[1][6]</sup> to find out why the `line-height` is 
inconsistent when `<p>` are contained in `<li>`; why the CSS for inline 
`<code>` blocks has inconsistent styling to code blocks in `<figure>` and 
THE MADNESS BEGINS.

These issues aside, it does look like a promising framework.  There's something
really satisfying about being able to write your posts in Sublime Text and
preview them in your web browser as though the whole thing is just a flat file.
Of course, now that I've set the thing up, only now have I come to realise the 
biggest flaw in my plan: **I can't write for shit**.

[CloudAtCost]: http://cloudatcost.com/ "CloudAtCost - $35 one time servers"
[OwnCloud]: http://owncloud.org
[Dropbox]: https://db.tt/piX4Jlvi
[Octopress]: http://octopress.org/
[MaxCDN]: http://maxcdn.com/
[1]: http://techcrunch.com/2013/02/24/meet-owncloud-5-the-open-source-dropbox/
[2]: http://www.zdnet.com/want-a-cloud-where-you-call-the-shots-consider-owncloud-7000017233/
[3]: http://owncloud.org/wp-content/uploads/2012/05/mac-e1337366410716.png
[4]: http://me.veekun.com/
[5]: https://github.com/imathis/octopress/wiki/Octopress-Sites
[6]: https://github.com/alexgaribay/octoflat