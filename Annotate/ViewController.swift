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

    var setName = ""
    var trainingSetResultsController:NSFetchedResultsController<TrainingSet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.title = "Object Sets"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addSetAlert))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchObjectDetectionSets(nil)
    }
    
    func fetchObjectDetectionSets(_ predicate: NSPredicate?) {
        let request:NSFetchRequest<TrainingSet> = TrainingSet.fetchRequest()
        request.sortDescriptors = []
        trainingSetResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try trainingSetResultsController.performFetch()
        } catch {
            print("error")
        }
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let trainingSetArray = Array(trainingSetResultsController.fetchedObjects!) as! [TrainingSet]
        cell.textLabel?.text = trainingSetArray[indexPath.row].name
        print(trainingSetArray[indexPath.row].objectID)
        cell.detailTextLabel?.text = trainingSetArray[indexPath.row].objectID as! String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let name = cell?.textLabel?.text else {return}
        fetchObjectDetectionSets(NSPredicate(format: "name == %@", name))
        pushController()
    }
    
    func pushController() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        let viewController = TrainingSetVC(collectionViewLayout: flowLayout)
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
        print("present")
    }

}
