//
//  Resources.swift
//  Hub-Reserve
//
//  Created by Alejandro Diaz Villagomez on 05/10/22.
//

import Foundation

struct Resource: Codable{
    var resource_type: String
    var category: String
    var name: String
    var description: String
    var location: String
    var active: Bool
}

typealias Resources = [Resource]
