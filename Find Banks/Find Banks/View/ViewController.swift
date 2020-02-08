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
        requestUserLocation()
        setupMapView()
        setupInputs()
        setupOutputs()
    }
    
    private func requestUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    private func addMarker(to bank: Bank) {

        let marker = GMSMarker(position: bank.geometry.location.toCLLocation().coordinate)
        marker.appearAnimation = .pop
        marker.title = bank.name
        marker.snippet = bank.vicinity
        marker.isFlat = true
        marker.icon = #imageLiteral(resourceName: "ic_itau")
        marker.map = self.mapView
        
        markers.append(marker)
    }
    
    private func removeAllMarkers() {
        markers.forEach { $0.map = nil }
        markers.removeAll()
    }
    
    private func changeCamera(toLocation: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: toLocation, zoom: 15)
    }
    
    private func showNoAutoziredLocationAlert() {
        let alert = UIAlertController(title: "Warning".localized(withComment: .empty),
                                      message: "UserLocationAutorizeDeniedMessage".localized(withComment: .empty),
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "TryAgain".localized(withComment: .empty),
                              style: .destructive))
        present(alert, animated: true)
    }
    
    private func setupInputs() {
        mapView.rx.idleAt.subscribe(onNext: { [weak self] cameraPosition in
            self?.viewModel
                    .inputs
                    .findBanksAction.onNext(.init(latitude: cameraPosition.target.latitude,
                                              longitude: cameraPosition.target.longitude))
        }).disposed(by: disposedBag)
    }
    
    private func locationDidUpdate(to location: CLLocation) {
        self.changeCamera(toLocation: location.coordinate)
        self.viewModel.inputs.findBanksAction.onNext(location)
        self.locationManager.stopUpdatingLocation()
    }
    
    private func setupOutputs() {
        viewModel.outputs.neablyBanks.drive(onNext: { [weak self] banks in
            guard let this = self else {return}
            this.removeAllMarkers()
            banks.forEach(this.addMarker(to:))
        }).disposed(by: disposedBag)
    }

}


extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        default:
            showNoAutoziredLocationAlert()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {return}
        locationDidUpdate(to: currentLocation)
    }

}
