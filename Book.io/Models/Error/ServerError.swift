//
//  ServerError.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation

class ServerError: GenericError {
    var code: Int
    
    init(code: Int, message: String) {
        self.code = code
        super.init(message: message)
    }
}
