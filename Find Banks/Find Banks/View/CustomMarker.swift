//
//  CustomMarker.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import GoogleMaps

class CustomMarker: GMSMarker {
    var bank: Bank
    init(bank: Bank) {
        self.bank = bank
        super.init()
    }
}
