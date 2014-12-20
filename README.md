# BTFLeakDetect

[![CI Status](http://img.shields.io/travis/Mikkel Gravgaard/BTFLeakDetect.svg?style=flat)](https://travis-ci.org/Mikkel Gravgaard/BTFLeakDetect)
[![Version](https://img.shields.io/cocoapods/v/BTFLeakDetect.svg?style=flat)](http://cocoadocs.org/docsets/BTFLeakDetect)
[![License](https://img.shields.io/cocoapods/l/BTFLeakDetect.svg?style=flat)](http://cocoadocs.org/docsets/BTFLeakDetect)
[![Platform](https://img.shields.io/cocoapods/p/BTFLeakDetect.svg?style=flat)](http://cocoadocs.org/docsets/BTFLeakDetect)

BTFLeakDetect helps detecting whether UIViewController instances leak after they are dismissed from a parent view controller or popped from a navigation view controller.

## Usage

You can enable BTFLeakDetect by simply adding your `application:didFinishLaunchingWithOptions:`  either

```
[BTFLeakDetect enableWithException]
```

which throws an exception when a leak is detected, or 

```
[BTFLeakDetect enableWithLogging];
```

if you just want to get noticed in the log.

Enabling exceptions is adviced, since this helps you catch the leak as early as possible in the development fase. This way there's less code to consider, meaning less need for instrumentation.

You probably want to enable BTFLeakDetect in development only, so wrapping in `#ifdef DEBUG` or similar is also a good idea.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

BFTLeakDetect will work with iOS 7 and up. 

## Installation

BTFLeakDetect is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "BTFLeakDetect"

## Author

Mikkel Gravgaard, mikkel@klokke.dk

## License

BTFLeakDetect is available under the MIT license. See the LICENSE file for more info.

