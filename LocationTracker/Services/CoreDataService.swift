//
//  CoreDataService.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 15.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataService {
    func fetchLocations() -> [VisitedLocation]
    func saveLocation(_ location: VisitedLocation)
    func deleteLocations()
}

struct CoreDataServiceImpl: CoreDataService {
    func fetchLocations() -> [VisitedLocation] {
        guard let context = context else { return [] }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedLocation")
        do {
            if let result = try context.fetch(request) as? [SavedLocation] {
                return result.map {
                    VisitedLocation(location: Location(latitude: $0.lat, longitude: $0.lon),
                                     timestamp: $0.timestamp)
                }
            }
        } catch {
            print(error)
        }
        return []
    }

    func saveLocation(_ location: VisitedLocation) {
        guard let context = context else { return }
        guard let newLocation = NSEntityDescription.insertNewObject(forEntityName: "SavedLocation", into: context) as? SavedLocation else {
            print("Could not insert new location")
            return
        }
        newLocation.lat = location.location.latitude
        newLocation.lon = location.location.longitude
        newLocation.timestamp = location.timestamp
        do {
            try context.save()
            print("Saved")
        } catch {
            print(error)
        }
    }

    func deleteLocations() {
        guard let context = context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedLocation")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            print("Deleted")
        } catch {
            print(error)
        }
    }

    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
}
