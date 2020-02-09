//
//  Result.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 07/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

enum Result<T> {
    
    case success(T)
    case error(Error)
    
    var value: T? {
        get {
            guard case let .success(value) = self else { return nil }
            return value
        }
    }
    
    var failure: Error? {
        guard case let .error(error) = self else { return nil }
        return error
    }
}
