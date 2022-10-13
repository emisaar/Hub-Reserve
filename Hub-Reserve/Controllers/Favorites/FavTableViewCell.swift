//
//  FavTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var resourceLabel: UILabel!
    
    func update(r: Favorite) {
        icon.image = UIImage(systemName: "star")
        resourceLabel.text = r.resource_name
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
