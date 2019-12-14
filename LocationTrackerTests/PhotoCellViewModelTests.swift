//
//  PhotoCellViewModelTests.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 16.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import XCTest
@testable import LocationTracker

class PhotoCellViewModelTests: XCTestCase {
    var sut: PhotoCellViewModelImpl!

    var networkService: NetworkServiceMock!
    var fetchPhotoService: FetchPhotoServiceMock!
    var location: VisitedLocation!
    var errorHandlerInvoked = false

    override func setUp() {
        networkService = NetworkServiceMock()
        fetchPhotoService = FetchPhotoServiceMock()
        location = VisitedLocation.stubInstance()

        sut = PhotoCellViewModelImpl(networkService: networkService,
                                     fetchPhotoService: fetchPhotoService,
                                     location: location,
                                     errorCallback: { [weak self] _ in
            self?.errorHandlerInvoked = true
        })
    }

    override func tearDown() {
        networkService = nil
        fetchPhotoService = nil
        location = nil
        sut = nil
        super.tearDown()
    }

    func testPhotoLoaded() {
        fetchPhotoService.stubResult = .success(Photo.stubInstance())
        let data = UIImage(named: "icon-warning")
        networkService.stubResult = .success(data!.pngData()!)

        var photoIsLoaded = false
        sut.viewStateUpdated = {
            if case .loaded(_) = $0 {
                photoIsLoaded = true
            }
        }
        sut.loadImage()
        XCTAssertTrue(photoIsLoaded)
    }

    func testErrorReceived() {
        fetchPhotoService.stubResult = .failure(NetworkError.noConnection)
        var loadingFailed = false
        sut.viewStateUpdated = {
            if case .loadingFailed = $0 {
                loadingFailed = true
            }
        }
        sut.loadImage()
        XCTAssertTrue(loadingFailed)
        XCTAssertTrue(errorHandlerInvoked)
    }
}

