//
//  DataManager.swift
//  JuniorExercize
//
//  Created by Serg on 30.12.2019.
//  Copyright © 2019 Sergey Gladkiy. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    private override init() {
        super.init()
    }
    
    func addRandomUser() {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: persistentContainer.viewContext) as! User
        user.firstName = Source.firstNames.randomElement()
        user.lastName = Source.lastNames.randomElement()
        user.email = user.firstName! + user.lastName! + String(Int.random(in: 1...10)) + "@mail.ru"
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "JuniorExercize")
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
