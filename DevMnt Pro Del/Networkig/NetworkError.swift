//
//  NetworkError.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/5/22.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case saveError
    case readError
    case decodingError
    case encodingError
    //
    case badBaseURL
    case badBuiltURL
    case invalidData(String)
    
    var errorDescription: String? {
        switch self {
        case .saveError:
            return NSLocalizedString("Could not save ToDos, please reinstall the app.", comment: "")
        case .readError:
            return NSLocalizedString("Could not save ToDos, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("There was a problem loading your ToDos, please create a new ToDo to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save ToDos, please reinstall the app.", comment: "")
            
            ///
        case .badBaseURL:
            return NSLocalizedString("Could not reach proper site.", comment: "")
            
        case .badBuiltURL:
            return NSLocalizedString("Bad built URL.", comment: "")
            
        case .invalidData:
            return NSLocalizedString("Bad data.", comment: "")
        }
    }
}

struct ErrorType: Identifiable { // for convient he put it here
    let id = UUID()
    let error: NetworkError
}
