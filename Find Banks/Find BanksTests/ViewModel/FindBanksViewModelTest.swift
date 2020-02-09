//
//  FindBanksViewModelTest.swift
//  Find BanksTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Quick
import Nimble
import RxTest
import RxSwift
import Mockingjay
import CoreLocation

@testable import Find_Banks

class FindBanksViewModelTest: QuickSpec {
    
    override func spec() {
        
        let mockUserLocation = CLLocation(latitude: -12.9746, longitude: -38.4674)
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var viewModel: FindBanksViewModelProtocol!
        
        describe("Find Banks ViewModel") {
            
            context("Load Banks With User Location") {
                beforeEach {
                    scheduler = TestScheduler(initialClock: .zero)
                    disposeBag = DisposeBag()
                }
                
                it("When request is made with succesfull the banks list shoud be returned") {
                    
                    viewModel = FindBanksViewModel(bankService: FindBanksServiceMock(resultType: .success))
                    let page = scheduler.createObserver([Bank].self)
                    self.stub(http(.get, uri: Endpoints.Bank.findNeablyBanks.rawValue), json(BankMock.bankPageMock.dictionary as Any))
                    
                    viewModel.outputs.neablyBanks.drive(page).disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([.next(10, mockUserLocation)])
                        .bind(to: viewModel.inputs.findBanksAction).disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(page.events).to(containElementSatisfying({ element -> Bool in
                        print(element.debugDescription)
                        return (element.value.element?.contains(where: { $0.id == BankMock.bankMock.id }) ?? false) && element.time == 10
                    }))
                }
                
                it("When request returns an error message shoud be send to feedback") {
                    
                    viewModel = FindBanksViewModel(bankService: FindBanksServiceMock(resultType: .failure))
                    let feedback = scheduler.createObserver(String.self)
                    self.stub(http(.get, uri: Endpoints.Bank.findNeablyBanks.rawValue), failure(BankMock.mockError))
                    
                    viewModel.outputs.feedback.drive(feedback).disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([.next(10, mockUserLocation)])
                        .bind(to: viewModel.inputs.findBanksAction).disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(feedback.events).toNot(equal([.next(10, .empty)]))
                }
                
                it("When request can not make an deserialization of the response an error message shoud be send to feedback") {
                    
                    viewModel = FindBanksViewModel(bankService: FindBanksServiceMock(resultType: .failure))
                    let feedback = scheduler.createObserver(String.self)
                    self.stub(http(.get, uri: Endpoints.Bank.findNeablyBanks.rawValue), json(["invalidKey  ":"invalidValue"]))
                    
                    viewModel.outputs.feedback.drive(feedback).disposed(by: disposeBag)
                    
                    scheduler.createColdObservable([.next(10, mockUserLocation)])
                        .bind(to: viewModel.inputs.findBanksAction).disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    expect(feedback.events).toNot(equal([.next(10, .empty)]))
                }
            }
        }
    }
}
