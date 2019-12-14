//
//  URLFactoryTests.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import XCTest
@testable import LocationTracker

class URLFactoryTests: XCTestCase {
    var sut: URLFactoryImpl!

    override func setUp() {
        sut = URLFactoryImpl()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFactoryReturnsCorrectURL() {
        let url = sut.makeURL(for: Location.stubInstance())

        XCTAssertTrue(url.scheme ?? "" == "https")
        XCTAssertTrue(url.host ?? "" == "api.flickr.com")
        XCTAssertTrue(url.relativePath == "/services/rest")

        let query = url.query ?? ""
        let querySorted = query.components(separatedBy: "&").sorted().joined(separator: "&")
        XCTAssertTrue(querySorted == "api_key=a579f2b95eb0372527f0930e35b2d5a7&extras=url_m&format=json&lat=52.496208&lon=13.308389&method=flickr.photos.search&nojsoncallback=1&per_page=1&radius=0.04")
    }
}

