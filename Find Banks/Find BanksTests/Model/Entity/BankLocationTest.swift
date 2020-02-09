//
//  BankTest.swift
//  Find BankLocationTest
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import XCTest
import CoreLocation.CLLocation
@testable import Find_Banks

class BankLocationTest: XCTestCase {
    
    func testConvertToCLLocation() {
        let location = BankLocation()
        location.latitude = 10
        location.longitude = 10
        
        let convertResult = location.toCLLocation()
        
        XCTAssertTrue(
            convertResult.coordinate.latitude == location.latitude
            && convertResult.coordinate.longitude == location.longitude,  "The coordinates must be equals")
    }
}
