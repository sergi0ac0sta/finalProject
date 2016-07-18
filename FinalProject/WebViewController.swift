//
//  WebViewController.swift
//  FinalProject
//
//  Created by Sergio Acosta on 17/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    var urls: String?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let curl = NSURL(string: urls!)
        let request = NSURLRequest(URL: curl!)
        webView.loadRequest(request)
    }
}
