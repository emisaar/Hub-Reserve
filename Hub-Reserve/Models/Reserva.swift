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
    
    // Modificar
    init(start: String, finish: String, comments: String, description: String, changed_by_user: Bool) {
        self.id = 0
        self.start = ""
        self.finish = ""
        self.description = ""
        self.comments = ""
        self.id_before_update = 0
        self.changed_by_admin = false
        self.changed_by_user = false
        self.resource_name = ""
        
    }
}

typealias Reservas = [Reserva]
