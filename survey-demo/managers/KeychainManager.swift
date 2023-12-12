//
//  KeychainManager.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    
    private let service = "SurveyKeyChainService"
    
    private init() {
        
    }
    
    func saveTokenType(_ type: String) {
        saveToKeychain(value: type, key: "TokenType")
    }
    
    func saveAccessToken(_ token: String) {
        saveToKeychain(value: token, key: "AccessToken")
    }
    
    func saveRefreshToken(_ token: String) {
        saveToKeychain(value: token, key: "RefreshToken")
    }
    
    func getAccessToken() -> String? {
        return loadFromKeychain(key: "AccessToken")
    }
    
    func getRefreshToken() -> String? {
        return loadFromKeychain(key: "RefreshToken")
    }
    
    func getTokenType() -> String? {
        return loadFromKeychain(key: "TokenType") ?? "Bearer"
    }
    
    func clearTokens() {
        removeFromKeychain(key: "AccessToken")
        removeFromKeychain(key: "RefreshToken")
    }
    
    private func saveToKeychain(value: String, key: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func loadFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    private func removeFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
