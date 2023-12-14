//
//  KeychainManager.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation
import Security
import KeychainSwift

class KeychainManager {
    
    private let keychain = KeychainSwift()
    
    var currentUser: User!
    
    func saveUser(_ user: User) {
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            keychain.set(userData, forKey: "user")
        } catch {
            print("Error encoding user data: \(error)")
        }
    }
    
    func getUser() -> User? {
        do {
            if let userData = keychain.getData("user") {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: userData)
                currentUser = user
                return user
            }
        } catch {
            print("Error decoding user data: \(error)")
        }
        return nil
    }
    
    func deleteUser() {
        keychain.delete("user")
    }
}
