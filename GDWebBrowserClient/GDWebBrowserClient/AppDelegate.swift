//
//  AppDelegate.swift
//  GDWebBrowserClient
//
//  Created by Alex G on 03.12.14.
//  Copyright (c) 2015 Alexey Gordiyenko. All rights reserved.
//

import UIKit
import WebKit

let gHost = "apple.com"
let gShowAlertOnDidFinishLoading = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GDWebViewControllerDelegate {
    
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: Private Properties
    var webVC = GDWebViewController()
    var navVC = UINavigationController()
    
    // MARK: GDWebViewControllerDelegate Methods
    
    func webViewController(_ webViewController: GDWebViewController, didChangeTitle newTitle: NSString?) {
        navVC.navigationBar.topItem?.title = newTitle as? String
    }
    
    func webViewController(_ webViewController: GDWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let URL = navigationAction.request.url as URL?,
            let host = URL.host as NSString?
        {
            let testSubdomain = "." + gHost
            if host as String == gHost || host.range(of: testSubdomain, options: .caseInsensitive).location != NSNotFound {
                decisionHandler(.allow)
                return
            }
        }
        
        print(navigationAction.request.url?.host)
        decisionHandler(.cancel)
    }
    
    func webViewController(_ webViewController: GDWebViewController, didFinishLoading loadedURL: URL?) {
        if gShowAlertOnDidFinishLoading {
            webViewController.evaluateJavaScript("alert('Loaded!')", completionHandler: nil)
        }
    }
    
    // MARK: Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        navVC.setViewControllers([webVC], animated: false)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        webVC.delegate = self
        webVC.loadURLWithString(gHost)
        webVC.toolbar.toolbarTintColor = UIColor.darkGray
        webVC.toolbar.toolbarBackgroundColor = UIColor.white
        webVC.toolbar.toolbarTranslucent = false
        webVC.allowsBackForwardNavigationGestures = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.webVC.showToolbar(true, animated: true)
        })
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

