# video intelligence iOS SDK v2.0

<!--[![CI Status](http://img.shields.io/travis/Maksym Kravchenko/VISDK.svg?style=flat)](https://travis-ci.org/Maksym Kravchenko/VISDK)-->
[![Version](https://img.shields.io/cocoapods/v/VISDK.svg?style=flat)](https://cocoapods.org/pods/VISDK)
[![License](https://img.shields.io/cocoapods/l/VISDK.svg?style=flat)](https://github.com/maksymkravchenko/vi/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/VISDK.svg?style=flat)](https://cocoapods.org/pods/VISDK)


## Requirements

The vi iOS SDK supports iOS v8 and above and requires ARC.

#### Enable support for HTTP ads

Apple has introduced HTTPS changes that may not be supported by all Advertisers. Enforcing the need for secure ads only will impact your potential revenue.
In order to support ad requests that are made using HTTP instead of HTTPS, you need to make the following changes in your Info.plist:

```
Add the 'App Transport Security Settings' node, and
set 'Allow Arbitrary Loads' to YES
```

## Installation

### Using CocoaPods (prefered)

vi IOS SDK is available through [CocoaPods](http://cocoapods.org).
To install it, simply add the following line to your Podfile:

```ruby
pod 'VISDK'
```
Install the pod(s) by running `pod install`.
Include vi IOS SDK wherever you need it with `import VISDK`.

### Using Dynamic Framework

You can also add the vi iOS SDK as a dynamic framework to your project or workspace.

Get the latest version of [VISDK.framework](https://github.com/maksymkravchenko/vi/tree/master/VISDK/VISDK.framework) , copy it to your project’s working directory
Open Xcode, select your target, go to General tab. Add `VISDK.framework` as Embedded Binary.
Include VISDK wherever you need it with `import VISDK`.

## Usage

As part of vi iOS SDK v2.0 you can choose to display both In-Stream or Interstitial video ads.
In both cases, you would need to provide a placement and a container where the ad is to be displayed.
Make sure you hold the reference on the instance of ViAd while the ad is being rendered.

Always initialize the vi IOS SDK while launching your application

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	VISDK.sharedInstance()
	return true
}
```
### Setting up an In-Stream ad

```swift
@IBOutlet var adContainer: UIView!  // ad container. Ensure it's a part of view hierarchy
var inStreamAd: VIVideoAd!          // object to manage the ad

override func viewDidLoad() {
	super.viewDidLoad()
	// Get PlacementId from ad console
	
	let placement = VIPlacement("Your_placement_Id", options: nil);
	inStreamAd = VISDK.sharedInstance().createVideoAd(for: placement, inContainer: adContainer)
	inStreamAd.startsWhenReady = true
	inStreamAd.delegate = self
	inStreamAd.load()
}
```

Implement two delegate methods which are rather informative and doesn’t require any action from your side

```swift
func adDidReceive(_ event: VIAdEvent) {
	switch event.type {
	case .completed: break
	case .clicked: break
	case .closed: break
	case .expired: break
	case .loaded: break
	case .paused: break
	case .resumed: break
	case .started: break
	}
}

func adDidReceiveError(_ error: Error) {
	//your code
}
```
with one exception – start the ad manually if startsWhenReady is NO.

```swift
func adDidReceive(_ event: VIAdEvent) {
	switch event.type {
	case .loaded:
		inStreamAd.start()
	break
	}
}
```
you can control ad playback

```swift
inStreamAd.start()

inStreamAd.pause()

inStreamAd.resume()

inStreamAd.close()
```


### Setting up an Interstitial ad

Interstitial ads are cached locally which could take time depending on existing network conditions. Therefore, we recommend that you initiate the ad load process in advance to enhance the user experience.

```swift
let placement = VIPlacement("Your_placement_Id", options: nil)
interstitialAd = VISDK.sharedInstance().createInterstitialAd(for: placement)
interstitialAd.delegate = self
interstitialAd.load()
```
Once the ad is loaded, a corresponding event will be returned via the following callback. We strongly recommend checking whether the ad is ready isReady before displaying it.

```swift
func adDidReceive(_ event: VIAdEvent) {
	switch event.type {
	case .loaded:
		if interstitialAd.isReady {
			interstitialAd.show(from: self)
		}
	break
	}
}
```

All callbacks are fired from the main queue. You will not be required to perform any resource cleanup steps. All ad content is automatically removed once the ad has been displayed.

## Client Side Mediation: How to enable Ad mediation support

vi IOS SDK supports 3 ad providers:

* [AdMob](https://github.com/maksymkravchenko/vi/tree/master/Mediation/AdMobVIMediation)
* [MoPub](https://github.com/maksymkravchenko/vi/tree/master/Mediation/FacebookVIMediation)
* [Facebook](https://github.com/maksymkravchenko/vi/tree/master/Mediation/MopubVIMediation)


### Installation

Add files for Mediation you need from above folder links to your projects.

Mediation adapters should be added to Vi Ads where you want mediation to be present. Here is simple Mopub example:


```swift

// Create interstitialAd
let placement = VIPlacement("Your placement ID", options: nil)
let ad = VISDK.sharedInstance().createInterstitialAd(for: placement)
ad?.delegate = self

// Register Mediation adapter.
let adapter = MopubVIInterstitialAdapter(placementID: "your Mopub placement ID")
ad?.registerMediation(adapter)

```
That’s it. When there is no available vi Direct demand, the Mopub ad will be sourced and displayed in your application.

You can register several Mediation adapter of a different kind:

```swift
let adapter1 = MopubVIInterstitialAdapter(placementID: "your Mopub placement ID")
let adapter2 = FacebookVIInterstitialAdapter(placementID: "your Mopub placement ID")
ad?.registerMediations([ adapter1, adapter2 ])

```

### Mediation Samples

Detailed samples with Mediation implementations are provided in [Example](https://github.com/maksymkravchenko/vi/tree/master/Example).

To run the Example project, clone the repo, and run `pod install` from the Example directory first.

## External tracker: How add external trackers for ViAdsSDK

ViAdSDK provides ability to add global trackers on all events that happens within the SDK. This tracking should be registered just after SDK initialization. This can be achieved with implementation of VIExternalTracker protocol.

For all events, the placementID determines on which placement the event occurred.

Apart from custom events, the vi SDK also includes a pre-built adapter for `count.ly` analytics.

### count.ly adapter usage

Copy source files from Folder link: [Countly](https://github.com/maksymkravchenko/vi/tree/master/ExternalAnalytics/Countly) to your project. And register  `CountlyExternalTracker` at start of your App e.g. in `AppDelegate`:

```swift

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

	//Initialize Counlty
	let config = CountlyConfig()
	config.appKey = "Your countly app key"
	config.host = "Your countly host url path"
	
	Countly.sharedInstance().start(with: config)

	//Register externalTracker to VISDK
	VISDK.sharedInstance().register(CountlyExternalTracker())

	return true
}

```

## Documentation

Detailed documentation is [here](https://cdn.rawgit.com/vi-ai/vi-iOS-SDK/918c6c92/docs/index.html).

## Need help?

Get in touch with as at pubdev@vi.ai so we can help you get started!

## Author

video intelligence
[more information](https://docs.vi.ai)

## License

vi IOS SDK is available under the MIT license. See the LICENSE file for more info.

