//
//  LocationMocks.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import LocationTracker

extension Location {
    static func stubInstance() -> Location {
        Location(latitude: 52.496208, longitude: 13.308389)
    }
}

extension VisitedLocation {
    static let stubTimestamp: Double = 1576501597.646295
    static func stubInstance() -> VisitedLocation {
        VisitedLocation(location: Location.stubInstance(),
                        timestamp: VisitedLocation.stubTimestamp)
    }
}
