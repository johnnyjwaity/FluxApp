//
//  ConvoCell.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class ConvoCell: UITableViewCell {

    let profile = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
    let username:UILabel = UILabel()
    let preview = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profile.backgroundColor = UIColor.black
        profile.layer.cornerRadius = 30
        profile.layer.masksToBounds = true
        profile.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profile)
        profile.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profile.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profile.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        username.text = ""
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = UIColor.appBlue
        username.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(username)
        username.topAnchor.constraint(equalTo: profile.topAnchor, constant: 4).isActive = true
        username.leftAnchor.constraint(equalTo: profile.rightAnchor, constant: 8).isActive = true
        
        
        preview.text = ""
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.isUserInteractionEnabled = false
        preview.font = UIFont.systemFont(ofSize: 15)
        addSubview(preview)
        preview.leftAnchor.constraint(equalTo: username.leftAnchor).isActive = true
        preview.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        preview.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 0).isActive = true
        preview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func setCell(user:String, preview:String){
        self.preview.text = preview
        self.username.text = user
        self.profile.image = #imageLiteral(resourceName: "profilePlaceholder")
        Network.downloadImage(user: user) { (image) in
            if let i = image {
                self.profile.image = i
            }else{
                self.profile.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
