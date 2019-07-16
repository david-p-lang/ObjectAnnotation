//
//  EditorVC.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import CoreData


struct ImageInfo : Codable {
    let image: String
    let annotations : [Annotation]
}

struct Annotation : Codable {
    let label: String
    let coordinates: Coordinates
}

struct Coordinates: Codable {
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

struct AnnotationSet: Codable {
    let fileName: String
    let annotatedImages: [AnnotatedImage]
}

struct AnnotatedImage : Codable {
    let name: String
    let label: String
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

extension AnnotatedImage {
    enum CodingKeys: String, CodingKey {
        case name
        case label
        case x
        case y
        case width
        case height
    }
}

struct AnnotationStore {
    
    static func saveArchive(annotatedImages: [AnnotatedImage], key: String) {
        print("save started", annotatedImages)
        var data = Data()
        do {
            data = try NSKeyedArchiver.archivedData(withRootObject: annotatedImages, requiringSecureCoding: false)
        } catch {
            print("error", error)
        }
        print("archive data to save", String(data: data, encoding: .utf8))
        let name = key
        UserDefaults.standard.set(data, forKey: key)
        print("saved archive data")
    }
    
    static func pullArchive(trainingSet: TrainingSet) {
        guard let name = trainingSet.name else {
            return
        }
        if let data = UserDefaults.standard.object(forKey: name) as? Data {
            print("pull archive data", String(data: data, encoding: .utf8))
            let setInfo = NSKeyedUnarchiver.unarchiveObject(with: data)
            print("setData", setInfo)
        }
        print("pull archive")
    }
    
    static func saveModel(trainingSet: TrainingSet, photo: Photo) {
        trainingSet.addToPhoto(photo)
        try? DataController.shared.mainContext.save()
    }
}


class EditorVC: UIViewController {
    
    var trainingSet:TrainingSet!
    var photo:Photo!
    var imageView: UIImageView!
    var objectSelectionTap = UILongPressGestureRecognizer()
    var imageName = ""
    var objectName = ""
    
    var opposingPoints = [CGPoint]()
    var reticleInner = CAShapeLayer()
    var reticleOuter = CAShapeLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentImage = imageView.image
        currentImage = currentImage!.resized(toWidth: self.view.frame.maxX)
        imageView.image = currentImage
        view.addSubview(imageView)
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: DataController.shared.mainContext)
        photo = Photo(entity: entity!, insertInto: DataController.shared.mainContext)
        photo.data = currentImage?.jpegData(compressionQuality: 1.0)
        
        objectSelectionTap = UILongPressGestureRecognizer(target: self, action: #selector(EditorVC.tap(sender:)))
        
        self.view.addGestureRecognizer(objectSelectionTap)
        
        configureContraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        let rect = CAShapeLayer()
        let leftPoint = locations[0].x < locations[1].x ? locations[0] : locations[1]
        let rightPoint = locations[0].x > locations[1].x ? locations[0] : locations[1]
        let lowerPoint = locations[0].y < locations[1].y ? locations[0] : locations[1]
        let upperPoint = locations[0].y < locations[1].y ? locations[1] : locations[0]
        
        let centerX = (rightPoint.x + leftPoint.x) / 2
        let centerY = (upperPoint.y + lowerPoint.y) / 2
        let xDiff = rightPoint.x - leftPoint.x
        let yDiff = upperPoint.y - lowerPoint.y
        
        //convert to pixel location
        
        let coordinates = Coordinates(x: Int(centerX), y: Int(centerY), width: Int(xDiff), height: Int(yDiff))
        rect.path = UIBezierPath(rect: CGRect(x: -(xDiff / 2), y: -(yDiff / 2), width: xDiff, height: yDiff)).cgPath
        rect.position = CGPoint(x: centerX, y: centerY)
        rect.fillColor = UIColor.clear.cgColor
        rect.strokeColor = UIColor.red.cgColor
        imageView.layer.addSublayer(rect)
        opposingPoints.removeAll()
        alertWithTF(coordinates: coordinates)
    }
    
    @objc func tap(sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: view)
        
        switch sender.state {
        case .began:
        
            showGestures(location, radius: 75, subLayer: reticleOuter)
            showGestures(location, radius: 3, subLayer: reticleInner)
            
            if opposingPoints.count == 0 {
                opposingPoints.append(location)
            } else if opposingPoints.count == 1 {
                opposingPoints.append(location)
                reticleInner = CAShapeLayer()
                reticleOuter = CAShapeLayer()
                rectTheObject(opposingPoints)
                //name and save annotation or discard
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
            let imageData = try objectAnnotationEncoder.encode(imageInfo)
            print("---", String(data: imageData, encoding: .utf8))
        } catch {
            print("error encoding ")
        }
    }
    
    func alertWithTF(coordinates: Coordinates) {
        let alert = UIAlertController(title: "Object Name", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Object Name"
        }
        alert.addAction (UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0]
            self.objectName = textField.text ?? ""
            self.encodeAnnotation(coordinates: coordinates)
            self.photo.label = self.objectName
            self.photo.x = Int16(coordinates.x)
            self.photo.y = Int16(coordinates.y)
            self.photo.width = Int16(coordinates.width)
            self.photo.height = Int16(coordinates.height)
            AnnotationStore.saveModel(trainingSet: self.trainingSet, photo: self.photo)
            try? DataController.shared.mainContext.save()
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
