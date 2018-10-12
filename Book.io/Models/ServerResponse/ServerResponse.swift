//
//  ServerResponse.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit
import ObjectMapper

public enum ResponseStatus {
    case success
    case failure
}

class ServerResponse: BaseModel {
    
    var code: Int!
    var status: ResponseStatus!
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        code           <- map["code"]
        status         <- (map["status"], ResponseStatusTransfrom())
    }
}
