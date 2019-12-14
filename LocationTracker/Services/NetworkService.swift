//
//  NetworkService.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case serverError(Error)
    case noConnection
    case noData    
}

protocol NetworkService {
    func perform(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

struct NetworkServiceImpl: NetworkService {
    func perform(
        request: URLRequest,
        completion: @escaping (Result<Data, NetworkError>) -> Void) {

        let handleError: (NetworkError) -> Void = { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                guard let code = (error as? URLError)?.code, code == .notConnectedToInternet else {
                    handleError(.serverError(error))
                    return
                }
                handleError(.noConnection)
                return
            }

            guard let data = data else {
                handleError(.noData)
                return
            }

            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}
