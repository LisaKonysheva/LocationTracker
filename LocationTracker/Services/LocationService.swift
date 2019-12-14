//
//  LocationService.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationService: class {
    var events: LocationServiceEvents? { get set }
    func requestLocationPermissions(completion: @escaping (Bool) -> Void)
    func start()
    func stop()
}

protocol LocationManager: class {
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestAlwaysAuthorization()    
    var delegate: CLLocationManagerDelegate? { get set }
}

extension CLLocationManager: LocationManager {}

struct LocationServiceEvents {
    let newLocationHandler: (VisitedLocation) -> Void
    let errorHandler: (Error) -> Void
}

final class LocationServiceImpl: NSObject, LocationService {
    var events: LocationServiceEvents?
    private let locationManager: LocationManager
    private let coreDataService: CoreDataService
    private var previousLocation: CLLocation?

    init(locationManager: LocationManager,
         coreDataService: CoreDataService) {
        self.locationManager = locationManager
        self.coreDataService = coreDataService
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermissions(completion: @escaping (Bool) -> Void) {
        guard CLLocationManager.authorizationStatus() != .denied else {
            completion(false)
            return
        }
        locationManager.requestAlwaysAuthorization()
        completion(true)
    }

    func start() {
        previousLocation = nil
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard let previous = previousLocation else {
            // Tracking just started, send initial location
            previousLocation = location
            sendLocationCallback(location)
            return
        }

        let distance = previous.distance(from: location)
        guard distance >= manager.distanceFilter else { return }
        previousLocation = location
        sendLocationCallback(location)
    }

    private func sendLocationCallback(_ location: CLLocation) {
        let location = Location(latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)
        let visitedLocation = VisitedLocation(location: location,
                                               timestamp: Date().timeIntervalSince1970)
        coreDataService.saveLocation(visitedLocation)
        if case .active = UIApplication.shared.applicationState {
            events?.newLocationHandler(visitedLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        events?.errorHandler(error)
    }
}
