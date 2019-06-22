//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/20/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    private init () {
        persistentContainer = NSPersistentContainer(name: "VirtualTourist")
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    let backgroundContext:NSManagedObjectContext!
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
}
