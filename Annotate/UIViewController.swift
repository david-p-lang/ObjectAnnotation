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
