//
//  LocationManagerMock.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import CoreLocation
@testable import LocationTracker

class LocationManagerMock: LocationManager {
    var startUpdatingLocationCalled = false
    func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }

    var stopUpdatingLocationCalled = false
    func stopUpdatingLocation() {
        stopUpdatingLocationCalled = true
    }

    var requestAlwaysAuthorizationCalled = false
    func requestAlwaysAuthorization() {
        requestAlwaysAuthorizationCalled = true
    }

    var delegate: CLLocationManagerDelegate?
}
