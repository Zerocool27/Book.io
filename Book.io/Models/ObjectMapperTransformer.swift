//
//  ObjectMapperTransformer.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseStatusTransfrom: TransformType {
    typealias Object = ResponseStatus
    typealias JSON = Int
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> Object? {
        let code = value as! Int
        if 200..<300 ~= code {
            return .success
        } else {
            return .failure
        }
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return 0
    }
}

class ISO8601DateTransform: TransformType {
    typealias Object = Date
    typealias JSON = String
    
    private var dateFormatter: DateFormatter {
        let iotaDateFormatter = DateFormatter()
        iotaDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        iotaDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return iotaDateFormatter
    }
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let stringDate = value as? String {
            return dateFormatter.date(from: stringDate)
        } else {
            return nil
        }
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

