//
//  BaseModel.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//


import UIKit
import ObjectMapper

class BaseModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        // no implementation. This function should be overriden by children
    }
}

