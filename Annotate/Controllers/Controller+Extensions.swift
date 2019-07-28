//
//  UIViewController.swift
//  OnTheMap
//
//  Created by David Lang on 6/6/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
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
    
    func displayAlertMainQueue(_ error: Error) {
        DispatchQueue.main.async {
            let alertInfo = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
            alertInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertInfo, animated: true, completion: nil)
        }
    }
    
    func displayAlert(_ error: Error) {
        let alertInfo = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
        alertInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertInfo, animated: true, completion: nil)
    }
    
}

//Modified from Reply: Samman Bikram Thapa
//https://stackoverflow.com/questions/43772984/how-to-show-a-message-when-collection-view-is-empty
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
