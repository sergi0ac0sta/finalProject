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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let origin = sender as! QRViewController
        let vc = segue.destinationViewController as! WebViewController
        origin.session?.stopRunning()
        vc.urls = origin.urls
    }
}
