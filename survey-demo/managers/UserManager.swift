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
        let baseUrl = "https://survey-api.nimblehq.co"
        let apiUrl = baseUrl + "/api/v1/oauth/token"
        
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Customize the request body with your authentication parameters
        let parameters = [
            "grant_type": "password",
            "email": username,
            "password": password,
            "client_id": "ofzl-2h5ympKa0WqqTzqlVJUiRsxmXQmt5tkgrlWnOE",
            "client_secret": "lMQb900L-mTeU-FVTCwyhjsfBwRCxwwbCitPob96cuU"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        // Add any necessary headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform the login request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
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
            }
        }.resume()
    }
}
