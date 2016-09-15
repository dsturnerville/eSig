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
    
    let webFrame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20)
    
    var defaultURL = UserDefaults().string(forKey: "default_url")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerSettingsBundle()
        let url = URL(string: (defaultURL)!)
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.userContentController.add(self, name: "done")
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        view.addSubview(webView)
        webView.load(URLRequest(url:url!))
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = webFrame
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // handle the message
        if let body = message.body as? String {
            print("Script message: \"\(body)\"")
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
        UserDefaults.standard.register(defaults: appDefaults)
    }

    // this handles target=_blank & window.open links by opening them in a new view
    func webView(_ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                let url = navigationAction.request.url
                ncpView = WKWebView(frame: webFrame)
                ncpView.load(URLRequest(url:url!))
                self.view.addSubview(ncpView)
            } 
            return nil
    }
    
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let script = "function closeWindowFromApp() {window.webkit.messageHandlers.redirect.postMessage('close');}"
//        webView.evaluateJavaScript(script, completionHandler: ({
//            (result, error) in
//            print("result: \(result), error: \(error)")
//        }))
//    }
    
    
}
