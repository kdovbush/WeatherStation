//
//  HeatIndexInfoViewController.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 1/12/17.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

class HeatIndexInfoViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Info"
        
        automaticallyAdjustsScrollViewInsets = false
        
        if let url = URL(string: "https://en.m.wikipedia.org/wiki/Heat_index") {
            let request = URLRequest(url: url)
            webView.scalesPageToFit = true
            webView.delegate = self
            webView.loadRequest(request)
        }
    }

}

extension HeatIndexInfoViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
    
}
