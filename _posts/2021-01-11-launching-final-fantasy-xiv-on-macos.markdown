---
layout: post
title: "Launching Final Fantasy XIV on macOS"
date: 2021-01-11 21:40:00 +1100
comments: true
categories: [Programming]
---

FINAL FANTASY XIV is an MMORPG for Windows, macOS, and PlayStation. The Mac
version is essentially an identical build of the Windows version, except it
runs in a customised version of [Wine](https://www.winehq.org/). The launcher
/ patcher for FFXIV is pretty famously disliked, and for Windows users there's
a very good [custom one](https://github.com/goatcorp/FFXIVQuickLauncher), but
unfortunately it doesn't work for Mac. So I made my own.

One of the more interesting challenges in doing so was dealing with how the
FFXIV Launcher passes arguments between the launcher and the main game
executable. In this post, I'll do a deep dive into my journey of discovery to
reimplement this logic in Swift.

<!--more-->

## Why A Custom Launcher?

My launcher isn't anywhere near as featureful as XIVLauncher. I don't really
have the time to dedicate to reimplementing its enormous feature set, plus some
of its features would be very difficult to implement in macOS due to its onerous
security policies and the fact that the game runs in Wine.

That said, the main things my launcher brings to the table are:

### A Native macOS User Interface

The default launcher, already largely just a Web View, also runs in Wine, so
the experience is extremely jarring and out of place on a Mac.

### Save Password

On macOS username + password combos can be safely and securely stored in the
Keychain. The default launcher only allows you to save your username.

## The Algorithm

If you load up [Process Explorer][ProcExp] on a Windows machine while FFXIV is
running you will see something like this:

    Command line:
    "C:/Program Files (x86)/Steam/steamapps/common/FINAL FANTASY XIV Online/game/ffxiv_dx11.exe" "//**sqex0003GLBqsICCnUUr1zHEXvdQZUE-k385enBr_CALwmVqQbuVPSuvbjJlbOvdY1VxxfYsl_l1aNT7LOqY1hXgMFApoeNwsc9knIUdWVWhV7yN_Y-fWjlwbN--IHtqp1Yr_NmtCN9W4CyB7Cn3asasHYWjuLT4KZDY_1JC8sluramSAH3csIL6xvhdkJA1_QoQclBco327gI6s-7SzfhWpqkfXinp0ZiDaufVOoCByrYyDYvyoykEmcOZcgEU81dMCUM_xlS8Fz6MXXkaRhFt3Y0fxQ_M4H0UUJnBRF15wb7Ayw0wQF6tFnwn52b4G36S6nG_wv3aXC-yVZZ_HPTbaaCW9aSefxy1xv5yTTTgC2d5vkSGdMaInqdHkQ7FcNhfZr9jlVfcWRNnPveFijgBG2rb7lWYUESWOBpTTp**//"

Notice how the application is started up with just one argument:

    //**sqex0003GLBqsICCnUUr1zHEXvdQZUE-k385enBr_CALwmVqQbuVPSuvbjJlbOvdY1VxxfYsl_l1aNT7LOqY1hXgMFApoeNwsc9knIUdWVWhV7yN_Y-fWjlwbN--IHtqp1Yr_NmtCN9W4CyB7Cn3asasHYWjuLT4KZDY_1JC8sluramSAH3csIL6xvhdkJA1_QoQclBco327gI6s-7SzfhWpqkfXinp0ZiDaufVOoCByrYyDYvyoykEmcOZcgEU81dMCUM_xlS8Fz6MXXkaRhFt3Y0fxQ_M4H0UUJnBRF15wb7Ayw0wQF6tFnwn52b4G36S6nG_wv3aXC-yVZZ_HPTbaaCW9aSefxy1xv5yTTTgC2d5vkSGdMaInqdHkQ7FcNhfZr9jlVfcWRNnPveFijgBG2rb7lWYUESWOBpTTp**//

This whole mess is what we are going to attempt to reimplement. Thankfully, some
enterprising developers have already [documented][XIVDev] how this format
works, plus XIVLauncher already exists, and works. So it should be a fairly
simple matter of just copying what they've done, right? 

## Dealing with `GetTickCount`

As per the XIV Dev docs, the plaintext arguments are first encrypted using
[Blowfish][Blowfish], using `GetTickCount() & 0xFFFF0000` as the encryption key.
Hang on, what is `GetTickCount()`?

[According to the Windows developer documentation][GetTickCountMS], 
`GetTickCount` is a function provided by `kernel32.dll`, which gets the number
of milliseconds since the system was started.

Well, that's a problem, it's easy enough for XIVLauncher to simply `DllImport`
from `kernel32` to call the exact same underlying function that FFXIV itself
uses, but we can't do that on macOS. The exact semantics of how it works has to
be identical to whatever the Wine shipped with FFXIV for Mac does, otherwise the
keys won't match and the game won't be able to decrypt the arguments.

We know that the game will call `GetTickCount()` in Wine, so how does Wine
implement it? Thankfully, Wine is open source, so let's crack open that source
code and get sleuthing. We know the function is provided by `kernel32.dll` in
real Windows, so perhaps it's in `wine/dlls/kernel32`?

Sure enough, in [`sync.c`][syncc] we see:

{% highlight c linenos %}
DWORD WINAPI DECLSPEC_HOTPATCH GetTickCount(void)
{
    /* note: we ignore TickCountMultiplier */
    return user_shared_data->u.TickCount.LowPart;
}
{% endhighlight %}

So it reads it from some global variable `user_shared_data`, fair enough.
Something else must write into `user_shared_data->u.TickCount` then. After a lot
of digging I discovered `wine/server/fd.c`.

In [`fd.c`][fdc] we see:

{% highlight c linenos %}
static void set_user_shared_data_time(void)
{
    timeout_t tick_count = monotonic_time / 10000;

#if defined(__i386__) || defined(__x86_64__)
    // ... snip ...

    user_shared_data->TickCount.High2Time = tick_count >> 32;
    user_shared_data->TickCount.LowPart   = tick_count;
    user_shared_data->TickCount.High1Time = tick_count >> 32;
    *(volatile ULONG *)&user_shared_data->TickCountLowDeprecated = tick_count;
#else
    // ... snip ...
#endif
}
{% endhighlight %}

Getting close, in the same file I can see that the global `monotonic_time` is
set in `set_current_time` like:

{% highlight c linenos %}
monotonic_time = monotonic_counter();
{% endhighlight %}

So what is `monotonic_counter()`? Turns out, it is in [`request.c`][requestc]:

{% highlight c linenos %}
timeout_t monotonic_counter(void)
{
#ifdef __APPLE__
    static mach_timebase_info_data_t timebase;

    if (!timebase.denom) mach_timebase_info( &timebase );
#ifdef HAVE_MACH_CONTINUOUS_TIME
    if (&mach_continuous_time != NULL)
        return mach_continuous_time() * timebase.numer / timebase.denom / 100;
#endif
    return mach_absolute_time() * timebase.numer / timebase.denom / 100;
{% endhighlight %}

Eureka! However, this just raises another question: in the Wine shipped with
FFXIV, does `monotonic_counter()` use `mach_continuous_time`, or does it use
`mach_absolute_time()`???

Searching for `wine mach_continuous_time` brought me to an interesting 
[patch][winepatch] in the Wine mailing list. Apparently some time in late 2019 
they changed `GetTickCount()` on macOS to use `mach_continuous_time()`, 
since that better matches the behaviour of the real Windows implementation. 
Versions of Wine prior to that will use `mach_absolute_time()`.

How do we know which version of Wine FFXIV uses? This is tricky to answer since
it is not a bog standard Wine, but a specialised build from Codeweavers, the
company which handled the FFXIV Mac port _and_ are the primary maintainers of 
Wine. Running:

    /Applications/FINAL\ FANTASY\ XIV\ ONLINE.app/Contents/SharedSupport/finalfantasyxiv/bin/wine --version

Very unhelpfully returns:

    Product Name: FINAL FANTASY XIV ONLINE
    Public Version: 1.0.5
    Product Version: 18.5.0.31941local
    Build Tag: 3c9addb3fff38fa07712a304ddab359cebc2d69c
    Build Timestamp: 20200213T194053Z

See what I mean about a specialised build? Well then nothing for it but to crack
open Visual Studio on my Windows machine and code up a test application.

## Test Applications

### Windows (C++)

I slapped together a very basic Console Application in Visual Studio C++:

{% highlight cpp linenos %}
#include <iostream>
#include <Windows.h>

int main()
{
    auto ticks = GetTickCount();
    std::cout << "ticks = " << ticks << std::endl;
}
{% endhighlight %}

Then I compiled it and copied it over to my Mac. Running it with:

    /Applications/FINAL\ FANTASY\ XIV\ ONLINE.app/Contents/SharedSupport/finalfantasyxiv/bin/wine GetTickCount.exe

Returns...

... nothing? What's going on here? I would expect an error message, or a
segfault maybe, but not _nothing_. After spending entirely too long going down
the wrong rabbit holes I realised that this version of Wine does not emit
_anything_ on the console unless you also provide `--verbose`. D'oh.

    /Applications/FINAL\ FANTASY\ XIV\ ONLINE.app/Contents/SharedSupport/finalfantasyxiv/bin/wine --verbose GetTickCount.exe

Finally, some console output! An error message:

    0026:err:module:import_dll Library MSVCP140D.dll (which is needed by L"C:\\GetTickCount.exe") not found
    0026:err:module:import_dll Library VCRUNTIME140_1D.dll (which is needed by L"C:\\GetTickCount.exe") not found
    0026:err:module:import_dll Library VCRUNTIME140D.dll (which is needed by L"C:\\GetTickCount.exe") not found
    0026:err:module:import_dll Library ucrtbased.dll (which is needed by L"C:\\GetTickCount.exe") not found
    0026:err:module:LdrInitializeThunk Importing dlls for L"C:\\GetTickCount.exe" failed, status c0000135

Crap. This is the kind of error you would normally fix in Windows by installing
the [Visual C++ Runtime][vcredist]. However, we need this to work just with
whatever is pre-installed in the Wine Bottle that FFXIV runs in...

Maybe it doesn't like the 64-bit build? I know lots of software in Windows is
still compiled in 32-bit...

    /Applications/FINAL\ FANTASY\ XIV\ ONLINE.app/Contents/SharedSupport/finalfantasyxiv/bin/wine --verbose GetTickCount-32.exe

Now returns:

    winewrapper.exe:error: cannot execute L"GetTickCount-32.exe"

OK, maybe not. Makes sense, anyway. FFXIV is 64-bit, plus Apple removed all
32-bit support from macOS Catalina, and FFXIV is supposed to be fully supported
on macOS Catalina, so it _must_ be a 64-bit bottle.

After some searching I discovered that `VCRUNTIME140D.dll` references the
_Debug_ builds of the Visual C++ Runtime, and turns out I _did_ build it in
Visual Studio in Debug mode. A quick recompile later, and...

    0026:err:module:import_dll Library VCRUNTIME140_1.dll (which is needed by L"C:\\GetTickCount.exe") not found
    0026:err:module:LdrInitializeThunk Importing dlls for L"C:\\GetTickCount.exe" failed, status c0000135

Oh come on! At this point I decided to see if there's a way to simply statically
link the Visual C++ Runtime so it'd just be embedded in my `.exe`. Turns out,
there is. In Visual Studio, right click the project, Properties. Then in
Configuration Properties → C/C++ → Code Generation, change the 
`Runtime Library` setting to `Multi-threaded (/MT)`. A recompile and transfer
later and finally it wor--

    wine: Unhandled page fault on read access to 0x00000009 at address 0x140021469 (thread 0026), starting debugger...

Oh. Guess it doesn't like having the Visual C++ 2019 Runtime statically linked,
huh. Hang on a minute, Visual C++ 2019, maybe that's the problem? Maybe the
Wine Bottle only has an older Visual C++ Runtime. What's the oldest C++ build
tools I can install for Visual Studio Community 2019?

{% include figure.html url="/img/2021-01-11-launching-final-fantasy-xiv-on-macos-1.png" 
description="The MSVC build tools available: v140, v141, v142." %}

Seems like it's the tools from Visual Studio 2015, `v140`. Let's install that,
retarget the project to it, and try again.

    ticks = 141937076

Huzzah! Now, to find out whether this matches `mach_continuous_time()` or
`mach_absolute_time()`.

### macOS (Swift)

I slapped together a very basic single file Swift application like so:

{% highlight swift linenos %}
import Darwin

var timebase: mach_timebase_info = mach_timebase_info()
mach_timebase_info(&timebase)

func getTickCount(timeFunc: () -> UInt64) -> UInt64 {
    let machtime = timeFunc()
    let numer = UInt64(timebase.numer)
    let denom = UInt64(timebase.denom)
    let monotonic_time = machtime * numer / denom / 100
    return monotonic_time / 10000
}

print("getTickCount[absolute]: \(getTickCount(timeFunc: mach_absolute_time))")
print("getTickCount[continuous]: \(getTickCount(timeFunc: mach_continuous_time))")
{% endhighlight %}

Compiling this, then running this more or less at the same time as my Wine
program above:

    /Applications/FINAL\ FANTASY\ XIV\ ONLINE.app/Contents/SharedSupport/finalfantasyxiv/bin/wine GetTickCount.exe && ./MachTime

Returns:

    ticks = 168022842
    getTickCount[absolute]: 168022847
    getTickCount[continuous]: 935308133

So you can see it's a damn-near exact match for `mach_absolute_time()`. Finally!

## Blowfish, Endianness, and Swift

I know I need something that can do Blowfish encryption, and the 
[existing cryptography library I used][crypto] doesn't expose this algorithm,
which means it's time to go library hunting! My options are:

- Use the underlying `CommonCrypto` framework, which only exposes C functions
- Use something pure Swift

As a learning exercise, I decided to pull in a pure Swift library for this:
[CryptoSwift][CryptoSwift]. I go ahead and start implementing, and write a unit
test based on the results generated by XIVLauncher, which are known to work.

However, inexplicably, the ciphertext produced with the _same key_ ends up
vastly different from `CryptoSwift` compared to the 
[`Blowfish.cs`][XIVLauncherBlowfish] in XIVLauncher. As a sanity check I whip up
a quick implementation using `CommonCrypto`, but it yields the same ciphertext 
as `CryptoSwift`!

I decide to bust open Visual Studio on my PC once again, this time loading up a
small C# project that uses the `Blowfish.cs` implementation from XIVLauncher
to encrypt the same parameters as my unit test. Now I have an environment I can
attach debuggers to, to see where the implementations differ. Now, a disclaimer.
I'm going to attempt to explain what I consider to be some very strange 
[endianness][Endianness] issues, but I barely understand it and it
makes my head hurt. 

To start with, understand that Blowfish like many ciphers,
fundamentally works by first breaking up your data into blocks of 8 bytes, and
then each of those blocks into two 32-bit numbers, `L` and `R`. It then does
some math on those values, and produces two new 32-bit numbers, which you can
then break back apart into your 8 bytes.

First, I put a breakpoint in both projects where the byte array data is
finalised, and compare the results. Both implementations agree:

    [32, 84, 32, 61, 49, 50, 56, 52, ...]

Now I step forward to where the first block gets encrypted, and it extracts
`L` and `R`.

C#:

    L: 1025528864
    R:  876098097

CryptoSwift:

    L: 542384189
    R: 825374772

Well, well, well, what in the hay is that?! No wonder the ciphertext comes out
so radically different if the values it's reading out of the data disagree so
badly. Since `CryptoSwift` and `CommonCrypto` both produce the same ciphertext,
whatever they're doing must be logical in some way, but that doesn't help me
because FFXIV is expecting whatever it is that XIVLauncher is doing! So we'll
have to dig in deeper to see what the differences are in the Blowfish
implementation.

To derive the `L` and `R` values, `Blowfish.cs` is using the .NET class
`BitConverter`, specifically its `ToUInt32` static method.
[If only there was some way to see the source code for this class.][bitconverter]
The answer lies right before my eyes:

{% highlight csharp linenos %}
if( IsLittleEndian) { 
    return (*pbyte) | (*(pbyte + 1) << 8)  | (*(pbyte + 2) << 16) | (*(pbyte + 3) << 24);
}
else {
    return (*pbyte << 24) | (*(pbyte + 1) << 16)  | (*(pbyte + 2) << 8) | (*(pbyte + 3));
}
{% endhighlight %}

This means that, when running on a little endian machine, such as my Intel Mac,
it will _interpret_ the 4 bytes in each half of each block as being little
endian!

> "A little-endian system, ... stores the least-significant byte at the 
smallest address."

The C# converts `[32, 84, 32, 61]` to a `UInt32` by doing:

    (32 << 0) | (84 << 8) | (32 << 16) | (61 << 24)

Whereas CryptoSwift / CommonCrypto does:

    (32 << 24) | (84 << 16) | (32 << 8) | 61 << 0

No wonder it doesn't work! Just to test my theory, and in desperation to see
my unit test pass well after midnight, I fork the `CryptoSwift` code by
essentially copying its Blowfish class and other needed files directly into my
repo so I can make modifications to it. Unfortunately the 
[license][license] for CryptoSwift is weird and seemingly nonstandard, so I'm
not comfortable deriving any code from it, so this is all temporary.

I modify the `UInt32` extension to treat the input as little endian, and voila!
The ciphertext now matches the .NET version! We did it reddit!

Only thing left now is to try to reimplement this without having a fork of a
cryptography library in my repository. `CommonCrypto`, old faithful, is still
there, and I'm not afraid of calling C functions in my Swift, so doing it this
way probably makes the most sense, and maybe it could end up a bit faster than
a Swift implementation too.

The problem is, `CommonCrypto` also works only by interpreting the data only in
big endian. My solution was to do some old-school byte order swapping:

{% highlight swift linenos %}
func swapByteOrder32(bytes: inout [UInt8]) {
    for i in stride(from: 0, to: bytes.count, by: 4) {
        let b0 = bytes[i.advanced(by: 0)]
        let b1 = bytes[i.advanced(by: 1)]
        let b2 = bytes[i.advanced(by: 2)]
        let b3 = bytes[i.advanced(by: 3)]
        bytes[i.advanced(by: 0)] = b3
        bytes[i.advanced(by: 1)] = b2
        bytes[i.advanced(by: 2)] = b1
        bytes[i.advanced(by: 3)] = b0
    }
}
{% endhighlight %}

It's not pretty but it does the job, and without to copy the array either. I
ran the input byte array through this function and... the cipher text is still
wrong, and different again from any other implementation. After inspecting the
.NET cipher text, I noticed something...

.NET:

    [24, 176, 106, 176, ...]

Swift:

    [176, 106, 176, 24, ...]

Looks like the byte order on the emitted cipher text is also wrong! After doing
the ol' switch-a-roo on that:

    [24, 176, 106, 176, ...]

... which means our cipher text now matches XIVLauncher exactly, and without
using a `CryptoSwift` fork! I quickly connect it up in the main application
logic, making sure to use `mach_absolute_time` for `wineGetTickCount`, and,
at long last:

{% include figure.html url="/img/2021-01-11-launching-final-fantasy-xiv-on-macos-2.png" 
description="The FINAL FANTASY XIV main menu. Finally." %}

[So what do we do now?][southpark]

[ProcExp]: https://docs.microsoft.com/en-us/sysinternals/downloads/process-explorer
[XIVDev]: https://xiv.dev/sqexarg
[Blowfish]: https://en.wikipedia.org/wiki/Blowfish_(cipher)
[GetTickCountMS]: https://docs.microsoft.com/en-us/windows/win32/api/sysinfoapi/nf-sysinfoapi-gettickcount
[syncc]: https://github.com/wine-mirror/wine/blob/7d3186e029fb4cf417fab59483a37d8aece95b5d/dlls/kernel32/sync.c#L101
[fdc]: https://github.com/wine-mirror/wine/blob/7d3186e029fb4cf417fab59483a37d8aece95b5d/server/fd.c#L386
[requestc]: https://github.com/wine-mirror/wine/blob/e909986e6ea5ecd49b2b847f321ad89b2ae4f6f1/server/request.c#L527
[winepatch]: https://www.winehq.org/pipermail/wine-devel/2019-November/155652.html
[vcredist]: https://support.microsoft.com/en-au/help/2977003/the-latest-supported-visual-c-downloads
[crypto]: https://github.com/soffes/crypto
[CryptoSwift]: https://github.com/krzyzanowskim/CryptoSwift
[XIVLauncherBlowfish]: https://github.com/goatcorp/FFXIVQuickLauncher/blob/be8cc59ca6616cd6e5a873bc6d1e9237ad9a4deb/XIVLauncher/Encryption/Blowfish.cs
[Endianness]: https://en.wikipedia.org/wiki/Endianness
[bitconverter]: https://referencesource.microsoft.com/#mscorlib/system/bitconverter.cs
[license]: https://github.com/krzyzanowskim/CryptoSwift/blob/e7459377e0f48779c69a9b20da21fb9224d94ac8/LICENSE#L1
[southpark]: https://www.youtube.com/watch?v=tg2PD-dwsIw