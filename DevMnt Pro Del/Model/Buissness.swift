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
    var price: String?
    var displayPhone: String
    var isClosed: Bool?
    var location: Location?
    var imageURL: String?
    var url: String
    var reviewCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rating = "rating"
        case price = "price"
        case displayPhone = "display_phone"
        case isClosed = "is_closed"
        case location = "location"
        case imageURL = "image_url"
        case url = "url"
        case reviewCount = "review_count"
    }
}

struct Location: Decodable {
    var city: String
    var state: String
    var displayAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case city = "city"
        case state = "state"
        case displayAddress = "display_address"
    }
    
}


