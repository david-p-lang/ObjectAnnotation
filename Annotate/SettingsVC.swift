//
//  SettingsVC.swift
//  Annotate
//
//  Created by David Lang on 7/23/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    var perPagesStepper: UIStepper!
    var perPageLabel = UILabel()
    let labelString = "Images per page:"
    var perPageValue:Double = 12
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //setup the display that shows the number of image url info to be downloaded
        configurePerPageLabel()

        //setup the control for the per page value
        configurePerPagesStepper()
        
        //define the views constraints
        configureConstraints()
        
        //gather the userdefaults perpage value and set the label text
        updateLabelText()
    }
    
    func updateLabelText() {
        guard let settingsPerPageValue = defaults.value(forKey: Constants.perPageKey) as? Double else {return}
        perPageValue = settingsPerPageValue
        perPageLabel.text = labelString + " \(Int(perPageValue))"
    }
    
    fileprivate func configurePerPageLabel() {
        perPageLabel.text = labelString + " \(Int(perPageValue))"
        perPageLabel.backgroundColor = .white
        perPageLabel.textColor = .black
        view.addSubview(perPageLabel)
    }
    
    fileprivate func configurePerPagesStepper() {
        //initialize
        perPagesStepper = UIStepper()
        
        //increment by this value
        perPagesStepper.stepValue = 2
        
        //set the initial value
        perPagesStepper.value = perPageValue
        
        //set the range
        perPagesStepper.minimumValue = 12
        perPagesStepper.maximumValue = 24
        
        //press and hold increment
        perPagesStepper.autorepeat = true
        
        //the value min to max and max to min as respective range limits are reached
        perPagesStepper.wraps = true
        
        //set the selector
        perPagesStepper.addTarget(self, action: #selector(SettingsVC.stepPerPage(_:)), for: .valueChanged)
        view.addSubview(perPagesStepper)
    }
    
    @objc func stepPerPage(_ sender: UIStepper) {
        //Obtain the value of the stepper
        perPageValue = sender.value
        
        //Convert the stepper value to an Integer
        let perPageInteger = Int(perPageValue)
        
        //update the label text
        perPageLabel.text = labelString + " \(perPageInteger)"
        
        //update the user default
        defaults.set(perPageValue, forKey: Constants.perPageKey)
    }
    
    /// Set the views contraints. The views must be set to
    /// translatesAutoresizingMaskIntoConstraints = false
    func configureConstraints() {
        
        perPageLabel.translatesAutoresizingMaskIntoConstraints = false
        perPageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        perPageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true

        perPagesStepper.translatesAutoresizingMaskIntoConstraints = false
        perPagesStepper.topAnchor.constraint(equalTo: perPageLabel.bottomAnchor, constant: 20).isActive = true
        perPagesStepper.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        perPagesStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
}
