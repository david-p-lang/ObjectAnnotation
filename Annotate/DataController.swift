//
//  DataController.swift
//  VirtualTourist
//
//  Created by David Lang on 6/20/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistantContainer: NSPersistentContainer
    static let shared = DataController(name: "Annotate")
    var mainContext: NSManagedObjectContext {return persistantContainer.viewContext}
    
    //Set the persistent container which encapsulates the coredata stack
    init(name: String) {persistantContainer = NSPersistentContainer(name: name)}

    //Complete the creation of the coredata stack
    func load() {
        persistantContainer.loadPersistentStores { (store, error) in
            guard error == nil else {
                fatalError(error?.localizedDescription ?? "Error with loading persistent stores to the data controller's persistent container")
            }
        }
    }
}
