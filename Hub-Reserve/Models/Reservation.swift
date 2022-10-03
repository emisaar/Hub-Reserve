//
//  Reservation.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import Foundation

struct Reservation {
    var name: String
    var startDate: String
    var endDate: String
//    var description: String
//    var comments: String
    var resourceID: Int
    var status: Int
}

extension Reservation {
    static func reservationList()->[Reservation] {
        return [
            Reservation(name: "MacBook Pro", startDate: "2022/09/22", endDate: "2022/09/23", resourceID: 3, status: 1),
            Reservation(name: "Microsoft Office 365", startDate: "2022/09/22", endDate: "2022/09/23", resourceID: 2, status: 1),
            Reservation(name: "Sala de Redes 1", startDate: "2022/09/22", endDate: "2022/09/23", resourceID: 1, status: 1)
        ]
    }
}
