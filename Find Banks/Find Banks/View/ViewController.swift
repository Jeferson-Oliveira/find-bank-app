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
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    private var markers = [GMSMarker]()
    private let locationManager = CLLocationManager()

    let disposedBag = DisposeBag()
    let viewModel: FindBanksViewModelProtocol = FindBanksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupMapView()
        setupInputs()
        setupOutputs()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    private func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    private func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.appearAnimation = .pop
        marker.isFlat = true
        marker.icon = #imageLiteral(resourceName: "ic_itau")
        marker.map = self.mapView
        markers.append(marker)
    }
    
    private func removeAllMarkers() {
        markers.forEach { $0.map = nil }
    }
    
    private func changeCamera(toLocation: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: toLocation, zoom: 15)
    }
    
    private func setupInputs() {
        mapView.rx.idleAt.subscribe(onNext: { [weak self] cameraPosition in
            self?.viewModel
                    .inputs
                    .findBanksAction.onNext(.init(latitude: cameraPosition.target.latitude,
                                              longitude: cameraPosition.target.longitude))
        }).disposed(by: disposedBag)
    }
    
    private func setupOutputs() {
        viewModel.outputs.neablyBanks.drive(onNext: { [weak self] banks in
            self?.removeAllMarkers()
            banks.forEach { bank in
                self?.addMarker(position: .init(latitude: bank.geometry.location.latitude,
                                                longitude: bank.geometry.location.longitude))
            }
        }).disposed(by: disposedBag)
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
        viewModel.inputs.findBanksAction.onNext(currentLocation)
        locationManager.stopUpdatingLocation()
    }

}

