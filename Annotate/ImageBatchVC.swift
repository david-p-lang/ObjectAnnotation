//
//  ImageBatchVCCollectionViewController.swift
//  Annotate
//
//  Created by David Lang on 7/9/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit
import SDWebImage


class ImageBatchVC: UICollectionViewController {
    
    var trainingSet:TrainingSet!
    var flickrSearchResult: FlickrSearchResult!
    var imagerUrls = [URL]()
    var pages = 1
    var tag = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(TrainingSetCell.self, forCellWithReuseIdentifier: Constants.Cell)
        self.navigationItem.title = "Select Image"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ImageBatchVC.refresh))
        self.navigationItem.rightBarButtonItems = [refreshButton]
        searchPrompt()
    }
    
    func deletePhotos() {
        flickrSearchResult = nil
        imagerUrls.removeAll()
        print("clear")
    }
    @objc func refresh() {
        deletePhotos()
        search(tag, pageNumber: getRandomResultPage())
        collectionView.reloadData()
    }
    
    func getRandomResultPage() -> Int {
        if pages > 99 {
            pages = 99
        }
        return Int.random(in: 1...pages)
    }
    
    fileprivate func searchPrompt() {
        let alert = UIAlertController(title: "Search Flickr", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search Tag"
        }
        let searchAction = UIAlertAction(title: "Search", style: .default, handler: {(action) in
            guard let text = alert.textFields?[0].text else {return}
            self.tag = text
            self.search(text, pageNumber: 1)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(searchAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func search(_ term: String, pageNumber: Int) {
        NetworkUtil.requestImageResources(tag: term, pageNumber: pageNumber) { (flickrSearchResult, error) in
            print("-",pageNumber)
            guard error == nil, let flickrSearchResult = flickrSearchResult else {return}
            self.flickrSearchResult = flickrSearchResult
            self.pages = self.flickrSearchResult?.photos?.pages ?? 1
            print("--", self.pages)
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
            print("reload")
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
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constants.placeholderKey), options: .refreshCached, context: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editorVC = EditorVC()
        editorVC.imageView = (collectionView.cellForItem(at: indexPath) as! TrainingSetCell).imageView
        editorVC.trainingSet = self.trainingSet
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
}

