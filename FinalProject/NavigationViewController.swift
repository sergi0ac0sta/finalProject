//
//  NavigationViewController.swift
//  FinalProject
//
//  Created by Sergio Acosta on 11/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "routeSegue" && segue.identifier != "qrSegue" {
            let origin = sender as! QRViewController
            let vc = segue.destination as! WebViewController
            origin.session?.stopRunning()
            vc.urls = origin.urls
        }
    }
}
