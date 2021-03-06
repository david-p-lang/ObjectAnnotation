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
        tableView.separatorStyle = .none
        tableView.separatorInset.left = 0
        
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
        let settingsTitle = Constants.wheelWithoutHubKey
        
        //brings up the settings screen
        let settingsButton = UIBarButtonItem(title: settingsTitle, style: .plain, target: self, action: #selector(ViewController.settings))
        
        //add the buttons to the right side of the navigation
        self.navigationItem.rightBarButtonItems = [addButton, settingsButton]
    }
    
    @objc func settings() {
        let vC = SettingsVC()
        navigationController?.pushViewController(vC, animated: true)
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
        
        //prepare to add a training set into coredata
        guard let entity = NSEntityDescription.entity(forEntityName: "TrainingSet", in: DataController.shared.mainContext) else { return }
        let newTrainingSet = TrainingSet(entity: entity, insertInto: DataController.shared.mainContext)
        
        //identify the training set with a name
        newTrainingSet.name = setName
        
        //attempt to save the data
        try? DataController.shared.mainContext.save()
        
        //update the results controller
        fetchObjectDetectionSets(nil)
        
        //reload the information in the tableview
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //use the coredata model to determine the number of objects for display
        let number = trainingSetResultsController?.sections?[section].numberOfObjects ?? 0
        
        //there are no training sets, provide a message to the user to create a training set
        if number == 0 {
            tableView.setEmptyMessage("Add a training set")
        } else {
            tableView.setEmptyMessage("")
        }
        
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell, for: indexPath)
        let trainingSetArray = Array(trainingSetResultsController.fetchedObjects!)
        
        //set the name
        cell.textLabel?.text = trainingSetArray[indexPath.row].name
        
        // center the text in the cell
        cell.textLabel?.textAlignment = .center
        
        //clarify the cell border
        cell.contentView.backgroundColor = UIColor.init(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 0.2)
        
        //the method requires a UITableViewCell is returned
        return cell
    }
    
    
    ///this method allows for deletion of cells and calls removeset to update the our model
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let name = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""
            removeSet(name: name)
            
            //update the results controller
            fetchObjectDetectionSets(nil)
            
            //refresh our tableview
            tableView.reloadData()
        }
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
        
        let width = view.bounds.width / 2.1
        let height = view.bounds.height / 5
        //create the cell size
        flowLayout.itemSize = CGSize(width: width, height: height)
        //let viewController = TrainingSetVC(collectionViewLayout: flowLayout)
        let viewController = TrainingSetVC(nibName: nil, bundle: nil)
        
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
