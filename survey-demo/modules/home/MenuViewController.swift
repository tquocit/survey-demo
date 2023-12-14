//
//  MenuViewController.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 14/12/2023.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func logoutSuccessfully()
}

class MenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var profileName: UILabel!
    
    weak var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        // Add tap gesture recognizer to the parent view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        
        if menuView != nil && !menuView.frame.contains(location) {
            dismissMenuView()
        }
    }
    
    private func dismissMenuView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }) { _ in
            // Remove the menu from the parent view controller
            self.removeFromParent()
            self.view.removeFromSuperview()
            self.didMove(toParent: nil)
        }
    }

    @IBAction func onLogoutButton(_ sender: UIButton) {
        UserManager.shared.logout { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.dismissMenuView()
                    self.delegate?.logoutSuccessfully()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.dismissMenuView()
                }
            }
        }
    }
    
}
