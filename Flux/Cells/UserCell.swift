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
        profile.layer.cornerRadius = 22
        profile.layer.masksToBounds = true
        profile.clipsToBounds = true
        profile.backgroundColor = UIColor.black
        addSubview(profile)
        profile.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 44).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        let followButton = UIButton(type: .roundedRect)
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = UIColor.appBlue
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.layer.cornerRadius = 8
        followButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        addSubview(followButton)
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        followButton.addTarget(self, action: #selector(followClicked(_:)), for: .touchUpInside)
        if user == Network.username {
            followButton.isHidden = true
        }else if Network.profile?.following?.contains(user) ?? false {
            followButton.setTitle("Following", for: .normal)
            followButton.backgroundColor = UIColor.appGreen
        }else {
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = UIColor.appBlue
        }
        
        let userLabel = UILabel()
        userLabel.text = user
        userLabel.textColor = UIColor(named: "FG")
        userLabel.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    @objc
    func followClicked(_ sender:UIButton){
        if sender.titleLabel?.text == "Following" {
            print("unfollow")
            sender.setTitle("Follow", for: .normal)
            sender.backgroundColor = UIColor.appBlue
            Network.profile?.removeLocalFollowing(user)
            Network.request(url: "https://api.tryflux.app/unfollow", type: .post, paramters: ["account": user], auth: true)
        }else{
            print("Follow")
            sender.setTitle("Following", for: .normal)
            sender.backgroundColor = UIColor.appGreen
            Network.profile?.addLocalFollowing(user)
            Network.request(url: "https://api.tryflux.app/follow", type: .post, paramters: ["account": user], auth: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
