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
    var feedback: Driver<String> { get }
}

class FindBanksViewModel: FindBanksViewModelProtocol, FindBanksViewModelInput {
    
    var inputs: FindBanksViewModelInput { self }
    var outputs: FindBanksViewModelOutput { self }
    
    let findBanksAction = PublishSubject<CLLocation>()
    
    private let findBanksResult: Observable<Result<[Bank]>>
    private let service: BankServiceProtocol
    
    init(service: BankServiceProtocol = BankService()) {
        self.service = service
        findBanksResult = findBanksAction.flatMap { latestLocation in
            return service.findNeablyBanks(latestLocation)
        }.share()
    }
}

extension FindBanksViewModel: FindBanksViewModelOutput {
    var feedback: Driver<String> {
        findBanksResult.map { $0.failure?.localizedDescription }.unwrap().asDriver(onErrorJustReturn: "")
    }
}

