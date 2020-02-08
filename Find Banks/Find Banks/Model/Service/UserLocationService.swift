//
//  UserLocationService.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import RxCoreLocation
import CoreLocation
import RxSwift

protocol UserLocationServiceProtocol {
    func requestUserLocation() -> Observable<Result<CLLocation>>
    func requestUserLocationStatus() -> Observable<Result<CLAuthorizationStatus>>
}

class UserLocationService: BaseService, UserLocationServiceProtocol {
    
    let locationManager = CLLocationManager()
    
    func requestUserLocation() -> Observable<Result<CLLocation>> {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        return locationManager.rx.location.unwrap().map { Result.success($0)}
    }
    
    func requestUserLocationStatus() -> Observable<Result<CLAuthorizationStatus>> {
        return locationManager.rx.status.map { Result.success($0)}
    }
    
}
