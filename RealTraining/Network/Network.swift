//
//  Network.swift
//  RealTraining
//
//  Created by yc on 2023/10/09.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case jsonError
    case serverError
    case unknown
}

struct NetworkRequest {
    private let path: API.Path
    private let queryItems: [String: String]
    
    init(path: API.Path, queryItems: [String : String]) {
        self.path = path
        self.queryItems = queryItems
    }
    
    func request(method: String = "GET", completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var urlComponent = URLComponents(string: API.host + path.value)
        
        urlComponent?.setQueryItems(with: queryItems)
        
        guard let url = urlComponent?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300) ~= statusCode else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            completion(.success(data))
        }
        
        dataTask.resume()
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
