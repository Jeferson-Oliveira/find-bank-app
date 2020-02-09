//
//  Encodable.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
