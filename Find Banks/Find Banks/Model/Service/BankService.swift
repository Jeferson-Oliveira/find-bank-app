//
//  BankService.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Alamofire
import CoreLocation
import RxSwift

protocol BankServiceProtocol {
    func findNeablyBanks(_ from: CLLocation) -> Observable<Result<BanksPage>>
}

class BankService: BaseService, BankServiceProtocol {
    func findNeablyBanks(_ from: CLLocation) -> Observable<Result<BanksPage>> {
        
        var parameters = Parameters()
        parameters["radius"] = APPConfig.radius
        parameters["types"] = "bank"
        parameters["name"] = APPConfig.bankName
        parameters["key"] =  APPConfig.gmsServicesKey
        parameters["location"] = "\(from.coordinate.latitude),\(from.coordinate.longitude)"
        
        return request(url: Endpoints.Bank.findNeablyBanks.rawValue,
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.queryString)
    }
}
