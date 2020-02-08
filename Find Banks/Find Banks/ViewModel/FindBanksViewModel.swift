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
    var findBanksAction: PublishSubject<CLLocation> { get }
}

protocol FindBanksViewModelOutput {
    var neablyBanks: Driver<[Bank]> { get }
    var feedback: Driver<String> { get }
}

class FindBanksViewModel: FindBanksViewModelProtocol, FindBanksViewModelInput {
    
    var inputs: FindBanksViewModelInput { self }
    var outputs: FindBanksViewModelOutput { self }
    
    let disposedBag = DisposeBag()
    let findBanksAction = PublishSubject<CLLocation>()
    
    private let findBanksResult: Observable<Result<BanksPage>>
    private var lastLocation = BehaviorRelay<CLLocation>(value: .init(latitude: .zero, longitude: .zero))
    private let service: BankServiceProtocol
    
    init(service: BankServiceProtocol = BankService()) {
        self.service = service
        findBanksResult = Observable.combineLatest(findBanksAction, lastLocation).filter { currentLocation, lastLocation in
            currentLocation.distance(from: lastLocation) > APPConfig.radius
        }.flatMapLatest { currentLocation, _ in
            return service.findNeablyBanks(currentLocation)
        }.share()
        
        findBanksResult.map { $0.value }.unwrap().withLatestFrom(findBanksAction).bind(to: lastLocation).disposed(by: disposedBag)
    }
}

extension FindBanksViewModel: FindBanksViewModelOutput {
    var neablyBanks: Driver<[Bank]> {
        return findBanksResult.map { $0.value }.unwrap().map { $0.results }.asDriver(onErrorJustReturn: [])
    }
    
    var feedback: Driver<String> {
        findBanksResult.map { $0.failure?.localizedDescription }.unwrap().asDriver(onErrorJustReturn: "")
    }
}

