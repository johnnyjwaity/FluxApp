//
//  QuestionCell.swift
//  Flux
//
//  Created by Johnny Waity on 3/30/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    let questionLabel:UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.lineBreakMode = .byTruncatingTail
        return l
    }()
    
    let arrowImage:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor.lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let divider:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(named: "GR")
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "BG")
        contentView.addSubview(arrowImage)
        arrowImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(questionLabel)
        questionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: arrowImage.leftAnchor, constant: -8).isActive = true
        
        contentView.addSubview(divider)
        divider.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
