//
//  ViewController.swift
//  ESigBrowser
//
//  Created by Derek Turner on 8/16/16.
//  Copyright © 2016 Cash America. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    var ncpView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        self.webView.UIDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string:"http://www.mymrpayroll.com")
        webView.loadRequest(NSURLRequest(URL:url!))
    }
    
    
    // this handles target=_blank & window.open links by opening them in a new view
    func webView(webView: WKWebView,
        createWebViewWithConfiguration configuration: WKWebViewConfiguration,
        forNavigationAction navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                let url = navigationAction.request.URL
                
                webView.loadRequest(NSURLRequest(URL:url!))
        }
        return nil
    }
    
}
