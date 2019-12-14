//
//  FetchPhotoService.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

protocol FetchPhotoService {
    func fetchPhoto(for location: Location, completion: @escaping (Result<Photo, Error>) -> Void)
}

enum FetchPhotoError: Error {
    case emptyList
    case parsingError
}

struct FetchPhotoServiceImpl: FetchPhotoService {
    private let networkService: NetworkService
    private let urlFactory: URLFactory

    init(networkService: NetworkService,
         urlFactory: URLFactory) {
        self.networkService = networkService
        self.urlFactory = urlFactory
    }

    func fetchPhoto(for location: Location, completion: @escaping (Result<Photo, Error>) -> Void) {
        let urlRequest = URLRequest(url: urlFactory.makeURL(for: location))
        networkService.perform(request: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(PhotosList.self, from: data)
                    guard let photo = result.photos.first else {                        
                        completion(.failure(FetchPhotoError.emptyList))
                        return
                    }
                    completion(.success(photo))
                } catch {
                    completion(.failure(FetchPhotoError.parsingError))
                }
            case .failure(let error):                
                completion(.failure(error))
            }
        }
    }
}
