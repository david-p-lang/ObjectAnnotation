//
//  EditorVC.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class AnnotationStore: NSObject {
    
    static func saveModel(trainingSet: TrainingSet, photo: Photo) {
        trainingSet.addToPhoto(photo)
        try? DataController.shared.mainContext.save()
    }
}

class EditorVC: UIViewController {
    
    var trainingSet:TrainingSet!
    var photo:Photo!
    var imageView: UIImageView!
    var passedImage: UIImage?
    var objectSelectionTap = UILongPressGestureRecognizer()
    var imageName = ""
    var objectName = ""
    
    var opposingPoints = [CGPoint]()
    var reticleInner = CAShapeLayer()
    var reticleOuter = CAShapeLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let currentImage = passedImage?.resized(toWidth: self.view.frame.width) else {return}
        imageView = UIImageView()
        imageView.backgroundColor = .white
        
        //ensure correct image scale
        imageView.contentMode = .scaleAspectFit
        imageView.image = currentImage

        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: DataController.shared.mainContext)
        photo = Photo(entity: entity!, insertInto: DataController.shared.mainContext)
        photo.data = currentImage.jpegData(compressionQuality: 1.0)
        
        //declare the gesture recognizer and add to the view
        objectSelectionTap = UILongPressGestureRecognizer(target: self, action: #selector(EditorVC.tap(sender:)))
        self.view.addGestureRecognizer(objectSelectionTap)
        
        view.addSubview(imageView)
        configureContraints()
    }
    
    /// setup contraints
    fileprivate func configureContraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

    fileprivate func showGestures(_ location: CGPoint, radius: CGFloat, subLayer: CAShapeLayer) {
        subLayer.path = UIBezierPath(ovalIn: CGRect(x: -0.5 * radius, y: -0.5 * radius, width: radius, height: radius)).cgPath
        subLayer.position = location
        subLayer.fillColor = UIColor.clear.cgColor
        subLayer.strokeColor = UIColor.red.cgColor
        imageView.layer.addSublayer(subLayer)
    }
    
    fileprivate func rectTheObject(_ locations: [CGPoint]) {
        
        //create a drawing layer
        let rect = CAShapeLayer()
        
        //get a handle on the relative rectangle points
        let leftPoint = locations[0].x < locations[1].x ? locations[0] : locations[1]
        let rightPoint = locations[0].x > locations[1].x ? locations[0] : locations[1]
        let lowerPoint = locations[0].y < locations[1].y ? locations[0] : locations[1]
        let upperPoint = locations[0].y < locations[1].y ? locations[1] : locations[0]
        
        //define some annotation attributes for drawing boundry and
        let centerX = (rightPoint.x + leftPoint.x) / 2
        let centerY = (upperPoint.y + lowerPoint.y) / 2
        let xDiff = rightPoint.x - leftPoint.x
        let yDiff = upperPoint.y - lowerPoint.y
        
        //set the coordinates for core data
        let coordinates = Coordinates(x: Int(centerX), y: Int(centerY), width: Int(xDiff), height: Int(yDiff))
        
        //set the shapelayer path to draw
        rect.path = UIBezierPath(rect: CGRect(x: -(xDiff / 2), y: -(yDiff / 2), width: xDiff, height: yDiff)).cgPath
        
        //reference the centerx and centery from above
        rect.position = CGPoint(x: centerX, y: centerY)
        
        //keep the fill color clear
        rect.fillColor = UIColor.clear.cgColor
        
        //set the stroke color to red
        rect.strokeColor = UIColor.red.cgColor
        
        //add the shapelayer to the imageview
        imageView.layer.addSublayer(rect)
        
        //clear the longpress location reticles
        opposingPoints.removeAll()
        
        //prompt to get an object label
        alertWithTF(coordinates: coordinates)
    }
    
    @objc func tap(sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: view)
        
        //use began sender state for gesture detection
        switch sender.state {
        case .began:
        
            showGestures(location, radius: 75, subLayer: reticleOuter)
            showGestures(location, radius: 3, subLayer: reticleInner)
            
            //handle points based on whether this is the first or second point
            if opposingPoints.count == 0 {
                opposingPoints.append(location)
            } else if opposingPoints.count == 1 {
                opposingPoints.append(location)
                reticleInner = CAShapeLayer()
                reticleOuter = CAShapeLayer()
                rectTheObject(opposingPoints)
                opposingPoints.removeAll()
            } else {
                opposingPoints.removeAll()
            }
        default:
            break
        }
    }
    
    func encodeAnnotation(coordinates: Coordinates) {
        let annotation = Annotation(label: objectName, coordinates: coordinates)
        let imageInfo = ImageInfo(image: imageName, annotations: [annotation])
        let objectAnnotationEncoder = JSONEncoder()
        do {
            _ = try objectAnnotationEncoder.encode(imageInfo)
        } catch {
            print("error encoding ")
        }
    }
    
    func alertWithTF(coordinates: Coordinates) {
        let alert = UIAlertController(title: "Object Name", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Object Name"
        }
        
        //add coordinates to the model and save, pop back to the last view controller
        alert.addAction (UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0]
            self.objectName = textField.text ?? ""
            self.encodeAnnotation(coordinates: coordinates)
            self.photo.label = self.objectName
            self.photo.name = String(self.photo.hash) + ".jpg"
            self.photo.x = Int16(coordinates.x)
            self.photo.y = Int16(coordinates.y)
            self.photo.width = Int16(coordinates.width)
            self.photo.height = Int16(coordinates.height)
            AnnotationStore.saveModel(trainingSet: self.trainingSet, photo: self.photo)
            try? DataController.shared.mainContext.save()
            self.navigationController?.popViewController(animated: true)
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//https://stackoverflow.com/questions/29137488/how-do-i-resize-the-uiimage-to-reduce-upload-image-size
//See reply by answered Mar 19 '15 at 6:00 Leo Dabus
extension UIImage {

    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
