//
//  LocationServiceTests.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import XCTest
import CoreLocation
@testable import LocationTracker

class LocationServiceTests: XCTestCase {
    var sut: LocationServiceImpl!
    var locationManagerMock: LocationManagerMock!
    var coreDataServiceMock: CoreDataServiceMock!

    override func setUp() {
        locationManagerMock = LocationManagerMock()
        coreDataServiceMock = CoreDataServiceMock()
        sut = LocationServiceImpl(
            locationManager: locationManagerMock,
            coreDataService: coreDataServiceMock
        )
    }

    override func tearDown() {
        locationManagerMock = nil
        sut = nil
        super.tearDown()
    }

    func testLocationManagerStartsUpdatingLocation() {
        sut.start()
        XCTAssertTrue(locationManagerMock.startUpdatingLocationCalled)
    }

    func testLocationManagerStopsUpdatingLocation() {
        sut.stop()
        XCTAssertTrue(locationManagerMock.stopUpdatingLocationCalled)
    }

    func testRequestAlwaysPermissions() {
        sut.requestLocationPermissions { _ in }
        XCTAssertTrue(locationManagerMock.requestAlwaysAuthorizationCalled)
    }

    func testLocationIsSavedToDataBase() {
        let stubLocation = Location.stubInstance()
        let location = CLLocation(latitude: stubLocation.latitude, longitude: stubLocation.longitude)
        locationManagerMock.delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [location])
        XCTAssertTrue(coreDataServiceMock.saveLocationInvoked)
    }
}
