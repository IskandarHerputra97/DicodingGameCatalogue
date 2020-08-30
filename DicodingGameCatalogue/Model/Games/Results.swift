//
//  Results.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 17/08/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import Foundation

struct Results: Codable {
    let name: String?
    let released: String?
    let backgroundImage: String?
    let ratingTop: Int?
    let rating: Double?
    let metacritic: Int?
    let playtime: Int?
    let suggestionsCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case released
        case backgroundImage = "background_image"
        case ratingTop = "rating_top"
        case rating
        case metacritic
        case playtime
        case suggestionsCount = "suggestions_count"
    }
}
