//
//  StatsTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 27/09/22.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func update(s: Stats) {
//        icon.image = s.icon
//        descriptionLabel.text = s.description
//        valueLabel.text = s.value
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
