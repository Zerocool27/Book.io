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
            RequestManager.shared.fetchDataWith(url: url, method: .get, params: nil, shouldAuth: false, completion: { (error, responseJSON, response) in
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
    func getBook(bookId: Int,completion: @escaping APICompletionModelBlock) {
        let fullUrlString = resolvedBackendOrigin() + GET_BOOK + "/\(bookId)"
        if let url = URL(string: fullUrlString) {
            RequestManager.shared.fetchDataWith(url: url, method: .get, params: nil, shouldAuth: false, completion: { (error, responseJSON, response) in
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
    
    // MARK: - PUT
    func updateBook(bookId: Int, lastCheckedOutBy: String, completion: @escaping APICompletionModelBlock) {
        let fullUrlString = resolvedBackendOrigin() + PUT_BOOK + "/\(bookId)"
        if let url = URL(string: fullUrlString) {
            let params: [String: Any] = [
                "lastCheckedOutBy": lastCheckedOutBy
            ]
            RequestManager.shared.fetchDataWith(url: url, method: .put, params: params, shouldAuth: false, completion: { (error, responseJSON, response) in
                if let error = error {
                    completion(error, nil)
                } else if let responseJSON = responseJSON as? [String: Any] {
                    let updatedBook = Mapper<BookModel>().map(JSON: responseJSON)
                    completion(nil, updatedBook)
                } else {
                    completion(nil, nil)
                }
            })
        }
    }
    
    // MARK: - POST
    func addBook(author: String, categories: String, publisher: String, title: String, completion: @escaping APICompletionModelBlock) {
        let fullUrlString = resolvedBackendOrigin() + POST_BOOK
        if let url = URL(string: fullUrlString) {
            let params: [String: Any] = [
                "author": author,
                "categories": categories,
                "publisher": publisher,
                "title": title
            ]
            RequestManager.shared.fetchDataWith(url: url, method: .post, params: params, shouldAuth: false, completion: { (error, responseJSON, response) in
                if let error = error {
                    completion(error, nil)
                } else if let responseJSON = responseJSON as? [String: Any] {
                    let newBook = Mapper<BookModel>().map(JSON: responseJSON)
                    completion(nil, newBook)
                } else {
                    completion(nil, nil)
                }
            })
        }
    }
    
    // MARK: - DELETE
    func deleteBook(bookId:Int, completion: @escaping APICompletionBlock) {
        let fullUrlString = resolvedBackendOrigin() + DELETE_BOOK + "/\(bookId)"
        if let url = URL(string: fullUrlString) {
            RequestManager.shared.fetchDataWith(url: url, method: .delete, params: nil, shouldAuth: false, completion: { (error, responseJSON, response) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    func cleanBookLibrary(completion: @escaping APICompletionBlock) {
        let fullUrlString = resolvedBackendOrigin() + DELETE_ALL_BOOK_LIST
        if let url = URL(string: fullUrlString) {
            RequestManager.shared.fetchDataWith(url: url, method: .delete, params: nil, shouldAuth: false, completion: { (error, responseJSON, response) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            })
        }
    }
}
