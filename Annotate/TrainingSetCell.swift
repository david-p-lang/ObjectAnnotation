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
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cyan
        let frame = self.contentView.frame
        stack = UIStackView(frame: frame)
        stack.axis = .vertical
        
        imageView.backgroundColor = .clear
        nameLabel.backgroundColor = .yellow
        stack.backgroundColor = .orange
        
        stack.distribution = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        //stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(imageView)
        addSubview(stack)

        
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        stack.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: bounds.height - 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
