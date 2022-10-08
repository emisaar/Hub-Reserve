//
//  ReservadoTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import UIKit

class ReservadoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var resourceLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func update(r: Reserva) {
        icon.image = UIImage(systemName: "checkmark.seal.fill")
        resourceLabel.text = String(r.id)
        startLabel.text = r.start
        endLabel.text = r.finish
        statusLabel.text = r.description
//        statusLabel.text = statusCheck(status: r.status)
    }
    
    func statusCheck(status: Int) -> String {
        if (status == 1){
            return "Disponible"
        } else {
            return "No Disponible"
        }
    }
    
    func iconCheck(resourceID: Int) -> String {
        var icon = ""
        
        if (resourceID == 1){
            icon = "signpost.right"
        }
        
        if (resourceID == 2){
            icon = "doc"
        }
        
        if (resourceID == 3){
            icon = "laptopcomputer.and.iphone"
        }
        return icon
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
