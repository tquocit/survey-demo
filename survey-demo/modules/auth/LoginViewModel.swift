//
//  LoginViewModel.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 14/12/2023.
//

import Foundation
protocol LoginViewModelDelegate: AnyObject {
    func showHomeScreen()
    func addAnimationLogin()
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    func checkTokenAndNavigate() {
        if hasValidToken() {
            delegate?.showHomeScreen()
        } else {
            refreshTokenIfNeeded()
        }
    }
    
    private func hasValidToken() -> Bool {
        guard let storedUser = UserManager.shared.currentUser else {
            return false
        }
        let expirationDate = Date(timeIntervalSince1970: storedUser.createdAt + storedUser.expiresIn)
        let currentDate = Date()
        return currentDate < expirationDate
    }
    
    private func refreshTokenIfNeeded() {
        guard let refreshToken = UserManager.shared.currentUser?.refreshToken else {
            // No refresh token available, initiate login animation
            delegate?.addAnimationLogin()
            return
        }
        
        UserManager.shared.refreshAccessToken(refreshToken: refreshToken) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    UserManager.shared.setCurrentUser(user)
                    self.delegate?.showHomeScreen()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.delegate?.addAnimationLogin()
                }
                
            }
        }
    }
}
