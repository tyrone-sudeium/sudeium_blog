---
layout: post
title: "Binary Plists in Sublime Text 3"
date: 2013-12-15 14:14
comments: true
categories: [Sublime Text, Python, Programming]
---

I've lost count of the number of times I've opened a .plist file in Sublime
Text only to have it come up with binary goobledegook.  It's pretty standard
in the Apple universe to see binary plists with the standard .plist extension,
so there's no way to know whether they're binary or not without trying to open
it first.  The common answer to this is "just use Xcode!" -- however, anyone
that's actually _used_ Xcode before will know just how much it sucks at casual
editing.  Opening Xcode is a commitment I'm just not willing to make sometimes.

Sublime Text
============

[Sublime Text][1] is by far my favourite text editor.  It has a fantastic 
package manager in [Package Control][2] which allows you to manage the 
installation of plugins that extend the functionality of Sublime.  Sublime 
doesn't support binary plists out of the box, but a kind sir by the name of 
[relikd][3] made a plugin that can convert to and from binary plist.  I have a
couple of problems with his implementation, though:

1. The UX leaves a lot to be desired.  It requires you to manually press some
   arcane key combination to toggle between binary (useless) and XML (useful).
   I can't imagine any situation where'd you _want_ to edit the binary in a
   binary plist by hand, so why open it as binary by default?
2. Internally, it just calls the `plutil` command line tool that ships with
   OS X.  This means it requires OS X to work.  Ideally, this should be an
   entirely python native solution, which would work on any platform, on the
   off-chance you encounter a plist file on a non-Apple computer.  Having to 
   start up a command line app doesn't strike me as particularly efficient
   either.
3. It doesn't ship with a plist syntax definition.  XML plists can of course
   just use the built-in XML highlighter, but that isn't nearly as strict as
   plists are, and it doesn't support the "old-style" plist format which you
   sometimes still see.

BinaryPlist
===========

I'm an Objective-C developer by trade and a Ruby developer at heart, so excuse
my poor python skills.  This is my take at a plist plugin for Sublime Text 3
that should make working with plists feel a lot more first-class.  It provides:

* Automatic conversion of binary plist to XML.  You can then edit the XML file
  in Sublime and it will automatically convert back to binary when you save.
* Cross platform support.  The solution is pure python.  No calls to the
  command line, no foreign-function shenanigans, just 100% python goodness.
* Plist syntax highlighting from [TextMate][4].

The python plist support is taken from the [Python 3.4 standard library][5], 
with a few modifications to support running in the Python 3.3 that ships with
Sublime Text 3.  This library therefore has a heavy dependency on Python 3.x
which is why it'll probably never work with Sublime Text 2.  Seriously, just
use Sublime Text 3, it's awesome.

It still needs a few more little tweaks and a lot more testing before it's 
ready for Package Control, but in the meantime, you can check out the GitHub
repository [here][6].

[1]: http://www.sublimetext.com/
[2]: https://sublime.wbond.net/
[3]: http://relikd.tumblr.com/post/29260666076/sublime-plugins
[4]: https://github.com/textmate/property-list.tmbundle/tree/textmate-1.x
[5]: http://hg.python.org/cpython/file/default/Lib/plistlib.py
[6]: https://github.com/tyrone-sudeium/st3-binaryplist