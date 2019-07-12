//
//  UserCell.swift
//  Flux
//
//  Created by Johnny Waity on 5/9/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    let user:String

    init(_ user:String) {
        self.user = user
        super.init(style: .default, reuseIdentifier: nil)
        
        let profile = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
        profile.backgroundColor = UIColor.clear
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.contentMode = .scaleAspectFill
        profile.layer.cornerRadius = 25
        profile.layer.masksToBounds = true
        profile.clipsToBounds = true
        profile.backgroundColor = UIColor.black
        addSubview(profile)
        profile.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let followButton = UIButton(type: .roundedRect)
        followButton.setTitle("Following", for: .normal)
        followButton.tintColor = UIColor.appBlue
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.layer.cornerRadius = 8
        followButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        addSubview(followButton)
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        let userLabel = UILabel()
        userLabel.text = user
        userLabel.textColor = UIColor.appBlue
        userLabel.font = UIFont.boldSystemFont(ofSize: 25)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.adjustsFontSizeToFitWidth = true
        addSubview(userLabel)
        userLabel.leftAnchor.constraint(equalTo: profile.rightAnchor, constant: 15).isActive = true
        userLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userLabel.rightAnchor.constraint(equalTo: followButton.leftAnchor, constant: -10).isActive = true
        
        Network.downloadImage(user: user) { (image) in
            if let i = image {
                profile.image = i
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
