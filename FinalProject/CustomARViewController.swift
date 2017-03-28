//
//  CustomARViewController.swift
//  FinalProject
//
//  Created by Sergio A Acosta on 3/28/17.
//  Copyright © 2017 Sergio Acosta. All rights reserved.
//

import UIKit
import CoreLocation

class CustomARViewController: UIViewController, ARDataSource {
    var route: Route? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAR()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let view = TestAnnotationView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        return view
    }
    
    func startAR() {
        let delta = 0.005
        let location: CLLocation = CLLocationManager().location!
        let locations = convertIntoKeyValuePair()
        
        
        let dummyAnnotations = obtenAnotaciones(locations: locations, latitud: location.coordinate.latitude, longitud: location.coordinate.longitude, delta: delta, numeroDeElementos: locations.count)
        
        let arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(dummyAnnotations)
        arViewController.uiOptions.debugEnabled = true
        arViewController.uiOptions.closeButtonEnabled = true
        //arViewController.interfaceOrientationMask = .landscape
        arViewController.onDidFailToFindLocation = {
                [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
                // Show alert and dismiss
        }
        self.present(arViewController, animated: true, completion: nil)
    }
    
    private func obtenAnotaciones( locations: [String:[Double:Double]], latitud: Double, longitud: Double, delta: Double, numeroDeElementos: Int) -> Array<ARAnnotation>{
        
        var anotaciones: [ARAnnotation] = []

        for (name,coords) in locations
        {
            let anotacion = ARAnnotation()
            anotacion.location = self.obtenerPosiciones(latitud: (coords.first?.key)!, longitud: (coords.first?.value)!, delta: delta)
            anotacion.title = name
            anotaciones.append(anotacion)
        }
        return anotaciones
        
    }
    
    
    private func obtenerPosiciones( latitud: Double, longitud: Double, delta: Double )-> CLLocation{
        var lat = latitud
        var lon = longitud
        let latDelta = -(delta/2) + drand48() * delta
        let lonDelta = -(delta/2) + drand48() * delta
        lat = lat + latDelta
        lon = lon + lonDelta
        return CLLocation(latitude: lat, longitude: lon)    
    }
    
    func convertIntoKeyValuePair() -> [String:[Double:Double]] {
        var coords: [String:[Double: Double]] = [:]
        let points:[String] = (route?.locationPoints?.components(separatedBy: "|"))!
        
        for point in points {
            if point.contains(":"){
                let latLog = point.components(separatedBy: ":")
                
                var c: [Double: Double] = [:]
                if latLog.count == 3 {
                    c.updateValue(Double(latLog[2])!, forKey: Double(latLog[1])!)
                    coords.updateValue(c, forKey: String(latLog[0])!)
                }
            }
        }
        return coords
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
