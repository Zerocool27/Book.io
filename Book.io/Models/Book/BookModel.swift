//
//  BookModel.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//


import Foundation
import ObjectMapper

class BookModel: BaseModel {
    
    var author = ""
    var categories = ""
    var id  = 0
    var lastCheckedOut = ""
    var lastCheckedOutBy = ""
    var publisher = ""
    var title = ""
    var updatedAt = ""
    var createdAt = "" 
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        author <- map["author"]
        categories <- map["categories"]
        id <- map["id"]
        lastCheckedOut <- map["lastCheckedOut"]
        lastCheckedOutBy <- map["lastCheckedOutBy"]
        publisher <- map["publisher"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
        print("lastCheckedOut",lastCheckedOut)
        print("lastCheckedOutBy",lastCheckedOutBy)
        let customDateFormatter = DateFormatter.customDateFormatter
        if let checkoutDate = customDateFormatter.date(from: lastCheckedOut){
            let checkoutFormatter = DateFormatter()
            checkoutFormatter.dateFormat = "MMMM d, yyyy hh:mmA"
            print(checkoutFormatter.string(from: checkoutDate))

        }
        
    }
}

// MARK: - Open methods
extension BookModel {
    
    func getFormattedCheckoutString() -> String {
        let customDateFormatter = DateFormatter.customDateFormatter
        
        if let checkoutDate = customDateFormatter.date(from: lastCheckedOut){
            let checkoutFormatter = DateFormatter()
            checkoutFormatter.dateFormat = "MMMM d, yyyy hh:mmA"
            return lastCheckedOutBy + "@ \(checkoutFormatter.string(from: checkoutDate))"
        }
        return ""
    }
}
