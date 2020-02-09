//
//  FindBanksViewModel.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import CoreLocation

protocol FindBanksViewModelProtocol {
    var inputs: FindBanksViewModelInput { get }
    var outputs: FindBanksViewModelOutput { get }
}

protocol FindBanksViewModelInput {
    var didLoadAction: PublishSubject<Void> { get }
    var findBanksAction: PublishSubject<CLLocation> { get }
}

protocol FindBanksViewModelOutput {
    var neablyBanks: Driver<[Bank]> { get }
    var userLocationPermissionStatus: Driver<CLAuthorizationStatus> { get }
    var currentUserLocation: Driver<CLLocation> { get }
    var feedback: Driver<String> { get }
}

class FindBanksViewModel: FindBanksViewModelProtocol, FindBanksViewModelInput {
    
    var inputs: FindBanksViewModelInput { self }
    var outputs: FindBanksViewModelOutput { self }
    
    let disposedBag = DisposeBag()
    let didLoadAction = PublishSubject<Void>()
    let findBanksAction = PublishSubject<CLLocation>()
    
    private let findBanksResult: Observable<Result<BanksPage>>
    private let getUserLocationResult: Observable<Result<CLLocation>>
    private let getUserLocationStatusResult: Observable<Result<CLAuthorizationStatus>>

    private var lastLocation = BehaviorRelay<CLLocation>(value: .init(latitude: .zero, longitude: .zero))
    private let bankService: BankServiceProtocol
    
    init(bankService: BankServiceProtocol = BankService(),
         userLocationService: UserLocationServiceProtocol = UserLocationService()) {
        
        self.bankService = bankService
        findBanksResult = Observable.combineLatest(findBanksAction, lastLocation).filter { currentLocation, lastLocation in
            currentLocation.distance(from: lastLocation) > APPConfig.radius
        }.flatMapLatest { currentLocation, _ in
            return bankService.findNeablyBanks(currentLocation)
        }.share()
        
        getUserLocationResult = didLoadAction.flatMapLatest {
            return userLocationService.requestUserLocation()
        }
        
        getUserLocationStatusResult = didLoadAction.flatMapLatest {
            return userLocationService.requestUserLocationStatus()
        }
        
        findBanksResult
            .map { $0.value }
            .unwrap()
            .withLatestFrom(findBanksAction)
            .bind(to: lastLocation)
            .disposed(by: disposedBag)
        
    }
}

extension FindBanksViewModel: FindBanksViewModelOutput {
    
    var userLocationPermissionStatus: Driver<CLAuthorizationStatus> {
        getUserLocationStatusResult.map { $0.value }.unwrap().asDriver(onErrorJustReturn: .notDetermined)
    }
    
    var currentUserLocation: Driver<CLLocation> {
        getUserLocationResult.map { $0.value }.unwrap().asDriver(onErrorJustReturn: .init(latitude: .zero, longitude: .zero))
    }
    
    var neablyBanks: Driver<[Bank]> {
        findBanksResult.map { $0.value }.unwrap().map { $0.results }.asDriver(onErrorJustReturn: [])
    }
    
    var feedback: Driver<String> {
        findBanksResult.map { $0.failure?.localizedDescription }.unwrap().asDriver(onErrorJustReturn: .empty)
    }
}

