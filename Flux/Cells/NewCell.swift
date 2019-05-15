//
//  NewCell.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class NewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let addImage = UIImageView(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), highlightedImage: nil)
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.contentMode = .scaleAspectFit
        addImage.tintColor = UIColor.appBlue
        addSubview(addImage)
        addImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        addImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
