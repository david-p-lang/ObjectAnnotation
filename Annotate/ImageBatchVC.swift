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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(TrainingSetCell.self, forCellWithReuseIdentifier: Constants.Cell)
        self.navigationItem.title = "Select Image"
        searchPrompt()
    }
    
    fileprivate func searchPrompt() {
        let alert = UIAlertController(title: "Search Flickr", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search Tag"
        }
        let searchAction = UIAlertAction(title: "Search", style: .default, handler: {(action) in
            guard let text = alert.textFields?[0].text else {return}
            self.search(text)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(searchAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func search(_ term: String) {
        NetworkUtil.requestImageResources(tag: term, pageNumber: 0) { (flickrSearchResult, error) in
            guard error == nil, let flickrSearchResult = flickrSearchResult else {return}
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
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constants.placeholderKey), options: .progressiveLoad, context: nil)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let editorVC = EditorVC()
        editorVC.imageView = (collectionView.cellForItem(at: indexPath) as! TrainingSetCell).imageView
        editorVC.trainingSet = self.trainingSet
        navigationController?.pushViewController(editorVC, animated: true)
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

