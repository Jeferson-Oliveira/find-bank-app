//
//  BaseService.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class BaseService {
    
    private let sessionManager = Alamofire.SessionManager.default
    
    init() {
        
    }
    
    func request<T: Codable>(url: URLConvertible,
                             method: HTTPMethod,
                             parameters: Parameters = [:],
                             encoding: ParameterEncoding = JSONEncoding.default,
                             headers: HTTPHeaders = .init()) -> Observable<Result<T>> {
        
        return Observable.create { observer -> Disposable in
                self.sessionManager
                    .request(url, method: method, parameters: parameters, encoding: encoding, headers: nil)
                    .responseJSON(completionHandler: { response in
                        if let error = response.error {
                            observer.onNext(.error(error))
                        } else if let data = response.data {
                            do {
                                let model = try JSONDecoder.init().decode(T.self, from: data)
                                observer.on(.next(.success(model)))
                            } catch {
                                observer.on(.next(.error(error)))
                            }
                        }
                        observer.on(.completed)
                    })
                return Disposables.create()
            }
            
        }
        
}
