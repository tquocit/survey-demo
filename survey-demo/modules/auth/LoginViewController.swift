//
//  LoginViewController.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 11/12/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var loginInputView: UIView!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    private var logoTopConstraint: NSLayoutConstraint!
    
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLogoIntoScreen()
        viewModel.delegate = self
        viewModel.checkTokenAndNavigate()
    }
    
    // MARK: Actions
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        UserManager.shared.loginUser(username: emailTextField.text!,
                                     password: passwordTextField.text!) { result in
            switch result {
            case .success(let user):
                // Save tokens after a successful login
                DispatchQueue.main.async {
                    self.showHomeScreen()
                }
                // Store or use the user information as needed
            case .failure(let error):
                print("Login failed. Error: \(error)")
            }
        }
    }
    
    // MARK: Helpers
    
    private func addLogoIntoScreen() {
        let logoImageView = UIImageView(image: UIImage(named: "logo_white"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        
        logoTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.center.y)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoTopConstraint,
        ])
    }

}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    
    func showHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UIApplication.shared.windows.first?.rootViewController = homeViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func addAnimationLogin() {
        let blurEffectView = self.background.applyBlurEffect(style: .dark)
        blurEffectView.alpha = 0
        self.background.addSubview(blurEffectView)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0) {
                self.logoTopConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 1.0, delay: 0.5) {
                blurEffectView.alpha = 1.0
                self.loginInputView.alpha = 1.0
            }

        }
    }
}
