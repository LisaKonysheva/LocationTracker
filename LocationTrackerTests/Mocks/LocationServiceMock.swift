//
//  LocationServiceMock.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import LocationTracker

class LocationServiceMock: LocationService {
    var permissionsEnabled: Bool?
    func requestLocationPermissions(completion: @escaping (Bool) -> Void) {
        guard let stub = permissionsEnabled else { return }
        completion(stub)
    }

    var events: LocationServiceEvents?

    private(set) var started = false
    func start() {
        started = true
    }

    private(set) var stopped = false
    func stop() {
        stopped = true
    }
}
