//
//  File.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

enum APIConstants {
    static let baseURL = "https://api.flickr.com/services/rest/"
    static let apiKey = "a579f2b95eb0372527f0930e35b2d5a7"
}

protocol URLFactory {
    func makeURL(for location: Location) -> URL
}

struct URLFactoryImpl: URLFactory {
    func makeURL(for location: Location) -> URL {
        var components = URLComponents(string: APIConstants.baseURL)
        components?.queryItems = [
            "method": "flickr.photos.search",
            "api_key": APIConstants.apiKey,
            "format": "json",
            "radius": "0.04",
            "nojsoncallback": "1",
            "per_page": "1",
            "extras": "url_m",
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)"
            ].map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components?.url else {
            fatalError("url cannot be constructed")
        }
        return url
    }
}
