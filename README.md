GDWebViewController v1.1
===================

A simple view controller for navigating web pages using WKWebView. iOS 8.1+.

Supports Swift 2.0 and iOS 9 SDK.
For Swift 1.2 support go [here](https://github.com/coffellas-cto/GDWebViewController/releases/tag/v1.0)

![App Screenshots](https://cloud.githubusercontent.com/assets/3193877/7665617/29a8672a-fbc9-11e4-98cf-41fec0f6c403.gif)

## Description
- A browser-like view controller to support web pages navigation in your Swift app.
- Supports back-forward navigation and page refresh action.
- Supports back-forward swipe gestures.
- Has built-in activity indicators (both progress view and activity indicator).

## Installation
Just grab two files `GDWebViewController.swift` and `GDWebViewNavigationToolbar.swift` into your project.<br />
You can download `GDWebBrowserClient` project as well to see how it can be used.

## GDWebViewController Interface
####Properties
`weak var delegate: GDWebViewControllerDelegate?`<br />
An object to serve as a delegate which conforms to GDWebViewNavigationToolbarDelegate protocol.

`var progressIndicatorStyle: GDWebViewControllerProgressIndicatorStyle = .Both`<br />
The style of progress indication visualization. Can be one of four values: .ActivityIndicator, .ProgressView, .Both, .None

`var allowsBackForwardNavigationGestures: Bool`<br />
A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations. The default value is false.

`var showsToolbar: Bool`<br />
A boolean value if set to true shows the toolbar; otherwise, hides it.

`var showsStopRefreshControl: Bool`<br />
A boolean value if set to true shows the refresh control (or stop control while loading) on the toolbar; otherwise, hides it.

`var toolbar: GDWebViewNavigationToolbar`<br />
The navigation toolbar object (read-only).
####Methods
`func loadURLWithString(URLString: String)`<br />
Navigates to an URL created from provided string.

`func loadURL(URL: NSURL, cachePolicy: NSURLRequestCachePolicy = .UseProtocolCachePolicy, timeoutInterval: NSTimeInterval = 0)`<br />
Navigates to the URL.

`func showsToolbar(show: Bool, animated: Bool)`<br />
Shows or hides toolbar.

####GDWebViewControllerDelegate Methods
```swift
@objc protocol GDWebViewControllerDelegate {
    optional func webViewController(webViewController: GDWebViewController, didChangeURL newURL: NSURL?)
    optional func webViewController(webViewController: GDWebViewController, didChangeTitle newTitle: NSString?)
    optional func webViewController(webViewController: GDWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    optional func webViewController(webViewController: GDWebViewController, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void);
    optional func webViewController(webViewController: GDWebViewController, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void);
}
```

Notice:<br />
You must do `import WebKit` if you use last three methods from `GDWebViewControllerDelegate` description.

## GDWebViewNavigationToolbar Interface
####Properties
`var toolbarTintColor: UIColor?`<br />
The tint color to apply to the toolbar button items.

`var toolbarBackgroundColor: UIColor?`<br />
The toolbar's background color.

`var toolbarTranslucent: Bool`<br />
A Boolean value that indicates whether the toolbar is translucent (true) or not (false).

## License
Published under MIT license. If you have any feature requests, please create an issue. Smart pull requests are also welcome.
