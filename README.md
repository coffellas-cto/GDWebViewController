GDWebViewController v1.4.1
===================

A simple view controller for navigating web pages using WKWebView. iOS 8.1+.

Supports Swift 3.0 and iOS 10 SDK.
For Swift 2 support go [here](https://github.com/coffellas-cto/GDWebViewController/releases/tag/v1.3)

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
#### Properties
```swift
weak var delegate: GDWebViewControllerDelegate?
```
An object to serve as a delegate which conforms to GDWebViewNavigationToolbarDelegate protocol.

```swift
var progressIndicatorStyle: GDWebViewControllerProgressIndicatorStyle = .Both
```
The style of progress indication visualization. Can be one of four values: .ActivityIndicator, .ProgressView, .Both, .None

```swift
var allowsBackForwardNavigationGestures: Bool
```
A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations. The default value is false.

```swift
var showsToolbar: Bool
```
A boolean value if set to true shows the toolbar; otherwise, hides it.

```swift
var showsStopRefreshControl: Bool
```
A boolean value if set to true shows the refresh control (or stop control while loading) on the toolbar; otherwise, hides it.

```swift
var toolbar: GDWebViewNavigationToolbar
```
The navigation toolbar object (read-only).

```swift
var allowJavaScriptAlerts: Bool
```
Boolean flag which indicates whether JavaScript alerts are allowed. Default is `true`.
    
#### Methods
```swift
func loadURLWithString(_ URLString: String)
```
Navigates to an URL created from provided string.

```swift
func loadURL(_ URL: Foundation.URL, cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 0)
```
Navigates to the URL.

```swift
func showToolbar(_ show: Bool, animated: Bool)
```
Shows or hides toolbar.

```swift
func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((AnyObject?, NSError?) -> Void)?)
```
Evaluates the given JavaScript string.

#### GDWebViewControllerDelegate Methods
```swift
@objc public protocol GDWebViewControllerDelegate {
    @objc optional func webViewController(_ webViewController: GDWebViewController, didChangeURL newURL: URL?)
    @objc optional func webViewController(_ webViewController: GDWebViewController, didChangeTitle newTitle: NSString?)
    @objc optional func webViewController(_ webViewController: GDWebViewController, didFinishLoading loadedURL: URL?)
    @objc optional func webViewController(_ webViewController: GDWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    @objc optional func webViewController(_ webViewController: GDWebViewController, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void)
    @objc optional func webViewController(_ webViewController: GDWebViewController, didReceiveAuthenticationChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    @objc optional func webViewWillAppear(_ webViewController: GDWebViewController)
    @objc optional func webViewDidAppear(_ webViewController: GDWebViewController)
    @objc optional func webViewWillDisappear(_ webViewController: GDWebViewController)
    @objc optional func webViewDidDisappear(_ webViewController: GDWebViewController)
    @objc optional func webViewViewDidLoad(_ webViewController: GDWebViewController)
}
```

Notice:<br />
You must do `import WebKit` if you use last three methods from `GDWebViewControllerDelegate` description.

## GDWebViewNavigationToolbar Interface
#### Properties
```swift
var toolbarTintColor: UIColor?
```
The tint color to apply to the toolbar button items.

```swift
var toolbarBackgroundColor: UIColor?
```
The toolbar's background color.

```swift
var toolbarTranslucent: Bool
```
A Boolean value that indicates whether the toolbar is translucent (true) or not (false).

## License
Published under MIT license. If you have any feature requests, please create an issue. Smart pull requests are also welcome.
