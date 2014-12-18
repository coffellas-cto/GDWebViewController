//
//  AppDelegate.swift
//  GDWebBrowserClient
//
//  Created by Alex G on 03.12.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GDWebViewControllerDelegate {

    // MARK: Properties
    var window: UIWindow?
    
    // MARK: Private Properties
    var webVC = GDWebViewController()
    var navVC = UINavigationController()
    
    // MARK: GDWebViewControllerDelegate Methods
    
    func webViewController(webViewController: GDWebViewController, didChangeTitle newTitle: NSString?) {
        navVC.navigationBar.topItem?.title = newTitle
    }
    
    func webViewController(webViewController: GDWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let host = navigationAction.request.URL.host?
        if host == "github.com" {
            decisionHandler(.Allow)
            return
        }
        
        println(navigationAction.request.URL.host)
        decisionHandler(.Cancel)
    }
    
    // MARK: Life Cycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        navVC.setViewControllers([webVC], animated: false)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        webVC.delegate = self
        webVC.loadURLWithString("github.com")
        webVC.toolbar.toolbarTintColor = UIColor.darkGrayColor()
        webVC.toolbar.toolbarBackgroundColor = UIColor.whiteColor()
        webVC.toolbar.toolbarTranslucent = false
        webVC.allowsBackForwardNavigationGestures = true
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
            self.webVC.showToolbar(true, animated: true)
        })
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

}

