//
//  Reserva.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 06/10/22.
//

import Foundation

// Realizar una reserva POST
struct Reserva: Codable{
    var id: Int
    var start: String
    var finish: String
    var description: String
    var comments: String
    var id_before_update: Int?
    var changed_by_admin: Bool
    var changed_by_user: Bool
    var resource_name: String
    var status: String
    
    // Modificar
    init(resource_id: Int, resource_name: String, start: String, finish: String, comments: String, description: String) {
        self.id = resource_id
        self.start = start
        self.finish = finish
        self.description = description
        self.comments = comments
        self.id_before_update = 0
        self.changed_by_admin = false
        self.changed_by_user = false
        self.resource_name = resource_name
        self.status = ""
        
    }
}

typealias Reservas = [Reserva]
