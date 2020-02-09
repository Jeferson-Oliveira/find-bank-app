//
//  BaseViewController.swift
//  Find Banks
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 08/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {    
    
    func showSimpleAlert(title: String = "Warning".localized(withComment: .empty), message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Ok".localized(withComment: .empty), style: .destructive))
        present(alert, animated: true)
    }

}
