//
//  FavoriteGame.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 25/08/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteGame: Object {
    @objc dynamic var name: String?
    @objc dynamic var released: String?
    @objc dynamic var background_image: String?
    @objc dynamic var rating_top: String?
    @objc dynamic var rating: String?
    @objc dynamic var metacritic: String?
    @objc dynamic var playtime: String?
    @objc dynamic var suggestions_count: String?
}
