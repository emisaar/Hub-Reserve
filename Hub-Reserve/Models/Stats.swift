//
//  Stats.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 27/09/22.
//

import Foundation
import UIKit

struct Stats {
    var icon: UIImage
    var description: String
    var value: String
}

extension Stats {
    static func statsList()->[Stats] {
        return [
            Stats(icon: UIImage(systemName: "clock")!, description: "Total de horas reservadas:", value: "180 hrs"),
            Stats(icon: UIImage(systemName: "repeat.circle")!, description: "Laboratorio más frecuentado:", value: "Sala 121"),
            Stats(icon: UIImage(systemName: "laptopcomputer.and.iphone")!, description: "Última computadora reservada:", value: "MO7564"),
            Stats(icon: UIImage(systemName: "shield.checkerboard")!, description: "Última licencia adquirida:", value: "Adobe"),
            Stats(icon: UIImage(systemName: "clock")!, description: "Total de reservaciones (general):", value: "124 reservaciones")
        ]
    }
}
