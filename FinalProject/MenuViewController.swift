//
//  MenuViewController.swift
//  FinalProject
//
//  Created by Sergio Acosta on 11/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var navc: NavigationViewController?
    
    override func viewDidLoad() {
        navc = self.navigationController as! NavigationViewController?
        
        super.viewDidLoad()
    }
    
    @IBAction func routes(_ sender: Any) {
        navc?.performSegue(withIdentifier: "routeSegue", sender: self)
    }
    
    @IBAction func qr(_ sender: Any) {
        navc?.performSegue(withIdentifier: "qrSegue", sender: self)

    }
    
}
