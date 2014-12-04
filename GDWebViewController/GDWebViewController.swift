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
    case None
}

@objc protocol GDWebViewControllerDelegate {
    optional func webViewController(webViewController: GDWebViewController, didChangeURL newURL: NSURL?)
    optional func webViewController(webViewController: GDWebViewController, didChangeTitle newTitle: NSString?)
}

class GDWebViewController: UIViewController, WKNavigationDelegate, GDWebViewNavigationToolbarDelegate {
    
    // MARK: Public Properties
    weak var delegate: GDWebViewControllerDelegate?
    var progressIndicatorStyle: GDWebViewControllerProgressIndicatorStyle? = .Both
    var allowsBackForwardNavigationGestures: Bool {
        get {
            return webView.allowsBackForwardNavigationGestures
        }
        set(value) {
            webView.allowsBackForwardNavigationGestures = value
        }
    }
    
    var showToolbar: Bool {
        set(value) {
            self.toolbarHeight = value ? 44 : 0
        }
        
        get {
            return self.toolbarHeight == 44
        }
    }
    
    // MARK: Private Properties
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    private var progressView: UIProgressView!
    private var toolbarContainer: GDWebViewNavigationToolbar!
    private var toolbarHeightConstraint: NSLayoutConstraint!
    private var toolbarHeight: CGFloat = 0
    
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
    
    func showToolbar(show: Bool, animated: Bool) {
        self.showToolbar = show
        
        if toolbarHeightConstraint != nil {
            UIView.animateWithDuration(animated ? 0.2 : 0, animations: { () -> Void in
                self.toolbarHeightConstraint.constant = self.toolbarHeight
            })
        }
    }
    
    // MARK: GDWebViewNavigationToolbarDelegate Methods
    func webViewNavigationToolbarGoBack(toolbar: GDWebViewNavigationToolbar) {
        webView.goBack()
    }
    
    func webViewNavigationToolbarGoForward(toolbar: GDWebViewNavigationToolbar) {
        webView.goForward()
    }
    
    func webViewNavigationToolbarRefresh(toolbar: GDWebViewNavigationToolbar) {
        webView.reload()
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
        backForwardListChanged()
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
                activityIndicator = UIActivityIndicatorView()
                activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.2)
                activityIndicator.activityIndicatorViewStyle = .WhiteLarge
                activityIndicator.hidesWhenStopped = true
                activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.view.addSubview(activityIndicator!)
                
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[activityIndicator]-0-|", options: nil, metrics: nil, views: ["activityIndicator": activityIndicator]))
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[activityIndicator]-0-|", options: nil, metrics: nil, views: ["activityIndicator": activityIndicator]))
            }
            
            activityIndicator.startAnimating()
        } else if activityIndicator != nil {
            activityIndicator.stopAnimating()
        }
    }
    
    private func progressChanged(newValue: NSNumber) {
        if progressView == nil {
            progressView = UIProgressView()
            progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.view.addSubview(progressView)
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[progressView]-0-|", options: nil, metrics: nil, views: ["progressView": progressView]))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[progressView(2)]", options: nil, metrics: nil, views: ["progressView": progressView]))
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
    
    private func backForwardListChanged() {
        toolbarContainer.backButtonItem?.enabled = webView.canGoBack
        toolbarContainer.forwardButtonItem?.enabled = webView.canGoForward
    }
    
    // MARK: KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case "estimatedProgress":
            if (progressIndicatorStyle == .ProgressView) || (progressIndicatorStyle == .Both) {
                if let newValue = change[NSKeyValueChangeNewKey] as? NSNumber {
                    progressChanged(newValue)
                }
            }
        case "URL":
            delegate?.webViewController?(self, didChangeURL: webView.URL)
        case "title":
            delegate?.webViewController?(self, didChangeTitle: webView.title)
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up toolbarContainer
        self.view.addSubview(toolbarContainer)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[toolbarContainer]-0-|", options: nil, metrics: nil, views: ["toolbarContainer": toolbarContainer]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[toolbarContainer]-0-|", options: nil, metrics: nil, views: ["toolbarContainer": toolbarContainer]))
        toolbarHeightConstraint = NSLayoutConstraint(item: toolbarContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: toolbarHeight)
        toolbarContainer.addConstraint(toolbarHeightConstraint)
        
        // Set up webView
        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[webView]-0-|", options: nil, metrics: nil, views: ["webView": webView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-0-[webView]-0-[toolbarContainer]|", options: nil, metrics: nil, views: ["webView": webView, "toolbarContainer": toolbarContainer, "topGuide": self.topLayoutGuide]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        webView.stopLoading()
    }
    
    override init() {
        super.init()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        toolbarContainer = GDWebViewNavigationToolbar(delegate: self)
        toolbarContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

}
