//
//  PhotoStreamViewModelTests.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import XCTest
@testable import LocationTracker

class PhotoStreamViewModelTests: XCTestCase {
    var sut: PhotoStream.ViewModel!
    var fetchPhotoService: FetchPhotoServiceMock!
    var locationService: LocationServiceMock!
    var coreDataService: CoreDataServiceMock!

    var viewStateCallback: PhotoStream.ViewState?
    var permissionsAlertCallbackInvoked: Bool?
    var errorCallback: Error?
    var dataUpdatedCallbackInvoked: Bool?

    override func setUp() {
        fetchPhotoService = FetchPhotoServiceMock()
        locationService = LocationServiceMock()
        coreDataService = CoreDataServiceMock()
        sut = PhotoStream.ViewModel(fetchPhotoService: fetchPhotoService,
                                    locationService: locationService,
                                    coreDataService: coreDataService)

        sut.callbacks = PhotoStream.Callbacks(viewStateChanged: { [weak self] in
            self?.viewStateCallback = $0
        }, dataUpdated: { [weak self] in
            self?.dataUpdatedCallbackInvoked = true
        }, permissionsAlert: { [weak self] in
            self?.permissionsAlertCallbackInvoked = true
        }, error: { [weak self] in
            self?.errorCallback = $0
        })
    }

    override func tearDown() {
        viewStateCallback = nil
        permissionsAlertCallbackInvoked = nil
        errorCallback = nil
        dataUpdatedCallbackInvoked = nil
        fetchPhotoService = nil
        locationService = nil
        sut = nil
        super.tearDown()
    }

    func testLocationServiceStops() {
        XCTAssertFalse(locationService.stopped)
        sut.updateTrackingStatus()
        sut.updateTrackingStatus()
        XCTAssertTrue(locationService.stopped)
    }

    func testButtonTitle_OnEnabled() {
        sut.isEnabled = true
        XCTAssertTrue(viewStateCallback?.buttonTitle == "Start")
    }

    func testButtonTitle_AfterStart() {
        sut.updateTrackingStatus()
        XCTAssertTrue(viewStateCallback?.buttonTitle == "Stop")
    }

    func testButtonTitle_AfterStop() {
        sut.updateTrackingStatus()
        sut.updateTrackingStatus()
        XCTAssertTrue(viewStateCallback?.buttonTitle == "Start")
    }

    func testUpdatingLocationStarts_WhenPermissionsEnabled() {
        locationService.permissionsEnabled = true
        sut.updateTrackingStatus()
        XCTAssertTrue(locationService.started)
    }

    func testPermissionsCallbackFired_WhenPermissionsDisabled() {
        locationService.permissionsEnabled = false
        sut.updateTrackingStatus()
        XCTAssertTrue(permissionsAlertCallbackInvoked == true)
    }

    func testNoFetching_AfterLocationReceived_IfNotTracking() {
        let testLocation = VisitedLocation.stubInstance()
        locationService.events?.newLocationHandler(testLocation)
        XCTAssertFalse(fetchPhotoService.fetchingStarted)
    }

    func testDataUpdated_AfterPhotoReceived() {
        locationService.permissionsEnabled = true

        sut.updateTrackingStatus()
        locationService.events?.newLocationHandler(VisitedLocation.stubInstance())

        XCTAssertTrue(dataUpdatedCallbackInvoked == true)
    }

    func testErrorReceived() {
        fetchPhotoService.stubResult = .failure(NetworkError.noConnection)
        locationService.permissionsEnabled = true

        sut.updateTrackingStatus()
        locationService.events?.newLocationHandler(VisitedLocation.stubInstance())
        sut.photos.first?.loadImage()

        XCTAssertTrue(errorCallback != nil)
    }

    func testDataLoadedFromDataBase_WhenAppBecomesActive() {
        let location = VisitedLocation.stubInstance()
        coreDataService.stubLocations = [location]
        sut.updateTrackingStatus()
        sut.applicationDidBecomeActive()

        XCTAssertTrue(dataUpdatedCallbackInvoked == true)
        XCTAssertTrue(coreDataService.fetchLocationsInvoked)
        XCTAssertTrue(sut.photos.first?.location.location.latitude == location.location.latitude)
        XCTAssertTrue(sut.photos.first?.location.location.longitude == location.location.longitude)
    }

    func testLocationsDeletedFromDataBase_WhenNewTrackingStarts() {
        sut.updateTrackingStatus()
        XCTAssertTrue(coreDataService.deleteLocationsInvoked)
    }
}
