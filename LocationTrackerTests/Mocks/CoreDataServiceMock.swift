//
//  CoreDataServiceMock.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 16.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import CoreLocation
@testable import LocationTracker

class CoreDataServiceMock: CoreDataService {
    var stubLocations = [VisitedLocation]()

    var fetchLocationsInvoked = false
    func fetchLocations() -> [VisitedLocation] {
        fetchLocationsInvoked = true
        return stubLocations
    }

    var saveLocationInvoked = false
    func saveLocation(_ location: VisitedLocation) {
        saveLocationInvoked = true
    }

    var deleteLocationsInvoked = false
    func deleteLocations() {
        deleteLocationsInvoked = true
    }
}
