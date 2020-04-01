//
//  AppNagatorViewController.swift
//  cast
//
//  Created by DENNOUN Mohamed on 10/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit
import WebKit

class AppNagatorViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var link :String!
    class func newInstance(link: String) -> AppNagatorViewController {

              let vc = AppNagatorViewController()
              vc.link = link
              return vc
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        if link == "" {
            UIAlertController.init(title: "Empty domain", message: "Veuillez saisir une URL", preferredStyle: .alert)
        } else {
            
            let url = URL(fileURLWithPath: link)

            webView.load(URLRequest(url: url))
        }
             
           // 2
           let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
           toolbarItems = [refresh]
           navigationController?.isToolbarHidden = false
    }
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       title = webView.title
       }

   

}
