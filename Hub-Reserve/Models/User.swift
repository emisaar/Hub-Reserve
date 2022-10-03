//
//  Reserva.swift
//  retoVersionBeta
//
//  Created by molina on 22/09/22.
//

import Foundation
struct User: Codable{
    var email: String
    var jwt: String
    var password: String
}
typealias Users = [User]
/*
extension Reserva{
    static func lista_Reservas()->[Reserva]{
        return [
            Reserva(nombre: "Laptop HP", fecha_inicio: "2022/09/22:12:00", descripcion: "Reservacion por 5 horas", icono: "💻", tipo: "Hardware"),
            Reserva(nombre: "Laboratorio de seguridad", fecha_inicio: "2022/10/22:12:00", descripcion: "Equipo especializado", icono: "🏫", tipo: "Salas")
        
        ]
    }
}
*/
