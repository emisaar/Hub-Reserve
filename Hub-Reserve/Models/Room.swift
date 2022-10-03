//
//  Room.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import Foundation

struct Room {
    var name: String
//    var resourceID: Int
    var status: Int
}

extension Room {
    static func roomList()->[Room] {
        return [
            Room(name: "Sala 1", status: 1),
            Room(name: "Sala 2", status: 1),
            Room(name: "Sala 3", status: 1),
            Room(name: "Sala 4", status: 1),
            Room(name: "Sala 5", status: 1),
            Room(name: "Sala 6", status: 1)
        ]
    }
}
