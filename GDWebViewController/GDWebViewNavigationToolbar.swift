//
//  GDWebViewNavigationToolbar.swift
//  GDWebBrowserClient
//
//  Created by Alex G on 04.12.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

@objc protocol GDWebViewNavigationToolbarDelegate {
    func webViewNavigationToolbarGoBack(toolbar: GDWebViewNavigationToolbar)
    func webViewNavigationToolbarGoForward(toolbar: GDWebViewNavigationToolbar)
    func webViewNavigationToolbarRefresh(toolbar: GDWebViewNavigationToolbar)
}

class GDWebViewNavigationToolbar: UIView {
    
    // MARK: Public Properties
    
    var toolbar: UIToolbar! {
        get {
            return _toolbar
        }
    }
    weak var delegate: GDWebViewNavigationToolbarDelegate?
    var backButtonItem: UIBarButtonItem? {
        get {
            return _backButtonItem
        }
    }
    var forwardButtonItem: UIBarButtonItem? {
        get {
            return _forwardButtonItem
        }
    }
    var refreshButtonItem: UIBarButtonItem? {
        get {
            return _refreshButtonItem
        }
    }
    
    // MARK: Private Properties
    
    private var _toolbar: UIToolbar!
    private var _backButtonItem: UIBarButtonItem!
    private var _forwardButtonItem: UIBarButtonItem!
    private var _refreshButtonItem: UIBarButtonItem!
    
    // MARK: Navigation Methods
    func goBack() {
        delegate?.webViewNavigationToolbarGoBack(self)
    }
    
    func goForward() {
        delegate?.webViewNavigationToolbarGoForward(self)
    }
    
    func refresh() {
        delegate?.webViewNavigationToolbarRefresh(self)
    }
    
    // MARK: Life Cycle
    
    init(delegate: GDWebViewNavigationToolbarDelegate) {
        super.init()
        self.delegate = delegate
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (_toolbar == nil) {
            _toolbar = UIToolbar()
            _toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(_toolbar)
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[toolbar]-0-|", options: nil, metrics: nil, views: ["toolbar": _toolbar]))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[toolbar]-0-|", options: nil, metrics: nil, views: ["toolbar": _toolbar]))
            
            // Set up _toolbar
            _backButtonItem = UIBarButtonItem(title: "\u{25C0}\u{FE0E}", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
            _backButtonItem.enabled = false
            _forwardButtonItem = UIBarButtonItem(title: "\u{25B6}\u{FE0E}", style: UIBarButtonItemStyle.Plain, target: self, action: "goForward")
            _forwardButtonItem.enabled = false
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            _refreshButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
            _toolbar.setItems([_backButtonItem, _forwardButtonItem, flexibleSpace, _refreshButtonItem], animated: false)
        }
    }

}
