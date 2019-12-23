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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLocationManager()
        
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
        gestureRecognize.minimumPressDuration = 2
        
        map.addGestureRecognizer(gestureRecognize)
    }
    
    @objc func market(gesture: UIGestureRecognizer) {
        
        if (gesture.state == UIGestureRecognizer.State.began) {
            let pointSelected = gesture.location(in: self.map)
            let coord = map.convert(pointSelected, toCoordinateFrom: self.ma)
            
            let note = MKPointAnnotation()
            
            note.coordinate.latitude = coord.latitude
            note.coordinate.longitude = coord.longitude
            
            note.title = "Pressionei aqui"
            note.subtitle = "Estou aqui"
            
            map.addAnnotation(note)
        }
        
        print ("pressionado")
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
    


}

