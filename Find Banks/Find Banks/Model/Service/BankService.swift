//
//  BankService.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol BankServiceProtocol {
    func findNeablyBanks(_ from: CLLocation) -> Observable<Result<[Bank]>>
}

class BankService: BaseService, BankServiceProtocol {
    func findNeablyBanks(_ from: CLLocation) -> Observable<Result<[Bank]>> {
        return request(url: "", method: .get)
    }
}
