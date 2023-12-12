//
//  User.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation

struct UserResponse: Decodable {
    let data: UserData
    
    struct UserData: Decodable {
        let id: String
        let type: String
        let attributes: UserAttributes
        
        struct UserAttributes: Decodable {
            let accessToken: String
            let tokenType: String
            let expiresIn: TimeInterval
            let refreshToken: String
            let createdAt: TimeInterval
            
            enum CodingKeys: String, CodingKey {
                case accessToken = "access_token"
                case tokenType = "token_type"
                case expiresIn = "expires_in"
                case refreshToken = "refresh_token"
                case createdAt = "created_at"
            }
        }
    }
}

struct User: Codable {
    let id: String
    let accessToken: String
    let tokenType: String
    let expiresIn: TimeInterval
    let refreshToken: String
    let createdAt: TimeInterval
}
