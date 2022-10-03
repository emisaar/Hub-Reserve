//
//  Software.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import Foundation

struct Software {
    var name: String
//    var resourceID: Int
    var status: Int
}

extension Software {
    static func softwareList()->[Software] {
        return [
            Software(name: "Adobe Photshop", status: 1),
            Software(name: "Norton Antivirus", status: 1),
            Software(name: "Cisco Packet Tracer v2", status: 1),
            Software(name: "WebAssign", status: 1),
            Software(name: "Adobe Illustrator", status: 1),
            Software(name: "Microsoft Office 365", status: 1)
        ]
    }
}
