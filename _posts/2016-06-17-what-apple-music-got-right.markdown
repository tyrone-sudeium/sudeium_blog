---
layout: post
title: "What Apple Music Got Right"
date: 2016-06-17 17:55:00 +1000
comments: true
categories: [Ideas, Apple]
---

It's now been almost exactly one year since Apple Music was announced, so I
thought I'd give a bit of a retrospective of that time.

<!--more-->

People have been mostly critical of Apple Music since it came out, and Apple is
obviously quite aware of the criticism, since at WWDC 2016 they announced a
major [overhaul][Overhaul] of the young service. Outside of the diehard Apple
faithful the criticism has been pretty relentless so I won't cover any of it
here but if you want to read about that, a simple Google search for Apple Music
Criticism will get you there. 

People are often genuinely surprised when they find out I use iTunes and Apple
Music. I get glib responses like: "Oh it didn't delete all your tracks
then!", or even just "But, why?". They figure it must just be some "Apple fan"
craziness, because someone couldn't possibly *choose* to use this product if
they're of sound mind, right?

I have a lot of problems with iTunes and Apple Music, but that horse has well 
and truly been beaten to death, so, in this post, I just want to talk about the
ways that Apple Music got it right. This isn't intended to be a glowing
recommendation, I'm not trying to shill Apple here, I'm just offering a 
dissenting opinion, a little devil's advocate in a  seemingly unending deluge
of negativity.

Background: I've been an Apple Music and iTunes Match subscriber since about
September of 2015. I was previously a long-time Spotify Premium user, where I'd
been a paying customer for almost four years, but I unsubscribed after an
international trip where Spotify failed me in a spectacular fashion.

## Native Apps

I'm well aware iTunes is not exactly the most revered Apple app around, but
it's absolutely miles ahead of any web app you can point me to. There are
obvious advantages to building a music application using web technologies,
but hosting it in a web browser is clunky, inconvenient and unintuitive.
Spotify realised this early on, which is why they built a web-app that is
hosted inside a native one, so it mostly looks and feels like a native app
despite being largely HTML, CSS and JavaScript. It uses native stuff where
it counts, a strategy now offered by technologies like Electron.

The advantages to having a native desktop app option are:

