//
//  SurveyManager.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation

class SurveyManager {
    static let shared = SurveyManager()
    
    private init() {}
    
    func fetchSurveys(pageNumber: Int, pageSize: Int, completion: @escaping (Result<SurveyList, Error>) -> Void) {
        let endpoint = "/api/v1/surveys?page[number]=\(pageNumber)&page[size]=\(pageSize)"
        
        if let userAccessToken = KeychainManager.shared.getAccessToken(),
           let userTokenType = KeychainManager.shared.getTokenType() {
            let headers = ["Authorization": "\(userTokenType) \(userAccessToken)"]
            
            BaseNetwork.shared.performRequest(endpoint: endpoint, method: .get, headers: headers) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let surveys = try decoder.decode(SurveyList.self, from: data)
                        completion(.success(surveys))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network request error: \(error)")
                }
            }
        }
        else {
            // Handle missing access token or token type
        }
    }
    
}
