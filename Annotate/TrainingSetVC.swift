//
//  TrainingSetVC.swift
//  Annotate
//
//  Created by David Lang on 7/7/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData

class TrainingSetVC: UICollectionViewController {
    
    var trainingSet: TrainingSet!
    var photoArray = [Photo]()
    var setResultsController:NSFetchedResultsController<TrainingSet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView.register(TrainingSetCell.self, forCellWithReuseIdentifier: "Cell")
        print(UIImage(named: "placeholder"))
        self.navigationItem.title = trainingSet.name ?? "Set Content"
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(TrainingSetVC.addPhoto))
        let mediaButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(TrainingSetVC.addPhoto))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TrainingSetVC.addPhoto))

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
    }
    
    @objc func addPhoto() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        let vC = ImageBatchVC(collectionViewLayout: flowLayout)
        vC.trainingSet = self.trainingSet
        navigationController?.pushViewController(vC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSetPhotos()
        let photoSet = trainingSet.photo as? Set<Photo>
        photoArray = Array(photoSet!)
        
    }
    
    func fetchSetPhotos() {

    }
    
//    @objc func addPhoto() {
//        guard let entity = NSEntityDescription.entity(forEntityName: "Photo", in: DataController.shared.mainContext) else {return}
//        let photo = Photo(entity: entity, insertInto: DataController.shared.mainContext)
//        photo.name = "hi"
//        photo.data = UIImage(named: "placeholder")?.jpegData(compressionQuality: 1.0)
//        trainingSet.addToPhoto(photo)
//        collectionView.reloadData()
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainingSet.photo?.count ?? 0
        let number = setResultsController?.sections?[section].numberOfObjects ?? 0
        return number
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrainingSetCell
        //cell..image = UIImage(named: "placeholder")
        //cell.backgroundColor = UIColor.red
        let record = setResultsController.object(at: indexPath)
        record.photo?.allObjects[indexPath]
        cell.nameLabel.text = "hi"
        cell.imageView.image = currentSetArray[indexPath.row].photo.
        return cell
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
