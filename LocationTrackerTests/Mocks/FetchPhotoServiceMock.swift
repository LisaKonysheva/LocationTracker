//
//  FetchPhotoServiceMock.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import LocationTracker

class FetchPhotoServiceMock: FetchPhotoService {
    var stubResult: Result<Photo, Error>?
    private(set) var fetchingStarted = false
    private(set) var locationInWork: Location?

    func fetchPhoto(for location: Location, completion: @escaping (Result<Photo, Error>) -> Void) {
        fetchingStarted = true
        locationInWork = location
        guard let result = stubResult else { return }
        completion(result)
    }
}
