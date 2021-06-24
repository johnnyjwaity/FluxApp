//
//  Tab.swift
//  Flux
//
//  Created by Johnny Waity on 6/29/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class Tab: UIView {

    let icon:UIImage
    let selectedIcon:UIImage
    
    var isSelected:Bool = false
    
    let imageView:UIImageView = {
        let iv = UIImageView(image: nil)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor.appBlue
        return iv
    }()
    var imageWidth:NSLayoutConstraint!
    var imageHeight:NSLayoutConstraint!
    
    let padding:CGFloat = 6
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    init(icon:UIImage, selectedIcon:UIImage){
        self.icon = icon.withRenderingMode(.alwaysTemplate)
        self.selectedIcon = selectedIcon.withRenderingMode(.alwaysTemplate)
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.icon
        
        addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageWidth = imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -padding)
        imageWidth.isActive = true
        imageHeight = imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -padding)
        imageHeight.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select(){
        imageWidth.constant = -padding * 2
        imageHeight.constant = -padding * 2
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }) { (c) in
            self.imageView.image = self.selectedIcon
            self.imageWidth.constant = -self.padding
            self.imageHeight.constant = -self.padding
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    func unselect(){
        self.imageView.image = self.icon
    }
}
