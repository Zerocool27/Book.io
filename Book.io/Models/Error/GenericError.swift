//
//  GenericError.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation

class GenericError: Error {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
