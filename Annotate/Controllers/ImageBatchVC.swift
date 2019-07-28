//
//  ImageBatchVCCollectionViewController.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import Kingfisher


class ImageBatchVC: UICollectionViewController {
    
    var trainingSet:TrainingSet!
    var flickrSearchResult: FlickrSearchResult!
    var imagerUrls = [URL]()
    var pages = 1
    var tag = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        collectionView.backgroundColor = .white
        self.collectionView!.register(TrainingSetCell.self, forCellWithReuseIdentifier: Constants.Cell)
        configureNavigation()
        searchPrompt()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    fileprivate func configureNavigation() {
        self.navigationItem.title = "Select Image"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ImageBatchVC.refresh))
        self.navigationItem.rightBarButtonItems = [refreshButton]
    }
    
    func deletePhotos() {
        flickrSearchResult = nil
        imagerUrls.removeAll()
    }
    
    @objc func refresh() {
        deletePhotos()
        pages += 1
        search(tag, pageNumber: pages)
            NetworkUtil.requestImageResources(
                tag: self.tag,
                pageNumber: pages
            ) { (flickrSearchResult, error) in
                if let error = error {
                    self.displayAlert(error)
                }
                guard let flickrSearchResult = flickrSearchResult else {return}
                self.flickrSearchResult = flickrSearchResult
         }
    }

    fileprivate func searchPrompt() {
        let alert = UIAlertController(title: "Search Flickr", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search Tag"
        }
        let searchAction = UIAlertAction(title: "Search", style: .default, handler: {(action) in
            guard let text = alert.textFields?[0].text else {return}
            self.tag = text
            self.search(text, pageNumber: self.pages)
        })
        
        alert.addAction(UIAlertAction(title: "Media", style: .default, handler: { (alertAction) in
            let vC = MediaVC(nibName: nil, bundle: nil)
            self.navigationController?.pushViewController(vC, animated: true)
        }))
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(searchAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func search(_ term: String, pageNumber: Int) {
        NetworkUtil.requestImageResources(tag: term, pageNumber: pageNumber) { (flickrSearchResult, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.displayAlert(error)
                }
                return
            }
            guard let flickrSearchResult = flickrSearchResult else {
                DispatchQueue.main.async {
                    self.displayAlert(ConnectionError.connectionFailure)
                }
                return
            }
            self.flickrSearchResult = flickrSearchResult
            self.setFlickrUrls()
        }
    }
    
    func setFlickrUrls() {
        guard let flickerUrls = flickrSearchResult?.photos?.photo else {return}
        for flickrUrl in flickerUrls {
            if let url = NetworkUtil.buildImageUrlString(flickrUrl) {
                self.imagerUrls.append(url)
            }
        }
         DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagerUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell, for: indexPath) as! TrainingSetCell
        let url = imagerUrls[indexPath.row]
        cell.batchContraints()
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: url,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .fromMemoryCacheOrRefresh
            ])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editorVC = EditorVC()
        editorVC.passedImage = (collectionView.cellForItem(at: indexPath) as? TrainingSetCell)?.imageView.image
        editorVC.trainingSet = self.trainingSet
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

