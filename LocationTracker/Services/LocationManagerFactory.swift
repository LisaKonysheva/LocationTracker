//
//  LocationManagerConfig.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import CoreLocation

struct LocationManagerFactory {
    func makeLocationManager() -> LocationManager {
        let locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }
}

