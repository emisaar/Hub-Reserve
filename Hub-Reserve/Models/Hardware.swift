//
//  Hardware.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import Foundation

struct Hardware {
    var name: String
//    var resourceID: Int
    var status: Int
}

extension Hardware {
    static func hardwareList()->[Hardware] {
        return [
            Hardware(name: "Macbook Pro M2", status: 1),
            Hardware(name: "Asus TUF Gaming 15", status: 1),
            Hardware(name: "Lenovo", status: 1),
            Hardware(name: "Huawei Notebook 15", status: 1),
            Hardware(name: "iPad Pro 11", status: 1),
            Hardware(name: "Cisco Router", status: 1)
        ]
    }
}
