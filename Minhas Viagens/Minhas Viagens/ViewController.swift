//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by César  Ferreira on 23/12/19.
//  Copyright © 2019 César  Ferreira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var travel: Dictionary<String, String> = [:]
    var indexSelected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let index = indexSelected {
            if (index == -1) {
                setupLocationManager()
            } else {
                displayNote( travel: travel )
            }
        }
        
        
        gestureDetection()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func gestureDetection() {
        let gestureRecognize = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.market(gesture:)))
        gestureRecognize.minimumPressDuration = 1
        
        map.addGestureRecognizer(gestureRecognize)
    }
    
    @objc func market(gesture: UIGestureRecognizer) {
        
        if (gesture.state == UIGestureRecognizer.State.began) {
            let pointSelected = gesture.location(in: self.map)
            let coord = map.convert(pointSelected, toCoordinateFrom: self.map)
            
        
            var localCompleto = ""
            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (local, error) in
                
                if (error == nil) {
                    if let dataLocal = local?.first {
                        if let name = dataLocal.name {
                            localCompleto = name
                        } else {
                            if let endereco = dataLocal.thoroughfare {
                                localCompleto = endereco
                            }
                        }
                    }
                    
                    
                    self.travel = ["local": localCompleto, "latitude": String(coord.latitude), "longitude": String(coord.longitude) ]
                    TravelUserDefaults().saveTravel(travel: self.travel)
                    
                    self.displayNote(travel: self.travel)
                    
                } else {
                    print (error)
                }
                
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if ( status != .authorizedWhenInUse ) {
            
            let alertController = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para acesso a sua localização", preferredStyle: .alert)
            
            let actionConfig = UIAlertAction(title: "Abrir configurações", style: .default) { (UIAlertAction) in
                
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
                
            }
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present( alertController, animated: true, completion: nil )
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local = locations.last!
        
        let deltaLat: CLLocationDegrees = 0.05
        let deltaLog: CLLocationDegrees = 0.05
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(local.coordinate.latitude, local.coordinate.longitude)
        let area: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLog)
        let region: MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: area)
        map.setRegion(region, animated: true)
    }
    
    private func displayNote(travel: Dictionary<String, String>) {
        
        if let localTravel = travel["local"] {
            if let latitudeString = travel["latitude"] {
                if let longitudeString = travel["longitude"] {
                    if let latitude = Double(latitudeString) {
                        if let longitude = Double(longitudeString) {
                            
                            let note = MKPointAnnotation()
                            
                            note.coordinate.latitude = latitude
                            note.coordinate.longitude = longitude
                            
                            note.title = localTravel
                            
                            self.map.addAnnotation(note)
                            
                            let deltaLat: CLLocationDegrees = 0.05
                            let deltaLog: CLLocationDegrees = 0.05
                            
                            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                            let area: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLog)
                            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: area)
                            map.setRegion(region, animated: true)
                        }
                    }
                }
            }
        }
    }

}

