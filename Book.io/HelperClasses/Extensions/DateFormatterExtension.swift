//
//  DateFormatterExtension.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var customDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        return formatter
    }
    
    static var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    class func reformatDate(notificationDate : Date) -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d yyyy hh:mm a"
        let date = dateFormatterPrint.string(from: notificationDate)
        return date
    }
    
}
