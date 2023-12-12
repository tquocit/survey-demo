//
//  UserManager.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private init() {
        
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
                    let decoder = JSONDecoder()
                    
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON String: \(jsonString)")
                    } else {
                        print("Failed to convert JSON data to string.")
                    }
                    
                    let userResponse = try decoder.decode(UserResponse.self, from: data)
                    let user = User(
                        id: userResponse.data.id,
                        accessToken: userResponse.data.attributes.accessToken,
                        tokenType: userResponse.data.attributes.tokenType,
                        expiresIn: userResponse.data.attributes.expiresIn,
                        refreshToken: userResponse.data.attributes.refreshToken,
                        createdAt: userResponse.data.attributes.createdAt
                    )
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
}
