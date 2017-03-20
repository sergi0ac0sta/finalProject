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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    fileprivate let locationManager = CLLocationManager()
    fileprivate var prevLocation: CLLocation? = nil
    fileprivate var pointDistance: Double = 0.0
    
    fileprivate var currentLocation: CLLocation = CLLocation()
    fileprivate var capturedPoints: [CLLocation] = [CLLocation]()
    fileprivate var overlays: [MKOverlay] = [MKOverlay]()
    
    var capture: Bool = true
    var inView: Bool = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inView = true
        saveButton.isEnabled = false
        capturedPoints.removeAll()
        
        if capture {
            saveButton.isEnabled = true
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        inView = false
        prevLocation = nil
        mapView.removeOverlays(overlays)
        overlays.removeAll()
        
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! SaveRouteViewController
        nextView.location = currentLocation
    }
    
    func setPin(_ title: String, subtitle: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.subtitle = subtitle
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return pin
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse && capture {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if capture && inView {
            currentLocation = locationManager.location!
            capturedPoints.append(currentLocation)
        
            let locationPlacemark = MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil)
            let locationMapItem = MKMapItem(placemark: locationPlacemark)
            if let prev = prevLocation {
                pointDistance += currentLocation.distance(from: prev)
                if pointDistance > 0 {
                    let prevPlacemark = MKPlacemark(coordinate: prev.coordinate, addressDictionary: nil)
                    let prevMapItem = MKMapItem(placemark: prevPlacemark)
                
                    route(prevMapItem, destination: locationMapItem)
                    pointDistance = 0
                }
            }
            prevLocation = currentLocation
            let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func route(_ origin: MKMapItem, destination: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = origin
        request.destination = destination
        request.transportType = .any
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {
            response, error in
            if error != nil {
                print(error!)
            } else {
                self.showRoute(response!, origin: origin)
            }
        })
    }
    
    func showRoute(_ response: MKDirectionsResponse, origin: MKMapItem) {
        for route in response.routes {
            mapView.add(route.polyline, level: .aboveLabels)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        overlays.append(overlay)
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        return renderer
    }
}
