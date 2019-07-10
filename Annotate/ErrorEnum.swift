//
//  ErrorEnum.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import Foundation

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
