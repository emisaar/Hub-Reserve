//
//  SoftwareTableViewCell.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 25/09/22.
//

import UIKit

class SoftwareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var resourceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var starIcon: UIButton!
    
    var id = 0
    
    func update(r: Resource) {
        icon.image = UIImage(systemName: "doc")
        resourceLabel.text = r.name
        statusLabel.text = r.description
        id = r.id
    }
    
    func changeIcon() {
        starIcon.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    @IBAction func addFavS(_ sender: Any) {
        Task{
            let defaults = UserDefaults.standard
            guard let token = defaults.string(forKey: "jwt") else {
                return
            }

            print("TOKEN")
            print(token)
            print("RESOURCE ID \(id)")
            do {
                let recursos = try await WebService().addFavorites(token: token, resource: id)
                changeIcon()
            } catch {
                displayError(NetworkError.noData, title: "No se pudo añadir a favoritos")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
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
