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
    
    func removeSet(name: String) {
        
        //declare a results controller
        var setResultsController:NSFetchedResultsController<TrainingSet>!
        
        //create a request of type training set
        let request:NSFetchRequest<TrainingSet> = NSFetchRequest(entityName: "TrainingSet")
        
        //select based on the predicate
        let predicate = NSPredicate(format: "name == %@", name)
        
        //the sort descriptors have to be declared even if there are none
        request.sortDescriptors = []
        
        //add the predicate to the request
        request.predicate = predicate
        
        //attach the fetchrequest to the resultscontroller
        setResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        //performing the fetch can throw
        do {
            try setResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        //obtain the first result of the fetch
        guard let trainingSet = setResultsController.fetchedObjects?.first else { return }
        
        //delete and save
        DataController.shared.mainContext.delete(trainingSet)
        try? DataController.shared.mainContext.save()

    }
    
    
}
