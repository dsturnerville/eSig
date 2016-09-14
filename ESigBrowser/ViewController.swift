//
//  ViewController.swift
//  ESigBrowser
//
//  Created by Derek Turner on 8/16/16.
//  Copyright © 2016 Cash America. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var ncpView: WKWebView!
    
    let webFrame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 20)
    
    //let defaultURL = NSUserDefaults.standardUserDefaults().stringForKey("default_url")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        registerSettingsBundle()
        
        let url = NSURL(string: "http://mymrpayroll.com")
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.userContentController.addScriptMessageHandler(self, name: "redirect")
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        self.webView.navigationDelegate = self
        self.webView.UIDelegate = self
        view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL:url!))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = webFrame
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        // handle the message
        if let body = message.body as? String {
            print(body)
            switch body {
            case "close":
                ncpView?.removeFromSuperview()
                ncpView = nil
            default:
                break
            }
        }
    }
    
    
    // registers Settings Bundle
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
    }

    // this handles target=_blank & window.open links by opening them in a new view
    func webView(webView: WKWebView,
        createWebViewWithConfiguration configuration: WKWebViewConfiguration,
        forNavigationAction navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                let url = navigationAction.request.URL
                ncpView = WKWebView(frame: webFrame)
                ncpView.loadRequest(NSURLRequest(URL:url!))
                self.view.addSubview(ncpView)
            } else {
                let url = NSURL(string: "http://www.cashamerica.com")
                ncpView = WKWebView(frame: webFrame)
                ncpView.loadRequest(NSURLRequest(URL:url!))
                self.view.addSubview(ncpView)
            }
            return nil
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        let script = "function closeWindowFromApp() {window.webkit.messageHandlers.redirect.postMessage('close');}"
        webView.evaluateJavaScript(script, completionHandler: ({
            (result, error) in
            print("result: \(result), error: \(error)")
        }))
    }
    
    
}
