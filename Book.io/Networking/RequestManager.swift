//
//  RequestManager.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

enum ResponseResultType {
    case json
    case data
}

enum RequestContentType: String {
    case multipart = "multipart/form-data"
    case json = "application/json"
    case xml = "application/xml"
    case urlEncoded = "application/x-www-form-urlencoded"
}

typealias CoreRequestProgressCompletionBlock = (Progress) -> Void
typealias CoreRequestCompletionBlock = (Error?, Any?, HTTPURLResponse?) -> Void

class RequestManager: NSObject {
    static let shared = RequestManager()
    weak var lastUploadRequest: Request?
    
    override init() {
        super.init()
    }
}

// MARK: - Public methods
extension RequestManager {
    
    func fetchDataWith(url: URL, method: HTTPMethod, requestContentType: RequestContentType = .json, params: Dictionary<String, Any>?, shouldAuth: Bool, completion: @escaping CoreRequestCompletionBlock) {
        assert(Thread.isMainThread, "fetchURL called using a thread other than main!")
        
        var headers: HTTPHeaders = [:]
        headers["Content-Type"] = requestContentType.rawValue
        
        var encoding: ParameterEncoding = JSONEncoding.default
        if requestContentType == .urlEncoded {
            encoding = URLEncoding.default
        } else if requestContentType == .xml {
            encoding = PropertyListEncoding.default
        }
        Alamofire.request(url.absoluteString, method: method, parameters: params, encoding: encoding, headers: headers).responseJSON { (response) in
            print("Response:",response.description)
            self.parse(response: response.response, value: response.result.value, error: response.result.error, completion: completion)
        }
    }
    
    func uploadDataWith(url: URL, method: HTTPMethod, shouldAuth: Bool, resultType: ResponseResultType = .json, timeout: TimeInterval = REQUEST_TIMEOUT, multipartFormDataCompletion: @escaping (Alamofire.MultipartFormData) -> Swift.Void, progressCompletion: CoreRequestProgressCompletionBlock? = nil, completion: @escaping CoreRequestCompletionBlock) {
        assert(Thread.isMainThread, "fetchURL called using a thread other than main!")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(RequestContentType.multipart.rawValue, forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout
        
        
        Alamofire.upload(multipartFormData: multipartFormDataCompletion, with: request, encodingCompletion: { (result) in
            switch result {
            case .success(let uploadRequest, _, _):
                self.lastUploadRequest = uploadRequest
                if resultType == .json  {
                    uploadRequest.responseJSON(completionHandler: { (response) in
                        print("Response:",response.description)
                        self.parse(response: response.response, value: response.result.value, error: response.result.error, completion: completion)
                    })
                } else {
                    uploadRequest.responseData(completionHandler: { (response) in
                        print("Response:",response.description)
                        self.parse(response: response.response, value: response.result.value, error: response.result.error, completion: completion)
                    })
                }
                uploadRequest.uploadProgress(closure: { (progress) in
                    if let completion = progressCompletion {
                        completion(progress)
                    }
                })
            case .failure(let error):
                print("ERROR:",error.localizedDescription)
            }
        })
    }
    
    func downloadRequest(url: String,
                         progressCompletion: CoreRequestProgressCompletionBlock? = nil,
                         completion: @escaping CoreRequestCompletionBlock) {
        
        
        Alamofire.request(url).downloadProgress { progress in
            if let completion = progressCompletion {
                completion(progress)
            }
            }.responseData { response in
                self.parse(response: response.response, value: response.result.value, error: response.result.error, completion: completion)
        }
    }
    
}

// MARK: - Private methods
fileprivate extension RequestManager {
    func parse(response: HTTPURLResponse?, value: Any?, error: Error?, completion: CoreRequestCompletionBlock) {
        let responseStatusCode = response?.statusCode ?? 500
        if 200..<300 ~= responseStatusCode {
            parseSuccess(response: response, value: value, completion: completion)
        } else {
            parseFailure(response: response, statusCode: responseStatusCode, value: value, error: error, completion: completion)
        }
    }
    
    func parseSuccess(response: HTTPURLResponse?, value: Any?, completion: CoreRequestCompletionBlock) {
        if let JSONResponse = value as? [String: Any] {
            completion(nil, JSONResponse, response)
        } else if let JSONResponseArray = value as? [[String: Any]] {
            completion(nil, JSONResponseArray, response)
        } else if let dataResponse = value as? Data {
            completion(nil, dataResponse, response)
        }
    }
    
    func parseFailure(response: HTTPURLResponse?, statusCode: Int, value: Any?, error: Error?, completion: CoreRequestCompletionBlock) {
        if let error = error {
            let serverError = ServerError(code: statusCode, message: error.localizedDescription)
            completion(serverError, nil, response)
        } else if let JSONResponse = value as? [String: Any] {
            let errorMessage = JSONResponse["message"] as? String ?? "Unknown error. Code: \(statusCode)"
            let serverError = ServerError(code: statusCode, message: errorMessage)
            completion(serverError, nil, response)
        } else if let dataResponse = value as? Data {
            let json = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
            if let json = json as? [String: Any] {
                let errorMessage = json["message"] as? String ?? "Unknown error. Code: \(statusCode)"
                let serverError = ServerError(code: statusCode, message: errorMessage)
                completion(serverError, nil, response)
            } else {
                let errorMessage = "Unknown error. Code: \(statusCode)"
                let serverError = ServerError(code: statusCode, message: errorMessage)
                completion(serverError, nil, response)
            }
        }
    }
    
}


