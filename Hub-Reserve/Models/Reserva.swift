//
//  Reserva.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 06/10/22.
//

import Foundation

struct Reserva: Codable{
    var start: Date
    var finish: Date
//    var description: String
//    var comments: String
//    var created_at: Date
//    var id_before_update: Int
//    var changed_by_admin: Int
    var resource: Int
//    var satus_id: Int
//    var user: Int
//    var changed_by_user: Bool
}

typealias Reservas = [Reserva]
