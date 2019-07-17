//
//  DataController.swift
//  WeatherApp
//

import CoreData

class DataController {
    
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    init() {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        mainContext = container.viewContext
        backgroundContext = container.newBackgroundContext()
    }
    
}
