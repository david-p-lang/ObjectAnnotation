//
//  TrainingSetVC.swift
//  Annotate
//
//  Created by David Lang on 7/7/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData

class TrainingSetVC: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var trainingSet: TrainingSet!
    var photoArray = [Photo]()
    var setResultsController:NSFetchedResultsController<TrainingSet>!


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView.register(TrainingSetCell.self, forCellWithReuseIdentifier: Constants.Cell)
        collectionView.backgroundColor = .white
        navigationSetup()

    }
    
    fileprivate func navigationSetup() {
        self.navigationItem.title = trainingSet.name ?? "Set Content"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(TrainingSetVC.addPhoto))
        let mediaButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(TrainingSetVC.addPhoto))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(TrainingSetVC.shareSet))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TrainingSetVC.addPhoto))
        self.navigationItem.rightBarButtonItems = [searchButton, shareButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchSet()
    }
    
    func fetchSet() {
        let request:NSFetchRequest<TrainingSet> = NSFetchRequest(entityName: "TrainingSet")
        let predicate = NSPredicate(format: "name == %@", trainingSet.name!)
        request.sortDescriptors = []
        request.predicate = predicate
        setResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try setResultsController.performFetch()
        } catch {
            print(error)
        }
        collectionView.reloadData()
    }
    
    // Based on reply:answered Jun 4 '17 at 13:50 Bobby
    //https://stackoverflow.com/questions/37344822/saving-image-and-then-loading-it-in-swift-ios
    func saveImage(photo: Photo, destination: URL) -> Bool {
        
        guard let data = photo.data, let name = photo.name else {
            print("data  problem")
            return false
        }

        do {
            try data.write(to: destination.appendingPathComponent(name))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func checkDirectory() -> URL? {
        let setFolderName = trainingSet.name!
        guard let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) as URL else {
            print("document problem")
            return nil            
        }
        
        let setDirectory = documentDirectory.appendingPathComponent(setFolderName, isDirectory: true)
     
        do {
            try FileManager.default.createDirectory(at: setDirectory, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("Directory Exists")
        }
        
        return setDirectory
        
    }
        

    @objc func shareSet() {
        let alert = UIAlertController(title: "Share", message: nil, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default, handler: {(_) in
            print("saving:")
            guard let trainingSet = self.setResultsController.fetchedObjects?.first else {return}
            guard let photos = trainingSet.photo?.allObjects as? [Photo] else {return}
            
            guard let destinationFolder = self.checkDirectory() else {return}
            
            photos.forEach { (photo) in
                let test = self.saveImage(photo: photo, destination: destinationFolder)
                print("test", test)
            }
        })
        alert.addAction(save)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func addPhoto() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        let vC = ImageBatchVC(collectionViewLayout: flowLayout)
        vC.trainingSet = self.trainingSet
        navigationController?.pushViewController(vC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let photoSet = trainingSet.photo as? Set<Photo>
        photoArray = Array(photoSet!)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let trainingSetFromResults = setResultsController?.fetchedObjects as? [TrainingSet] else {return 0}
        let number = trainingSetFromResults[0].photo?.count ?? 0
        return number
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrainingSetCell
        guard let imageSet = setResultsController.fetchedObjects?.first else {return cell}
        let image = imageSet.photo?.allObjects[indexPath.row] as? Photo
        guard let imageData = image?.data else {return cell}
        cell.imageView.image = UIImage(data: imageData)
        return cell
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let newIndexPath = newIndexPath, let indexPath = indexPath else {return}
        switch (type) {
        case .insert:
                collectionView.insertItems(at: [newIndexPath])
                fetchSet()
                break
        case .delete:
                collectionView.deleteItems(at: [newIndexPath])
                fetchSet()
                break
        case .move:
                collectionView.moveItem(at: indexPath, to: newIndexPath)
                break
        case .update:
                break
        @unknown default:
            break
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = (UIScreen.main.bounds.width - 16)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1;
    }
    


}
