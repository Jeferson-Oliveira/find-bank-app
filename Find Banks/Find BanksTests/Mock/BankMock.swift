//
//  Bank.swift
//  Find BanksTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
@testable import Find_Banks

class BankMock {
    
    static var bankMock: Bank {
        let mockBank = Bank()
        mockBank.name = "Mock"
        mockBank.id = "1234"
        mockBank.vicinity = "Mock"
        mockBank.geometry.location.latitude = 400
        mockBank.geometry.location.longitude = 300
        return mockBank
    }
    
    static var bankPageMock: BanksPage {
        let pageMock = BanksPage()
        pageMock.results = [bankMock]
        return pageMock
    }
    
    static var mockError = NSError(domain: "Test", code: .zero, userInfo: nil)
    
}
