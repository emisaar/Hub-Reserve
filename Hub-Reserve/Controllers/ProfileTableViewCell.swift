//
//  ProfileTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    func update(po: ProfileOptions) {
        iconLabel.image = po.icon
        contentLabel.text = po.content
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
