//
//  CoreDataExtensions.swift
//  Annotate
//
//  Created by David Lang on 7/10/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import Foundation
import CoreData

extension ViewController {
    
    func fetchSet(name: String) -> [Photo]? {
        var setResultsController:NSFetchedResultsController<TrainingSet>!
        let request:NSFetchRequest<TrainingSet> = NSFetchRequest(entityName: "TrainingSet")
        let predicate = NSPredicate(format: "name == %@", name)
        request.sortDescriptors = []
        request.predicate = predicate
        setResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try setResultsController.performFetch()
        } catch {
            print(error)
        }
        guard let trainingSet = setResultsController.fetchedObjects?.first else { return nil}
        guard let photos = trainingSet.photo?.allObjects as? [Photo] else {return nil}
        return photos
    }
    
    
}
