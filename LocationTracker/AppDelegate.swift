//
//  AppDelegate.swift
//  LocationTracker
//
//  Created by Elizaveta Konysheva on 14.12.19.
//  Copyright © 2019 Elizaveta Konysheva. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let navigation = window?.rootViewController as? UINavigationController else { return false }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotoStreamController")

        let coreDataService = CoreDataServiceImpl()

        if let photoStreamController = controller as? PhotoStreamController {
            photoStreamController.viewModel = PhotoStream.ViewModel(
                fetchPhotoService: FetchPhotoServiceImpl(
                    networkService: NetworkServiceImpl(),
                    urlFactory: URLFactoryImpl()
                ),
                locationService: LocationServiceImpl(
                    locationManager: LocationManagerFactory().makeLocationManager(),
                    coreDataService: coreDataService),
                coreDataService: coreDataService
            )
            navigation.setViewControllers([photoStreamController], animated: false)
        }
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Locations")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

