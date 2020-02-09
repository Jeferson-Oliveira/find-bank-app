//
//  Endpoints.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

enum Endpoints {
    enum Bank: String {
        case findNearbyBanks = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    }
}
