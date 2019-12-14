//
//  PhotoMocks.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import LocationTracker

extension Photo {
    enum TestData {
        static let id = "43510324351"
        static let url = "https://live.staticflickr.com/1783/43510324351_3cdbd4935c.jpg"
    }

    static func stubInstance() -> Photo {
        Photo(id: TestData.id, url: URL(string: TestData.url)!)
    }

    static func stubJSON() -> [String: Any] {
        ["photos": [
            "photo": [
                    ["id": TestData.id, "url_m": TestData.url]
                ]
            ]
        ]
    }

    static func emptyJSON() -> [String: Any] {
        ["photos": ["photo": []] ]
    }

    static func invalidJSON() -> [String: Any] {
        ["photosOfCats": ["photo": []] ]
    }
}
