//
//  GDWebViewController.swift
//  GDWebBrowserClient
//
//  Created by Alex G on 03.12.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit
import WebKit

enum GDWebViewControllerProgressIndicatorStyle {
    case ActivityIndicator
    case ProgressView
    case Both
}

@objc protocol GDWebViewControllerDelegate {
}

class GDWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    // MARK: Public Properties
    weak var delegate: GDWebViewControllerDelegate?
    var progressIndicatorStyle: GDWebViewControllerProgressIndicatorStyle? = .ProgressView
    
    // MARK: Private Properties
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView?
    private var progressView: UIProgressView!
    
    // MARK: Public Methods
    
    func loadURLWithString(URLString: String) {
        if let URL = NSURL(string: URLString) {
            if (URL.scheme != nil) && (URL.host != nil) {
                loadURL(URL)
                return
            } else {
                loadURLWithString("http://\(URLString)")
                return
            }
        }
    }
    
    func loadURL(URL: NSURL, cachePolicy: NSURLRequestCachePolicy = .UseProtocolCachePolicy, timeoutInterval: NSTimeInterval = 0) {
        webView.loadRequest(NSURLRequest(URL: URL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval))
    }
    
    // MARK: WKNavigationDelegate Methods
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        animateActivityIdicator(false)
        showError(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        animateActivityIdicator(false)
        showError(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        animateActivityIdicator(false)
    }
    
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
    }
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if (progressIndicatorStyle == .ActivityIndicator) || (progressIndicatorStyle == .Both) {
            animateActivityIdicator(true)
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.Allow)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    
    // MARK: Some Private Methods
    
    private func showError(errorString: String?) {
        var alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func animateActivityIdicator(animate: Bool) {
        if animate {
            if activityIndicator == nil {
                activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPointZero, size: CGSize(width: CGRectGetWidth(webView.frame), height: CGRectGetHeight(webView.frame))))
                activityIndicator?.backgroundColor = UIColor(white: 0, alpha: 0.2)
                activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
                activityIndicator?.hidesWhenStopped = true
                activityIndicator?.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                webView.addSubview(activityIndicator!)
            }
            
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    // MARK: KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {        
        if keyPath == "estimatedProgress" {
            if (progressIndicatorStyle == .ProgressView) || (progressIndicatorStyle == .Both) {
                if let newValue = change[NSKeyValueChangeNewKey] as? NSNumber {
                    if progressView == nil {
                        progressView = UIProgressView(frame: CGRectMake(0, 0, CGRectGetWidth(webView.frame), 4))
                        progressView.autoresizingMask = .FlexibleWidth | .FlexibleTopMargin
                        webView.addSubview(progressView)
                    }
                    
                    progressView.progress = newValue.floatValue
                    if progressView.progress == 1 {
                        progressView.progress = 0
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.progressView.alpha = 0
                        })
                    } else if progressView.alpha == 0 {
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.progressView.alpha = 1
                        })
                    }
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override init() {
        super.init()
        
        webView = WKWebView()
        webView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        webView.navigationDelegate = self
        webView.UIDelegate = self
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

}
