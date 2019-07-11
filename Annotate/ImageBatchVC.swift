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

    fileprivate func searchPrompt() {
        let alert = UIAlertController(title: "Search Flickr", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search Tag"
        }
        let searchAction = UIAlertAction(title: "Search", style: .default, handler: {(action) in
            guard let text = alert.textFields?[0].text else {return}
            self.search(text)
            print("search for text", text)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(searchAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(TrainingSetCell.self, forCellWithReuseIdentifier: "Cell")
        
        self.navigationItem.title = "Select Image"
        

        searchPrompt()
    }

    func search(_ term: String) {

        
        NetworkUtil.requestImageResources(tag: term, pageNumber: 0) { (flickrSearchResult, error) in
            guard error == nil, let flickrSearchResult = flickrSearchResult else {
                print("RIRL error", error)
                return
            }
            self.flickrSearchResult = flickrSearchResult
            print(self.flickrSearchResult?.photos?.photo)
            self.setFlickrUrls()

        }
    }
    
    func setFlickrUrls() {
        guard let flickerUrls = flickrSearchResult?.photos?.photo else {return}
        for flickrUrl in flickerUrls {
            if let url = NetworkUtil.buildImageUrlString(flickrUrl) {
                self.imagerUrls.append(url)
                print("url :", url)
                print("urls cnt", imagerUrls.count)
               
            }
        }
         DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("imageurls cnt", imagerUrls.count)
        return imagerUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell, for: indexPath) as! TrainingSetCell
        let url = imagerUrls[indexPath.row]
        //cell.imageView.sd_imageIndicator
        cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: Constants.placeholderKey), options: .progressiveLoad, context: nil)
        // Configure the cell
    
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

