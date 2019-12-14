//
//  URLFactoryMock.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
@testable import LocationTracker

struct URLFactoryMock: URLFactory {
    var stubURL: URL?

    func makeURL(for location: Location) -> URL {
        stubURL ?? URL(string: "http://google.com")!
    }
}


