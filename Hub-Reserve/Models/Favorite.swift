//
//  Favorite.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 13/10/22.
//

import Foundation

struct Favorite: Codable{
    var id: Int
    var resource_name: String
    var resource: Int
}

typealias Favorites = [Favorite]
