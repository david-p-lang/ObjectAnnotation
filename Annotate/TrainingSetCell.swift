//
//  TrainingSetCell.swift
//  Annotate
//
//  Created by David Lang on 7/7/19.
//  Copyright © 2019 David Lang. All rights reserved.
//

import UIKit

class TrainingSetCell: UICollectionViewCell {
    
    var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    var stack:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.backgroundColor = .black
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center

        //stack configuration
        let frame = self.contentView.frame
        stack = UIStackView(frame: frame)
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        stack.backgroundColor = .black
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        //stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(imageView)
        addSubview(stack)

        //Set the constraints for the cell contents
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        stack.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
          
    }
    
    func batchContraints(){
        imageView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
    }
    
    func trainingConstraints() {
        imageView.heightAnchor.constraint(equalToConstant: self.bounds.height - 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
