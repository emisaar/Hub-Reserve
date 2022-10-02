//
//  Favorites.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 01/10/22.
//

import Foundation


struct Favorites {
    var name: String
    var resourceID: Int
}

extension Favorites {
    static func favoritesList()->[Favorites] {
        return [
            Favorites(name: "Macbook Pro M2", resourceID: 3),
            Favorites(name: "Sala 1", resourceID: 1),
            Favorites(name: "Adobe Photoshop", resourceID: 2),
            Favorites(name: "Asus Tuf Gaming 15", resourceID: 3)
        ]
    }
}
