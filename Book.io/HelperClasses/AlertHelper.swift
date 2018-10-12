//
//  AlertHelper.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation
import UIKit

typealias AlertCompletionBlock = () -> ()

class AlertHelper {
    static let shared = AlertHelper()
    
    func alertErrorWith(title: String?, message: String?, okAction: AlertCompletionBlock? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let completion = okAction {
                completion()
            }
        }))
        return alertController
    }
}

