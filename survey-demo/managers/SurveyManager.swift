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
        let baseUrl = "https://survey-api.nimblehq.co/"
        let apiUrl = baseUrl + "api/v1/surveys?page[number]=\(pageNumber)&page[size]=\(pageSize)"
        
        guard let url = URL(string: apiUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add authorization header
        if let userAccessToken = KeychainManager.shared.getAccessToken(),
           let userTokenType = KeychainManager.shared.getTokenType() {
            let authorizationHeaderValue = "\(userTokenType) \(userAccessToken)"
            request.addValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let surveys = try decoder.decode(SurveyList.self, from: data)
                    completion(.success(surveys))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
