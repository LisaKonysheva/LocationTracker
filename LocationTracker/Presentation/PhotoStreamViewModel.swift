//
//  PhotoStreamViewModel.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation

protocol PhotoStreamViewModel {
    var isEnabled: Bool { get set }
    var photos: [PhotoCellViewModel] { get }
    var callbacks: PhotoStream.Callbacks? { get set }
    func updateTrackingStatus()
    func applicationDidBecomeActive()
}

extension PhotoStream {
    enum ViewState {
        case running(Int)
        case paused
    }

    struct Callbacks {
        var viewStateChanged: (PhotoStream.ViewState) -> Void
        var dataUpdated: () -> Void
        var permissionsAlert: () -> Void
        var error: (Error) -> Void
    }

    final class ViewModel: PhotoStreamViewModel {
        var callbacks: PhotoStream.Callbacks?
        private(set) var photos = [PhotoCellViewModel]()

        private let coreDataService: CoreDataService
        private let fetchPhotoService: FetchPhotoService
        private let locationService: LocationService
        private var trackingInProgress = false

        init(fetchPhotoService: FetchPhotoService,
             locationService: LocationService,
             coreDataService: CoreDataService) {
            self.fetchPhotoService = fetchPhotoService
            self.locationService = locationService
            self.coreDataService = coreDataService

            self.locationService.events = LocationServiceEvents(newLocationHandler: { [weak self] in
                guard let self = self, self.trackingInProgress else { return }
                self.addLocationToTop($0)
            }, errorHandler: { [weak self] error in
                self?.callbacks?.error(error)
                print(error)
            })
        }

        var isEnabled = false {
            didSet {
                guard isEnabled else { return }
                updateViewState()
            }
        }

        func applicationDidBecomeActive() {
            if trackingInProgress {
                let newLocations = coreDataService.fetchLocations()
                    .sorted { $0.timestamp > $1.timestamp }
                    .prefix(while: { $0.timestamp > photos.first?.location.timestamp ?? 0 })
                    .map { cellModel(for: $0) }
                photos = newLocations + photos
                callbacks?.dataUpdated()
                updateViewState()
            }
        }

        func updateTrackingStatus() {
            trackingInProgress = !trackingInProgress
            updateViewState()

            if trackingInProgress {
                resetPreviousWalk()
                locationService.requestLocationPermissions { [weak self] hasPermissions in
                    guard hasPermissions else {
                        self?.updateTrackingStatus()
                        self?.callbacks?.permissionsAlert()
                        return
                    }
                    self?.locationService.start()
                }
            } else {
                locationService.stop()
            }
        }

        private func addLocationToTop(_ location: VisitedLocation) {
            photos.insert(cellModel(for: location), at: 0)
            callbacks?.dataUpdated()
            updateViewState()
        }

        private func cellModel(for location: VisitedLocation) -> PhotoCellViewModel {
            PhotoCellViewModelImpl(
                networkService: NetworkServiceImpl(),
                fetchPhotoService: fetchPhotoService,
                location: location,
                errorCallback: { [weak self] in
                    self?.callbacks?.error($0)
            })
        }

        private func resetPreviousWalk() {
            coreDataService.deleteLocations()
            photos = []
            updateViewState()
        }

        private func updateViewState() {
            let viewState: PhotoStream.ViewState = {
                guard trackingInProgress else {
                    return .paused
                }
                return .running(photos.count)
            }()
            callbacks?.viewStateChanged(viewState)
        }
    }
}

extension PhotoStream.ViewState {
    var buttonTitle: String {
        switch self {
        case .running: return "Stop"
        case .paused: return "Start"
        }
    }

    var statusTitle: String {
        switch self {
        case .running(let locationsCount):
            guard locationsCount > 0 else {
                return "You'll see your feed in a while..."
            }
            return "We've spotted \(locationsCount) location(s) so far"
        case .paused:
            return "Tap Start to begin your walk"
        }
    }
}
