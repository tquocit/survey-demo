//
//  BaseNetwork.swift
//  survey-demo
//
//  Created by Quoc Nguyen on 12/12/2023.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class BaseNetwork {
    static let shared = BaseNetwork()

    private init() {}
    
    var baseURL: String = "https://survey-api.nimblehq.co"

    func performRequest(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // Add headers if provided
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }

        // Add parameters for POST request
        if method == .post {
            if let parameters = parameters {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }

            if let data = data {
                completion(.success(data))
            }
        }

        task.resume()
    }
}
