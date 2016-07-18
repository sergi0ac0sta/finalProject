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
    private let locationManager = CLLocationManager()
    private var prevLocation: CLLocation? = nil
    private var pointDistance: Double = 0.0
    private var capturedPoints: [CLLocation] = [CLLocation]()
    private var overlays: [MKOverlay] = [MKOverlay]()
    
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
    
    override func viewWillAppear(animated: Bool) {
        inView = true
        saveButton.enabled = false
        capturedPoints.removeAll()
        
        if capture {
            saveButton.enabled = true
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        inView = false
        prevLocation = nil
        mapView.removeOverlays(overlays)
        overlays.removeAll()
        
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextView = segue.destinationViewController as! SaveRouteViewController
        nextView.capturedPoints = capturedPoints
    }
    
    func setPin(title: String, subtitle: String, latitude: Double, longitude: Double) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.subtitle = subtitle
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return pin
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse && capture {
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if capture && inView {
            let location = locationManager.location!
            capturedPoints.append(location)
        
            let locationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let locationMapItem = MKMapItem(placemark: locationPlacemark)
            if let prev = prevLocation {
                pointDistance += location.distanceFromLocation(prev)
                if pointDistance > 0 {
                    let prevPlacemark = MKPlacemark(coordinate: prev.coordinate, addressDictionary: nil)
                    let prevMapItem = MKMapItem(placemark: prevPlacemark)
                
                    route(prevMapItem, destination: locationMapItem)
                    pointDistance = 0
                }
            }
            prevLocation = location
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description)
    }
    
    func route(origin: MKMapItem, destination: MKMapItem) {
        let request = MKDirectionsRequest()
        request.source = origin
        request.destination = destination
        request.transportType = .Any
        
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler({
            (response: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                print(error!.description)
            } else {
                self.showRoute(response!, origin: origin)
            }
        })
    }
    
    func showRoute(response: MKDirectionsResponse, origin: MKMapItem) {
        for route in response.routes {
            mapView.addOverlay(route.polyline, level: .AboveLabels)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        overlays.append(overlay)
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
}
