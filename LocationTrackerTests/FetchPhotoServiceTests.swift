//
//  FetchPhotoServiceTests.swift
//  LocationTrackerTests
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import XCTest
@testable import LocationTracker

class FetchPhotoServiceTests: XCTestCase {
    var sut: FetchPhotoServiceImpl!
    var networkService: NetworkServiceMock!
    var urlFactory: URLFactoryMock!

    func testServiceReturnsError() {
        setup(with: .failure(.noData))

        let exp = expectation(description: "error")
        sut.fetchPhoto(for: Location.stubInstance()) { result in
            let noDataErrorReceived: Bool = {
                if case Result.failure(let error) = result,
                    let networkError = error as? NetworkError,
                    case .noData = networkError {
                    return true
                }
                return false
            }()
            XCTAssertTrue(noDataErrorReceived)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testServiceReturnsPhoto() {
        setup(with: Photo.stubJSON())

        let exp = expectation(description: "valid response")
        sut.fetchPhoto(for: Location.stubInstance()) { result in
            let validResponse: Bool = {
                guard let photo = try? result.get(),
                    photo.id == Photo.TestData.id,
                    photo.url == URL(string: Photo.TestData.url)! else {
                    return false
                }
                return true
            }()
            XCTAssertTrue(validResponse)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testServiceReturnsEmptyListError() {
        setup(with: Photo.emptyJSON())

        let exp = expectation(description: "error")
        sut.fetchPhoto(for: Location.stubInstance()) { result in
            let noDataErrorReceived: Bool = {
                if case Result.failure(let error) = result,
                    let networkError = error as? FetchPhotoError,
                    case .emptyList = networkError {
                    return true
                }
                return false
            }()
            XCTAssertTrue(noDataErrorReceived)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    func testServiceReturnsParsingError() {
        setup(with: Photo.invalidJSON())

        let exp = expectation(description: "error")
        sut.fetchPhoto(for: Location.stubInstance()) { result in
            let noDataErrorReceived: Bool = {
                if case Result.failure(let error) = result,
                    let networkError = error as? FetchPhotoError,
                    case .parsingError = networkError {
                    return true
                }
                return false
            }()
            XCTAssertTrue(noDataErrorReceived)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

    // MARK: Helper methods

    func setup(with result: Result<Data, NetworkError>) {
        networkService = NetworkServiceMock()
        networkService.stubResult = result
        urlFactory = URLFactoryMock()
        sut = FetchPhotoServiceImpl(networkService: networkService, urlFactory: urlFactory)
    }

    func setup(with json: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        setup(with: .success(jsonData))
    }

    override func tearDown() {
        sut = nil
        networkService = nil
        urlFactory = nil
        super.tearDown()
    }
}
