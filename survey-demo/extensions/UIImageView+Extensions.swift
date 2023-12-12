//
//  UIImageView+Extensions.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 11/12/2023.
//

import UIKit

extension UIImageView {

    func applyBlurEffect(style: UIBlurEffect.Style = .light) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        
        return blurEffectView
    }
}
