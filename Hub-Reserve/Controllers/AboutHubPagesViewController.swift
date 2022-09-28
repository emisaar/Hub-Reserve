//
//  AboutHubPagesViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 28/09/22.
//

import UIKit

class AboutHubPagesViewController: UIViewController {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    var backgroundImage: UIImage?
    var iconImage: UIImage?
    var text: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundImageView.image = backgroundImage
        iconImageView.image = iconImage
        
        if let text = text {
            let font = UIFont(name: "HelveticaNeue-Light", size: 20.0)!
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.alignment = .center
            
            textLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
