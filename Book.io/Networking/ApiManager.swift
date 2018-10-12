//
//  ApiManager.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

typealias APICompletionBlock = (Error?) -> Void
typealias APICompletionDataBlock = (Error?, Data?) -> Void
typealias APICompletionModelBlock = (Error?, BaseModel?) -> Void
typealias APICompletionArrayBlock = (Error?, [BaseModel]?) -> Void

class ApiManager: NSObject {
    static let shared = ApiManager()
}

extension ApiManager {
    
    // MARK: - GET
    func getBookList(completion: @escaping APICompletionArrayBlock) {
        let fullUrlString = resolvedBackendOrigin() + GET_BOOK_LIST
        if let url = URL(string: fullUrlString) {
            RequestManager.shared.fetchDataWith(url: url, method: .get, params: nil, shouldAuth: true, completion: { (error, responseJSON, response) in
                if let error = error {
                    completion(error, nil)
                } else if let responseJSON = responseJSON as? [[String: Any]] {
                    let bookList = Mapper<BookModel>().mapArray(JSONArray: responseJSON)
                    completion(nil, bookList)
                } else {
                    completion(nil, nil)
                }
            })
        }
    }
    func getBook(book_id: Int,completion: @escaping APICompletionModelBlock) {
        let fullUrlString = resolvedBackendOrigin() + GET_BOOK + "/\(book_id)"
        if let url = URL(string: fullUrlString) {
            RequestManager.shared.fetchDataWith(url: url, method: .get, params: nil, shouldAuth: true, completion: { (error, responseJSON, response) in
                if let error = error {
                    completion(error, nil)
                } else if let responseJSON = responseJSON as? [String: Any] {
                    let book = Mapper<BookModel>().map(JSON: responseJSON)
                    completion(nil, book)
                } else {
                    completion(nil, nil)
                }
            })
        }
    }
}