1. Better performance, mostly in terms of scrolling, memory usage, interface
responsiveness.
2. Seamless integration into the system, such as keyboard media keys, an
always-on-top mini player, and at least on the Mac, an app that looks like it
fits with the rest of the system (sorry Windows, I know iTunes still sucks a
lot there). All of this is available without having to bloat your web browser
with extensions which may or may not even work when your browser updates.
Speaking of browser updates...
3. Doesn't stop your music when your web browser updates. If you use that
browser from The Goog, then your browser will probably update *every other day*
so this point is more important than you'd probably think.
4. Support for aggressive caching, separate from your browser cache. This is a
big point if you're an Australian with ridiculous download limits or on a work
connection with Big Brother monitoring your downloads.
5. Doesn't need Flash Player, and it doesn't use HTML audio APIs which have
known to be flaky, especially if your system is under load (think: compiling
code).
6. Cross-browser support can sometimes be suboptimal. The music product from
The Goog obviously prefers the browser product from The Goog, which is not my
default browser. On the Mac I use Safari Technology Preview, and on Windows
I use [The People's Browser][Firefox].

{% include figure.html url="/img/2016-06-17-what-apple-music-got-right-1.png" 
description="The Goog only provides a website." %}

Some other points about the native apps:

* Apple provides an Apple Music app even if your mobile device is Android, and
unlike the efforts from The Goog, Apple actually bothered to make their Android
app look and act like an Android app... Google's product on iOS looks and acts
like an Android app, which makes it feel a bit like an impostor on that
platform.
* I'm aware that Apple Music on iTunes is largely web-based. So is Spotify.
There's nothing inherently wrong with that, and if they can improve the
performance situation maybe they can eventually get it to the point where
you don't even notice, like where Spotify is today. The point is, your music
belongs in a native desktop app, not in a browser tab.
* Apple's apps don't autoupdate at an obnoxiously fast pace. "Like to install 
the latest version of Spotify?" -- no, apparently not as much as you like
forcing me to restart the app, Spotify. Sometimes I want to be able to keep an
app open for two days without rebooting it. It's an app that plays music, it's
pretty close to a solved problem, I don't understand why you *need* to update
multiple times a week.

I have a lot of respect for The Goog's music product, and I even have a
subscription to it by virtue of being a YouTube Red subscriber. However, even
though I have access to it, as a product it'll always be completely unfit for
purpose for me without first-party, Mac & Windows native desktop apps, which 
is the environment in which I consume the vast majority of my music.

## Local Files & Downloads Actually Work

Files you add to your iCloud Music Library manually, that is, imported directly
from files and not from Apple Music, are first-class citizens in the iTunes /
Apple Music ecosystem. They appear in your music library completely indistinct
from Apple Music tracks. You can even have an albums and playlists made up of
mixed Apple Music / uploaded tracks.

There is DRM here but you would never know it. Shortly after subscribing to
Apple Music, I started downloading about 3,000 tracks to my iPhone to keep them
offline, to reduce cellular traffic. This download took about an hour on my
connection, and since then I've *never* seen Music delete or de-sync a single
track in the year since. Spotify, by contrast, cannot guarantee what happens
to synced tracks after a month, because the license may or may not expire
and the track may become unplayable, something you can't tell until you try
to play the track and have it fail. This often happens when you're on a
long-haul flight with no internet connection and no ability to fix it. Thanks
to this behaviour, offline syncing is a *completely useless* feature of Spotify
Premium -- being a *premium* feature you'd think fixing it would be a priority,
but after suffering through it for two years, not only has Spotify not fixed
it, they haven't even acknowledged it's an issue.

{% include figure.html url="/img/2016-06-17-what-apple-music-got-right-2.png" 
description="Spotify's app absolutely sucks offline." %}

As for local files, it's always been an absolute joke in Spotify. Tracks you
add yourself don't get uploaded at all, Spotify will often reject a file for
no apparent reason and give you no feedback as to why, and the supported file
types [vary][Vary] between platform and whether iTunes is installed! The system
to sync tracks to your mobile device is *even worse* -- sometimes files that
are accepted by the app will simply not copy over to your device, and again,
no feedback as to why, your track will just forever be greyed out and Spotify
will never attempt to sync that file ever again.

{% include figure.html url="/img/2016-06-17-what-apple-music-got-right-3.png" 
description="Spotify's local file syncing is only possible <em>in theory</em>."
%}

No, if you want to listen to music in Spotify, you'd better damn well hope
those tracks are in the Spotify Catalogue. Too bad if you listen to a lot of
independent music from sites like Bandcamp.

Apple Music and iTunes, on the other hand, being entirely built around the
concept of *your own Music Library* treats music added via Apple Music,
or directly via files no differently. They're just items in your library. All
these items are available everywhere your iCloud Music Library is, and for
the most part, once you've added them to your library, you no longer need to
think about where they came from.

Some other nice touches:

* You can play your music even while it uploads, and subsequently playing it
won't download or stream it from the server since the files are still available
locally.
* It's still possible to sync your music from your desktop to your phone,
however I would not necessarily consider the clunky iTunes sync feature to be
something that iTunes "got right".
* Apple has a matching system which can avoid uploads altogether. If you have
Apple Music but not iTunes Match, it'll only be able to match tracks from Apple
Music, and they'll get imported as Apple Music tracks. If you have both, it'll
always prefer iTunes Match, which is better for this use case, since the tracks
can then be downloaded unencrypted and it can match against the much larger
iTunes Music Store. In either case, if no matches are found it will simply
upload the track to iCloud, up to an awesome 100,000 track limit.

## It Can Play Albums In Order

I had this bug with Spotify where it would often not play an album in the
correct order. Yes, shuffle was off. For example, it would play tracks 1-5
just fine, but then skip to track 11, and then skip back to track 7, and then
play 8, 9, 10 and 11 fine, but then skip back to 7 and get stuck in a loop.

I experienced this for about a year, but only in the iOS app, and only when
out and about. It still has not been fixed or acknowledged by Spotify. I 
consider the ability to play an album in order a pretty critical Minimum 
Viable Product feature for a music player.

## There Is No Free Tier

I actually believe Tay Tay got this one right: a free tier for music streaming
devalues both the music and the streaming platform it is delivered on. I worry
about future generations growing up in a Spotify/Vevo world where the 
expectation is that all music is available on-demand, and be subsidised
exclusively by advertising. Unless the advertising market expands in some
profound way, which comes with its own problems, I just don't see it being able
to pay for the vast amounts of music currently being produced by that industry.
I'm no oracle or farseer so I have no idea what effect this will have on the 
music industry, but as a general rule I would prefer any model that results in
artists getting paid more for their work rather than less. It's for this reason
that I support sites like Bandcamp.

Apple Music is still part of the problem: streaming music is decidedly less 
lucrative for record companies, and especially artists than direct album 
purchases are, but it's still better than the alternative. At least with iTunes
I'm given the *option* of purchasing it from the Music Store and have the 
tracks work seemlessly with the rest of my library.

Oh yeah, and Apple Music has Tay Tay's 1989 and The Goog and Spotify don't.

{% include figure.html url="/img/2016-06-17-what-apple-music-got-right-4.png" 
description="Apple has Tay Tay." %}

## It's Pretty Awesome on Apple TV

* Siri on Apple TV means it's almost always faster to just ask your Siri remote
to play something than it is to navigate the UI. It's very accurate, it works
while you're doing other things, and like everything with the iCloud Music
Library, it works with all tracks in your library not just the Apple Music
ones.
* The UI is slick, understated and aesthetically pleasing on large display, in
both low and high light situations. [Video][AppleTV].
* Apple TV already had those neat screensavers, they're made better with your
own playlists going. It's very good for background music when you're
entertaining or otherwise.

## The Music Library Model

Users who never tried Spotify probably don't find the iTunes model confusing,
but I know I certainly did when I switched back. The problem is basically in
the mental model.

In Spotify, *Spotify itself* is the music library. Spotify does search so
quickly, and tracks start playing so fast, it gives this nifty illusion that
the entirety of the Spotify catalogue is basically *your* music library. The
ability to "add" albums is really just hyperlinking to it, and playlists are
just hyperlinking to individual tracks. You don't really have a library of your
own, you're just surfing through Spotify's library finding the stuff you like.
With this in mind, it starts becoming obvious why local tracks are such an
impedance mismatch for the Spotify product.

Contrast this to iTunes, which has always been based around the concept of
*your own* library. Traditionally, you had an empty library, and you added
music to it by dragging the tracks into iTunes and having it import them. This
is the *weird* thing about Apple Music -- this model still applies, even though
it's music streaming. Sure, Apple Music lets you play stuff straight out of the
New tab, but it's clunky, slow and it's clearly just there for convenience. What
they *want* you to do is to think of your library and the Apple Music catalogue
as *separate* things, and when you find something you like, you *copy* it from
Apple Music into your own library, where it becomes yours. It doesn't *really*
become yours, of course, it's still music streaming, so access to those files
is gone if you unsubscribe, but the illusion is there.

If you've bought into the Spotify model, it can feel a bit... *old-fashioned*
to go back to the iTunes model, but I'm convinced it's the only decent way to
support streaming *and* to have decent support for imported tracks. It also
allows some other interesting things:

* You can edit the metadata of items in your library, *even ones from Apple
Music*. This is again because iTunes doesn't treat tracks from Apple Music any
differently than tracks added any other way. Once it's in your library, the
metadata now belongs to your library and you can edit it to your heart's
content.
* Tracks you download using the download button are encrypted, but nothing
about the local cache is obfuscated or weird. The same way iTunes organises
your local files, it can do with encrypted Apple Music tracks too, they just
get downloaded as m4p files.

## Conclusion

I've been around the block. I've had active subscriptions for Spotify, Google
Play Music All Access, and Groove Music (née Xbox Music) and the situation
always leaves me wanting. It's not necessarily that iTunes and Apple Music are
great products in their own right, it's just that everything else has things
about it that are absolute dealbreakers. I can mostly work around the glitches
in iTunes, and they're getting better over time, but I can't work around the
fact that The Goog is religiously opposed to writing a native desktop app, for
example. I can't work around Groove only having a native desktop experience on
Windows. Spotify just refuses to believe their product has bugs, some of which
absolutely break the product from being minimally viable to me.

For now, Apple Music and iTunes mostly do what I want. I wish it was faster, I
wish the Windows application was just, well, better, but for now, it's the only
product in the market that does all the things I want such a product to do.

So, I guess you win by default, Apple?

[Overhaul]: //9to5mac.com/2016/06/13/new-ios-10-music-app-design/
[Vary]: //support.spotify.com/au/using_spotify/collect_music/listen-to-local-files/
[Firefox]: //firefox.com
[AppleTV]: //www.youtube.com/watch?v=7-r1BuOGvr4