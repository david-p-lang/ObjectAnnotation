//
//  ViewController.swift
//  Annotate
//
//  Created by David Lang on 7/6/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    // declare / initialize properties
    var setName = ""
    var trainingSetResultsController:NSFetchedResultsController<TrainingSet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register tableview cell
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Cell)
        
        configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchObjectDetectionSets(nil)
    }
    
    /// setup the navigation bar
    fileprivate func configureNavigation() {
        
        //set the title
        self.navigationItem.title = "Object Sets"
        
        //addButton creates a new oject detection set that contains annotated images.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addSetAlert))
        
        //Unicode gear without hub
        let settingsTitle = "\u{2699}"
        
        //brings up the settings screen
        let settingsButton = UIBarButtonItem(title: settingsTitle, style: .plain, target: self, action: #selector(ViewController.settings))
        
        //add the buttons to the right side of the navigation
        self.navigationItem.rightBarButtonItems = [addButton, settingsButton]
    }
    

    @objc func settings() {
        // add default email address
    }
    
    /// Fetch Training Sets based on the predicate parameter
    ///
    /// - Parameter predicate: selection criteria
    func fetchObjectDetectionSets(_ predicate: NSPredicate?) {
        
        //declare a request of type training set
        let request:NSFetchRequest<TrainingSet> = TrainingSet.fetchRequest()
        
        //sort descriptors required
        request.sortDescriptors = []
        
        //add a predicate
        request.predicate = predicate
        
        //initialize the results controller 
        trainingSetResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try trainingSetResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    ///Create a new training set, save to data model context, fetch and reload the data for the table
    @objc func addSet() {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrainingSet", in: DataController.shared.mainContext) else { return }
        let newTrainingSet = TrainingSet(entity: entity, insertInto: DataController.shared.mainContext)
        newTrainingSet.name = setName
        try? DataController.shared.mainContext.save()
        fetchObjectDetectionSets(nil)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = trainingSetResultsController?.sections?[section].numberOfObjects ?? 0
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell, for: indexPath)
        let trainingSetArray = Array(trainingSetResultsController.fetchedObjects!)
        cell.textLabel?.text = trainingSetArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get the selected cell
        let cell = tableView.cellForRow(at: indexPath)
        
        //obtain the name of the set for selection criteria below
        guard let name = cell?.textLabel?.text else {return}
        
        //select for choosen set name
        fetchObjectDetectionSets(NSPredicate(format: "name == %@", name))
        
        //Navigate to the TrainingSetVC
        pushController()
    }
    
    func pushController() {
        
        // create a flow layout for the TrainingSetVC collection view
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width / 2.06
        let height = view.bounds.height / 6
        
        //create the cell size
        flowLayout.itemSize = CGSize(width: width, height: height)
        let viewController = TrainingSetVC(collectionViewLayout: flowLayout)
        
        //pass the training set to the
        viewController.trainingSet = trainingSetResultsController.fetchedObjects?.first
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    @objc func addSetAlert(){
        let alert = UIAlertController(title: "Add Detection Set", message: nil, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: {(_) in
            guard let setName = alert.textFields?[0].text else { return }
            self.setName = setName
            self.addSet()
        })
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "Set Name"
        }
        present(alert, animated: true, completion: nil)
    }

}
