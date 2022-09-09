//
//  Constants.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/5/22.
//

import Foundation

struct Constants {
    static let clientID = "WDfPljaLr572MsO7GCHDAw"
    
    static let apiKey = "ySuNrwI9UgAMW0FLOhfzBVNoxtLtzV2RzdxPRQGQ37EJZKHumDnZH79vsJ-a1RA_4mrID3tie67FQxB28idVFdq07rDZy9Wr_J0NBLTMYG-ALLFK4-_UU5g1wBI9YnYx"
    
    static let headers = ["Authorization": "Bearer " + apiKey]
}

struct NetworkURLConstants {
    static let businessSearch = "https://api.yelp.com/v3/businesses/search"
    static let businessDetails = "https://api.yelp.com/v3/businesses/"
}
