//
//  Constants.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import Foundation

struct Constants {
    static let Cell = "Cell"
    static let placeholderKey = "placeholder"
    static let perPage = "15"
    static let responseFormat = "json"
    
    //Enter your APIKey below
    static let apiKey = "e79e37db8c17fb8f7b009ea28a20cb4c"
    
    //create a default set reference
    static let defaultSetName = "Default Set"
    static let perPageKey = "perPage"
    
    //the settings icon unicode character
    static let wheelWithoutHubKey = "\u{2699}"
}

enum DataError: Error {
    case dataFailure
    
    var localizedDescription: String {
        switch self {
        case .dataFailure:
            return NSLocalizedString("Could not access from database", comment: "Database Error")
        }
    }
}

enum ConnectionError: Error {
    case connectionFailure
    
    var localizedDescription: String {
        switch self {
        case .connectionFailure:
            return NSLocalizedString("Connection Failure", comment: "Connection Error")
        }
    }
}
