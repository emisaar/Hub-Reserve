//
//  HardwareTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import UIKit

class HardwareTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var resourceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func update(r: Resource) {
        icon.image = UIImage(systemName: "laptopcomputer.and.iphone")
        resourceLabel.text = r.name
        statusLabel.text = statusCheck(status: r.active)
    }
    
    func statusCheck(status: Bool) -> String {
        if (status == true){
            return "Disponible"
        } else {
            return "No Disponible"
        }
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
