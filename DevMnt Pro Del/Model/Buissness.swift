//
//  Business.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/5/22.
//

import Foundation

struct YelpData: Decodable {
    var businesses: [Business]
    
}

struct Business: Decodable {
    var name: String
    var rating: Double
    var price: String
    var phone: String
    var is_closed: Bool?
    var location: Location?
//https://www.donnywals.com/using-swifts-async-await-to-build-an-image-loader/
    var image_url: String?
}

struct Location: Decodable {
//    var address1: String
//    var address2: String
//    var city: String
//    var state: String
//    var zipCode: String
    var displayAddress: [String]
    
    enum CodingKeys: String, CodingKey {
//        case address1 = "address1"
//        case address2 = "address2"
//        case city = "city"
//        case state = "state"
//        case zipCode = "zip_code"
        case displayAddress = "display_address"
    }
    
}

