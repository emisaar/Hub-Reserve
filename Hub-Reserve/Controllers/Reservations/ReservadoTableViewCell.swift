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
        resourceLabel.text = r.resource_name
        startLabel.text = changeDateFormat(dateString: r.start)
        endLabel.text = changeDateFormat(dateString: r.finish)
        statusLabel.text = r.status
    }
    
    func changeDateFormat(dateString: String) -> String {
        let isoDate1 = dateString
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:isoDate1)!
    
        let dateSFormatter = DateFormatter()
        dateSFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateSFormatter.timeZone = TimeZone(abbreviation: "UTC-5")
        
        return dateSFormatter.string(from: date)
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
