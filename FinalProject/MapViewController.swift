//
//  MapViewController.swift
//  FinalProject
//
//  Created by Sergio Acosta on 11/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var prevLocation: CLLocation?
    private var pinDistance: Double = 0.0
    private var totalDistance: Double = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setPin(title: String, subtitle: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.subtitle = subtitle
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return pin
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location!
        
        if let prev = prevLocation {
            pinDistance += location.distanceFromLocation(prev)
            totalDistance += location.distanceFromLocation(prev)
            if pinDistance >= 50 {
                let title = "Latitud: \(Double(round(100*location.coordinate.latitude)/100))º, Longitud: \(Double(round(100*location.coordinate.longitude)/100))º."
                let subtitle = "Distancia recorrida: \(Int(round(totalDistance)))m."
                let pin: MKPointAnnotation = setPin(title, subtitle: subtitle, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                mapView.addAnnotation(pin)
                pinDistance = 0
            }
        }
        prevLocation = location
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let alert = UIAlertController(title: "ERROR", message: "Error \(error.code)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: {action in
            //
        })
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
