//
//  RoomTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var resourceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    func update(r: Room) {
        icon.image = UIImage(systemName: "signpost.right")
        resourceLabel.text = r.name
        statusLabel.text = statusCheck(status: r.status)
    }
    
    func statusCheck(status: Int) -> String {
        if (status == 1){
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
