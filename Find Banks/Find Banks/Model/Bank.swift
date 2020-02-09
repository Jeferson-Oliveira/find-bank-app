//
//  Bank.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import GoogleMaps

class BanksPage: Codable {
    var results: [Bank] = []
}

class Bank: Codable {
    var id: String = .empty
    var name: String = .empty
    var vicinity: String = .empty
    var geometry: BankGeometry = BankGeometry()
}

class BankGeometry: Codable {
    var location: BankLocation = BankLocation()
}

class BankLocation: Codable {
    var latitude: Double = .zero
    var longitude: Double = .zero
    
    enum CodingKeys: String, CodingKey {
       case latitude = "lat"
       case longitude = "lng"
    }
    
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


