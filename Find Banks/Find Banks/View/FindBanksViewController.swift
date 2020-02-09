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

class FindBanksViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    private var markers = [GMSMarker]()

    let disposedBag = DisposeBag()
    let viewModel: FindBanksViewModelProtocol = FindBanksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupInputs()
        setupOutputs()
        viewModel.inputs.didLoadAction.on(.next(()))
    }
    
    private func setupMapView() {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
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
        viewModel.outputs.nearbyBanks.drive(onNext: { [weak self] banks in
           guard let this = self else {return}
           this.removeAllMarkers()
           banks.forEach(this.addMarker(to:))
        }).disposed(by: disposedBag)
    
        viewModel.outputs.currentUserLocation.drive(onNext: { [weak self] userLocation in
            guard let this = self else {return}
            this.locationDidUpdate(to: userLocation)
        }).disposed(by: disposedBag)
        
        viewModel.outputs.userLocationPermissionStatus.drive(onNext: { [weak self] status in
            guard let this = self else {return}
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                this.mapView.isMyLocationEnabled = true
                this.mapView.settings.myLocationButton = true
            default:
                this.showSimpleAlert(message: "UserLocationAutorizeDeniedMessage".localized(withComment: .empty))
            }
        }).disposed(by: disposedBag)
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
    
    private func locationDidUpdate(to location: CLLocation) {
        self.changeCamera(toLocation: location.coordinate)
        self.viewModel.inputs.findBanksAction.onNext(location)
    }

}
