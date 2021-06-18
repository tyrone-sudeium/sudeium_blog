---
layout: post
title: "Build for x86 Simulator on Apple Silicon Macs"
date: 2021-06-18 17:17:00 +1100
comments: true
categories: [Programming]
---

If you've got an M1 Mac you might have noticed that when you run Xcode in native
Apple Silicon mode, when building for the simulator it'll use the `arm64` ARCH.
This is good, except if you've got a lot of legacy dependencies that haven't
been updated to support XCFrameworks. Most binary dependencies out there still
assume SDK = `iphonesimulator` means ARCH = `x86_64`, which will result in
linker errors.

One simple fix is to simply run Xcode in Rosetta. This will make it act just
like you're still on an Intel Mac, and the Simulator will build for `x86_64`.
However doing this means you miss out on some of that legendary Apple Silicon
compile performance.

To workaround this, you can basically force your project to cross-compile
when using the `iphonesimulator` SDK to the `x86_64` ARCH.

## Xcconfig

If you're using `.xcconfig` files, simply add this to your common `.xcconfig` if
you've got one, or into all your `.xcconfig` files otherwise:

    ARCHS[sdk=iphonesimulator*] = x86_64

## Project Settings

If you're not using `.xcconfig`, you should think about starting, otherwise you
can manually edit your project's Build Settings. Click on your Project in the
navigatory, make sure the project is selected under PROJECT and not a TARGET,
then go to Build Settings. Make sure you've got "All" settings selected so you
can see the relevant setting.

{% include figure.html url="/img/2021-06-18-build-for-x86-simulator-on-apple-silicon-macs.jpg" 
description="The build settings editor" %}

Under `Architectures`, expand it until you can see `Debug` and `Release`, and
another configurations your project has. Now next to the `Debug` and `Release`
when you hover over you'll see a `+`. Press this, and change the drop down to
`Any iOS Simulator SDK`. Now, change the setting to `Other`, and type in
`x86_64`. Repeat this for every configuration. Your Build Settings editor should
look like the above.

## CocoaPods

If you're using CocoaPods then the `Pods.xcodeproj` it generates will also need
these Build Settings applied. Thankfully you can make one small amendment to
your `Podfile` to make it apply for all your dependencies.

{% highlight ruby linenos %}
target 'DemoApp' do
  # ... all your dependencies etc.

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Force CocoaPods targets to always build for x86_64
        config.build_settings['ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
      end
    end
  end
end
{% endhighlight %}

Now simply re-run `pod install` and it should apply the new Build Setting across
all your Pods!

## Conclusion

It's not necessary to run all of Xcode and its compilers in Rosetta to continue
to use Simulators built for Intel, you can force the compilers to always build
for `x86_64` and Rosetta and the Simulator are smart enough to only run your
app's process in Rosetta. This allows us to reap the benefits of Apple Silicon
on our development machines today while still giving our dependencies time to
get their act together and adopt XCFrameworks and rebuild for 
`iphonesimulator-arm64`.
