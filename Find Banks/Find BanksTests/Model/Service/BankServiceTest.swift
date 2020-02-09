//
//  BankServiceTest.swift
//  Find BanksTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxTest
import RxSwift
import RxCocoa
import Mockingjay
import CoreLocation
import RxBlocking

@testable import Find_Banks

class BankServiceTest: QuickSpec {
    
    override func spec() {
        
        describe("Bank Service Test") {
            
            let mockUserLocation = CLLocation(latitude: -12.9746, longitude: -38.4674)
            let service = BankService()
            
            context("When user request to agency with location") {
                                
                it("The result can not be nil") {
                    self.stub(everything, json(BankMock.bankPageMock.dictionary as Any))
                    let result = service.findNeablyBanks(mockUserLocation)
                    do {
                        let page = try result.toBlocking().first()?.value
                        expect(page).notTo(beNil())
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
                
                it("when user request and an error occurs") {
                    self.stub(everything, failure(BankMock.mockError))
                    let result = service.findNeablyBanks(mockUserLocation)
                    do {
                        let page = try result.toBlocking().first()?.value
                        let error = try result.toBlocking().first()?.failure
                        expect(page).to(beNil())
                        expect(error).notTo(beNil())
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
                
                it("when return data can not be deserialized") {
                    self.stub(everything, json(["invalidKey":"invalidValue"]))
                    let result = service.findNeablyBanks(mockUserLocation)
                    do {
                        let page = try result.toBlocking().first()?.value
                        let error = try result.toBlocking().first()?.failure
                        expect(page).to(beNil())
                        expect(error).notTo(beNil())
                    } catch {
                        fail(error.localizedDescription)
                    }
                }
            }
        }
    }
}
