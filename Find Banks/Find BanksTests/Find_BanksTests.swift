//
//  Find_BanksTests.swift
//  Find BanksTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Find_Banks

class Find_BanksTests: XCTestCase {

    func testExample() {
        let observableToTest = Observable.of(10, 20, 30)
        do {
            let result = try observableToTest.toBlocking().first()!
            XCTAssertEqual(result, 10)
        } catch {
            XCTFail("Falha")
        }
    }

}
