//
//  Historial.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 06/10/22.
//

import Foundation

// Realizar una reserva POST
struct Historial: Codable{
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
}

typealias Historiales = [Historial]
