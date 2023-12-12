//
//  CustomTextField.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 11/12/2023.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    // MARK: - Properties
    @IBInspectable var cornerRadius: CGFloat = 12 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var backgroundOpacity: CGFloat = 0.18 {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(backgroundOpacity)
        }
    }
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTextField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    // MARK: - Configuration
    
    private func configureTextField() {
        textColor = .white
        tintColor = .white
        font = UIFont.systemFont(ofSize: 16)
        borderStyle = .none
        autocorrectionType = .no
        autocapitalizationType = .none
                
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    
        layer.cornerRadius = cornerRadius
        backgroundColor = backgroundColor?.withAlphaComponent(backgroundOpacity)
        
        attributedPlaceholder = NSAttributedString(
                    string: placeholder ?? "",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)
                    ]
                )

    }
    
}
