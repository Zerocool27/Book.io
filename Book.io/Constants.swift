//
//  Constants.swift
//  Book.io
//
//  Created by fatih on 10/11/18.
//  Copyright © 2018 fatih. All rights reserved.
//

import Foundation

// MARK: - Backend endpoint
let BASE_URL_1 = "https://ivy-ios-challenge.herokuapp.com/" //DEV ENVIRONMENT


/// @returns Backend origin with a following forward slash, e.g. http://host.com/
func resolvedBackendOrigin() -> String! {
    // Use default value if nothing is at the UserDefaults
    
    guard let userSettingsBackend: String = UserDefaults.standard.string(forKey: "main_backend"),
        false == userSettingsBackend.isEmpty else {
            return BASE_URL_1;
    }
    // Use the value from UserDefaults, if any. No validaton for a valid origin, make sure there's a slash at the end
    if (!userSettingsBackend.hasSuffix("/")) {
        return userSettingsBackend + "/"
    }
    return userSettingsBackend
}

// MARK: - Timeout
let REQUEST_TIMEOUT: TimeInterval = 60

// MARK: - Network
// MARK: GET ENDPOINTS
let GET_BOOK_LIST = "books"
let GET_BOOK = "books" //ADD /BOOK_ID

// MARK: POST ENDPOINTS
let POST_BOOK = "books"

// MARK: PUT ENDPOINTS
let PUT_BOOK = "books" //ADD /BOOK_ID

// MARK: DELETE ENDPOINTS
let DELETE_BOOK = "books" //ADD /BOOK_ID
let DELETE_ALL_BOOK_LIST = "clean" //ADD /BOOK_ID
