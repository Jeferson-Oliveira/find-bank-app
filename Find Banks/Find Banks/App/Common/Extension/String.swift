//
//  String.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

extension String {
    static let empty = ""
    func localized(withComment coment: String) -> String {
        return NSLocalizedString(self, comment: coment)
    }
}
