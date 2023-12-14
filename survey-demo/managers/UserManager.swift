//
//  UserManager.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private(set) var currentUser: User?
    
    private init() {
        let keychainManager = KeychainManager()
        currentUser = keychainManager.getUser()
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = "/api/v1/oauth/token"
        let parameters = [
            "grant_type": "password",
            "email": username,
            "password": password,
            "client_id": "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE",
            "client_secret": "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
        ]
        
        BaseNetwork.shared.performRequest(endpoint: endpoint, method: .post, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try self.decodeUser(data: data)
                    self.setCurrentUser(user)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                // Handle the failure case
                print("Network request error: \(error)")
            }
        }
    }
    
    func refreshAccessToken(refreshToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        let endpoint = "/api/v1/oauth/token"
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE",
            "client_secret": "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
        ]

        BaseNetwork.shared.performRequest(endpoint: endpoint, method: .post, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try self.decodeUser(data: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decodeUser(data: Data) throws -> User {
        let decoder = JSONDecoder()
        let userResponse = try decoder.decode(UserResponse.self, from: data)

        return User(
            id: userResponse.data.id,
            accessToken: userResponse.data.attributes.accessToken,
            tokenType: userResponse.data.attributes.tokenType,
            expiresIn: userResponse.data.attributes.expiresIn,
            refreshToken: userResponse.data.attributes.refreshToken,
            createdAt: userResponse.data.attributes.createdAt
        )
    }
    
    // MARK: User Management
    
    func setCurrentUser(_ user: User) {
        currentUser = user
        let keychainManager = KeychainManager()
        keychainManager.saveUser(user)
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func removeCurrentUser() {
        currentUser = nil
        let keychainManager = KeychainManager()
        keychainManager.deleteUser()
    }

    
}
