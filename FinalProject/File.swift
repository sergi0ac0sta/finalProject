//
//  SavedPoint.swift
//  FinalProject
//
//  Created by Sergio Acosta on 19/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit
import CoreLocation

class SavedPoint{
    var point: CLLocation
    var image: UIImage?
    
    init(point: CLLocation, image: UIImage?) {
        self.point = point
        self.image = image
    }
}