//
//  Catergory.swift
//  DevMnt Pro Del
//
//  Created by Ivan Ramirez on 9/15/22.
//

import Foundation

struct Category {
    var title: String
    var imageTitle: String
}

struct CategoryOptions {
    static var categories: [Category] = [
        Category(title: "Tacos", imageTitle: "taco"),
        Category(title: "Burgers", imageTitle: "burger"),
        Category(title: "Sushi", imageTitle: "sushi"),
        Category(title: "pizza", imageTitle: "pizza"),
        Category(title: "Pho", imageTitle: "pho"),
        Category(title: "Chicken", imageTitle: "fried-chicken"),
        Category(title: "Cafe", imageTitle: "coffee"),
        Category(title: "Boba Tea", imageTitle: "bubble-tea")
    ]
}
