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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.collectionView.register(TrainingSetCell.self, forCellWithReuseIdentifier: "Cell")
        print(UIImage(named: "placeholder"))
        self.navigationItem.title = "Set Content"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TrainingSetVC.addPhoto))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSetPhotos()
    }
    
    func fetchSetPhotos() {
    }
    
    @objc func addPhoto() {
        guard let entity = NSEntityDescription.entity(forEntityName: "Photo", in: DataController.shared.mainContext) else {return}
        let photo = Photo(entity: entity, insertInto: DataController.shared.mainContext)
        photo.name = "hi"
        photo.data = UIImage(named: "placeholder")?.jpegData(compressionQuality: 1.0)
        trainingSet.addToPhoto(photo)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainingSet.photo?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrainingSetCell
        //cell..image = UIImage(named: "placeholder")
        cell.backgroundColor = UIColor.red
        return cell
    }
    

}
