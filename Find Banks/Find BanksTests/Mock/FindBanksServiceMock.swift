//
//  FindBanksServiceMock.swift
//  Find BanksTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation.CLLocation
@testable import Find_Banks

class FindBanksServiceMock: BankServiceProtocol {
    
    var resultType: ResultType
    
    init(resultType: ResultType) {
        self.resultType = resultType
    }
    
    func findNearbyBanks(_ from: CLLocation) -> Observable<Result<BanksPage>> {
        switch resultType {
        case .success:
            return Observable.just(Result.success(BankMock.bankPageMock))
        case .failure:
            return Observable.just(Result.error(BankMock.mockError))
        }
    }
    
}
