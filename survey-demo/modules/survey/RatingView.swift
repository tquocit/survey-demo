//
//  RatingView.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 14/12/2023.
//

import UIKit

class RatingView: UIView {
    
    @IBOutlet var ratingButtons: [UIButton]!
    var answerType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupImagesForButton() {
        var imageName = ""

        switch answerType {
        case "star":
            imageName = "star"
        case "finger":
            imageName = "finger"
        case "heart":
            imageName = "heart"
        case "smiley":
            let emojiImages = ["emoji0", "emoji25", "emoji50", "emoji75", "emoji100"]
            for (index, button) in ratingButtons.enumerated() {
                button.setImage(UIImage(named: emojiImages[index]), for: .normal)
            }
            return
        default:
            break
        }
        

        for button in ratingButtons {
            button.setImage(UIImage(named: imageName), for: .normal)
        }

        for button in ratingButtons {
            button.alpha = button.isSelected ? 1.0 : 0.5
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }

    
    @objc private func buttonTapped(_ sender: UIButton) {
        updateSelectedState(selectedIndex: sender.tag)
    }
    
    private func updateSelectedState(selectedIndex: Int) {
        for button in ratingButtons {
            button.alpha = button.tag <= selectedIndex ? 1.0 : 0.5
        }
    }
    
}
