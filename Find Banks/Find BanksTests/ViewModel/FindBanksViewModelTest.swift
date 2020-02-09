//
//  FindBanksViewModelTest.swift
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

class FindBanksViewModelTest: QuickSpec {
    
    override func spec() {
        
        describe("Find banks ViewModel") {
            
            let mockUserLocation = CLLocation(latitude: -12.9746, longitude: -38.4674)
            
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            var viewModel: FindBanksViewModel!
            
            beforeEach {
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: .zero)
            }
            
            context("when user request to agency with location") {
                    
                var banksObserver: TestableObserver<[Bank]>!
                
                beforeEach {
                    viewModel = FindBanksViewModel(bankService: FindBanksServiceMock(resultType: .success))
                    banksObserver = scheduler.createObserver([Bank].self)
                    scheduler.createHotObservable([.next(10, mockUserLocation)]).bind(to: viewModel.inputs.findBanksAction).disposed(by: disposeBag)
                    viewModel.outputs.neablyBanks.drive(banksObserver).disposed(by: disposeBag)
                    scheduler.start()
                }

                it("When data load") {
                    expect(banksObserver.events).toNot(beEmpty())
                }
                
            }
            
            context("when user request and an error occurs") {
                var feedbackObserver: TestableObserver<String>!
                beforeEach {
                    viewModel = FindBanksViewModel(bankService: FindBanksServiceMock(resultType: .failure))
                    feedbackObserver = scheduler.createObserver(String.self)
                    scheduler
                        .createHotObservable([.next(10, mockUserLocation)])
                        .bind(to: viewModel.inputs.findBanksAction)
                        .disposed(by: disposeBag)

                    viewModel.outputs.feedback.drive(feedbackObserver).disposed(by: disposeBag)
                    scheduler.start()
                }
                it("When data load") {
                    expect(feedbackObserver.events).toNot(equal([.next(10, .empty)]))
                }
                
            }
        }
    }
}
