//
//  File.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import LocationTracker

class NetworkServiceMock: NetworkService {
    var stubResult: Result<Data, NetworkError>?

    func perform(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let result = stubResult else { return }
        completion(result)
    }
}
