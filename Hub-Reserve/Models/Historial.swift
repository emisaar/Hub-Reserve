//
//  Historial.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 01/10/22.
//

import Foundation

struct Historial {
    var name: String
    var startDate: String
    var endDate: String
    var description: String
    var comments: String
    var resourceID: Int
    var status: Int
}

extension Historial {
    static func historialList()->[Historial] {
        return [
            Historial(name: "MacBook Pro", startDate: "2022/09/22", endDate: "2022/09/23", description: "Equipo de cómputo", comments: "Idk", resourceID: 3, status: 1),
            Historial(name: "Microsoft Office 365", startDate: "2022/09/22", endDate: "2022/09/23", description: "Licencia", comments: "Uso personal", resourceID: 2, status: 1),
            Historial(name: "Sala de Redes 1", startDate: "2022/09/22", endDate: "2022/09/23", description: "Salas", comments: "Laboratorio", resourceID: 1, status: 1)
        ]
    }
}
