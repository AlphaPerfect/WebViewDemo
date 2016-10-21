//
//  ViewController.swift
//  WebViewDemo
//
//  Created by wangyuanyuan on 18/10/2016.
//  Copyright © 2016 wangyuanyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshOrCancelButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        url.delegate = self
        webView.delegate = self
        
        goBackButton.isEnabled = false
        goForwardButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let urlString = URL(string: url.text!) {
            webView.loadRequest(URLRequest(url: urlString))
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SwitchRefreshAndCancelState(toRefresh: false)
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.url.text = request.url?.absoluteString
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.canGoBack {
            goBackButton.isEnabled = true
        } else {
            goBackButton.isEnabled = false
        }
        
        if webView.canGoForward {
            goForwardButton.isEnabled = true
        } else {
            goForwardButton.isEnabled = false
        }

        SwitchRefreshAndCancelState(toRefresh: true)
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        SwitchRefreshAndCancelState(toRefresh: true)
//        
//        let alertController = UIAlertController(title: "ERROR", message: error.localizedDescription, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func BackwardTapped(_ sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func ForwardTapped(_ sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func RefreshTapped(_ sender: AnyObject) {
        if webView.isLoading {
            webView.stopLoading()
            SwitchRefreshAndCancelState(toRefresh: true)
            activityIndicator.stopAnimating()
        } else {
            webView.reload()
        }
    }

    func SwitchRefreshAndCancelState(toRefresh: Bool) {
        let rc: UIBarButtonItem!
        if toRefresh {
            rc = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.RefreshTapped(_:)))
        } else {
            rc = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(ViewController.RefreshTapped(_:)))
        }
        toolBar.items?[(toolBar.items?.count)!-1] = rc
    }
}

