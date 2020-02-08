//
//  Bank.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

class BanksPage: Codable {
    let results: [Bank]
}

class Bank: Codable {
    var id: String
    var name: String
    var geometry: BankGemetry
}

class BankGemetry: Codable {
    var location: BankLocation
}

class BankLocation: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
       case latitude = "lat"
       case longitude = "lng"
    }
}


