//
//  TrainingSetVC.swift
//  Annotate
//
//  Created by David Lang on 7/7/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher
import MessageUI

class TrainingSetVC: UIViewController, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var trainingSet: TrainingSet!
    var setResultsController:NSFetchedResultsController<TrainingSet>!
    var setDataArray = [Data]()
    var dirURL:URL!
    var collectionView:UICollectionView!
    var stackView:UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //register the custom collection view cell
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width / 2.1
        let height = view.bounds.height / 5
        //create the cell size
        flowLayout.itemSize = CGSize(width: width, height: height)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.view.backgroundColor = .black
        
        stackView = UIStackView(frame: self.view.frame)
        stackView.backgroundColor = .black
        self.view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        
        stackView.addArrangedSubview(collectionView)
        collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrainingSetCell.self, forCellWithReuseIdentifier: Constants.Cell)

        
        
        navigationSetup()
    }
    
    ///configure the navigation bar
    fileprivate func navigationSetup() {
        
        self.navigationItem.title = trainingSet.name ?? "Set Content"
        
        //search flickr photos
        let searchButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TrainingSetVC.addPhoto))
        
        //let mediaButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(TrainingSetVC.addMedia)
        
        //transmit the folder with images and the annotations.json file
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(TrainingSetVC.shareSet))
        
        self.navigationItem.rightBarButtonItems = [searchButton, shareButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchSet()
    }
    
    func fetchSet() {
        
        //declare training set fetch request
        let request:NSFetchRequest<TrainingSet> = NSFetchRequest(entityName: "TrainingSet")
        
        //search model base on passed training set name
        let predicate = NSPredicate(format: "name == %@", trainingSet.name ?? Constants.defaultSetName)
        request.predicate = predicate

        //sort descriptor required
        request.sortDescriptors = []
        
        //results controller initializer
        setResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try setResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        //update the collection view
        collectionView.reloadData()
    }
    
    // Based on reply:answered Jun 4 '17 at 13:50 Bobby
    //https://stackoverflow.com/questions/37344822/saving-image-and-then-loading-it-in-swift-ios
    func saveImage(photo: Photo, destination: URL) -> URL? {
        
        guard let data = photo.data, let name = photo.name else {return nil}
        
        //try to save the photo to the destination folder.
        do {
            let url = destination.appendingPathComponent(name)
            try data.write(to: destination.appendingPathComponent(name))
            return url
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //the annotations file lists the image name and the object annoatation details (x,y,width,height)
    func saveAnnotationFile(data: Data, destination: URL) -> URL? {
        do {
            let url = destination.appendingPathComponent("annotations.json")
            try data.write(to: destination.appendingPathComponent("annotations.json"))
            return url
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func checkDirectory() -> URL? {
        let setFolderName = trainingSet.name ?? Constants.defaultSetName
        guard let documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) as URL else {
            return nil            
        }
        
        //new folder name base on training set model name
        let setDirectory = documentDirectory.appendingPathComponent(setFolderName, isDirectory: true)
        dirURL = setDirectory
     
        do {
            try FileManager.default.createDirectory(at: setDirectory, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print("Directory error, the directory may already exist")
        }
        return setDirectory
    }
    
    /// Encode the annotation info asociated with the image
    ///
    /// - Parameter annotationSet: x,y,width, height, label, name
    /// - Returns: the encoded json data
    func encodeAnnotationSet(annotationSet: [ImageInfo]) -> Data {
        var allAnnotations = Data()
        let objectAnnotationEncoder = JSONEncoder()
        objectAnnotationEncoder.outputFormatting = [.prettyPrinted]
        //objectAnnotationEncoder.outputFormatting = .prettyPrinted
        do {
            allAnnotations = try objectAnnotationEncoder.encode(annotationSet)
        } catch {
            print(error.localizedDescription)
        }
        return allAnnotations
    }
    
    /// The coredata model photo provides the data for conversion to JSON
    ///
    /// - Parameter photo: Coredata photo
    /// - Returns: the codable struct Image info defined in the JSON structs file
    func encodeAnnotation(photo: Photo) -> ImageInfo {
        let annotation = Annotation(label: photo.label ?? "", coordinates: Coordinates(x: Int(photo.x), y: Int(photo.y), width: Int(photo.width), height: Int(photo.height)))
        let imageInfo = ImageInfo(image: photo.name ?? "", annotations: [annotation])
        return imageInfo
    }
    
    /// Utilize the standard alert to transmit or save the training set
    func airDrop() {
        guard let dirURL = dirURL else { return }
        print(dirURL)
        let controller = UIActivityViewController(activityItems: [dirURL], applicationActivities: nil)
        controller.excludedActivityTypes = [.postToTencentWeibo, .postToFacebook, .postToTwitter, .postToVimeo, .openInIBooks, .addToReadingList, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .message, .print, .markupAsPDF]
        self.present(controller, animated: true, completion: nil)
    }


    /// build the folder with image data and the annotations.json file
    @objc func shareSet() {
        guard let trainingSet = self.setResultsController.fetchedObjects?.first else {return}
        guard let photos = trainingSet.photo?.allObjects as? [Photo] else {return}
        
        guard let destinationFolder = self.checkDirectory() else {return}
        var jsonAnnotation = Data()
        var annotationSet = [ImageInfo]()
        
        photos.forEach { (photo) in
            guard let _ = self.saveImage(photo: photo, destination: destinationFolder) else {return}
            annotationSet.append(self.encodeAnnotation(photo: photo))
            guard let photoData = photo.data else {return}
            self.setDataArray.append(photoData)
        }
        jsonAnnotation = self.encodeAnnotationSet(annotationSet: annotationSet)
        guard let _ = self.saveAnnotationFile(data: jsonAnnotation, destination: destinationFolder) else {return}
        self.setDataArray.append(jsonAnnotation)
        
        //air drop or other method of saving transmitting as allowed
        self.airDrop()
    }
    
    @objc func addPhoto() {
        
        let flowLayout = UICollectionViewFlowLayout()
        let vC = MediaCVC(collectionViewLayout: flowLayout)
        vC.collectionViewFlowLayout = flowLayout
        vC.trainingSet = self.trainingSet
        self.navigationController?.pushViewController(vC, animated: true)

        /*
        // create a flow layout for the TrainingSetVC collection view
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = view.bounds.width / 2.1
        let height = view.bounds.height / 5
        
        //set the cell size
        flowLayout.itemSize = CGSize(width: width, height: height)

        let vC = ImageBatchVC(collectionViewLayout: flowLayout)
        
        // designate the training set for the next view controller
        vC.trainingSet = self.trainingSet
        navigationController?.pushViewController(vC, animated: true)
         */
    }
 

    ///handle changes to the data so that the collection view is updated
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
}

extension TrainingSetVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //determine the number of training sets
    guard let trainingSetFromResults = setResultsController?.fetchedObjects else {return 0}
    
    //the total number of photos or 0 if nil
    let number = trainingSetFromResults[0].photo?.count ?? 0
    
    //provide prompt for the user to add images if none are present
    if number == 0 {
        collectionView.setEmptyMessage(NSLocalizedString("Click + to add training set images", comment: ""))
    } else {
        collectionView.setEmptyMessage(NSLocalizedString("", comment: ""))
    }
    
    return number
}

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell, for: indexPath) as! TrainingSetCell
    
    // obtain the correct training set
    guard let imageSet = setResultsController.fetchedObjects?.first else {return cell}
    
    // set the image for the given index path
    let image = imageSet.photo?.allObjects[indexPath.row] as? Photo
    
    // obtain the actual image data for display and the object label
    guard let imageData = image?.data, let label = image?.label else {return cell}
    
    // for this view controller we want to display the associated label with the image
    cell.stack.addArrangedSubview(cell.nameLabel)
    
    //adapt the custom cell constraints for the namelabel
    cell.trainingConstraints()
    
    cell.nameLabel.text = label
    cell.imageView.image = UIImage(data: imageData)
    return cell
}
}
