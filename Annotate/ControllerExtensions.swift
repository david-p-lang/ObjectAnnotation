//
//  UIViewController.swift
//  OnTheMap
//
//  Created by David Lang on 6/6/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlertMainQueue(_ error: Error) {
        DispatchQueue.main.async {
            let alertInfo = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
            alertInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertInfo, animated: true, completion: nil)
        }
    }
    
    func displayAlert(_ error: Error) {
        let alertInfo = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
        alertInfo.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertInfo, animated: true, completion: nil)
    }
    
}

//Modified from Reply: Samman Bikram Thapa
//https://stackoverflow.com/questions/43772984/how-to-show-a-message-when-collection-view-is-empty
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
