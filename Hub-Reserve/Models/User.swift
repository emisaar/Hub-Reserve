//
//  User.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 16/10/22.
//

import Foundation

// Recursos disponibles
struct User: Codable{
    var id: Int
    var name: String
    var lastname: String
}

typealias Users = [User]
