//
//  ProfileOptions.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import Foundation
import UIKit

struct ProfileOptions {
    var icon: UIImage
    var content: String
}

extension ProfileOptions {
    static func profileOptionList()->[ProfileOptions] {
        return [
            ProfileOptions(icon: UIImage(systemName: "pencil")!, content: "Editar cuenta"),
            ProfileOptions(icon: UIImage(named: "statsIcon")!, content: "Mis Estadísticas"),
            ProfileOptions(icon: UIImage(systemName: "doc")!, content: "Mi Historial"),
            ProfileOptions(icon: UIImage(systemName: "clock")!, content: "Acerca de")
        ]
    }
}
