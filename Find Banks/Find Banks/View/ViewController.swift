//
//  ViewController.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import UIKit
import GoogleMaps
import RxGoogleMaps
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupMapView()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.appearAnimation = .pop
        marker.isFlat = true
        marker.map = self.mapView
    }

    func changeCamera(toLocation: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: toLocation, zoom: 15)
    }

}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse  {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {return}
        changeCamera(toLocation: currentLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }

}
