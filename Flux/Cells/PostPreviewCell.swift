//
//  PostPreviewCell.swift
//  Flux
//
//  Created by Johnny Waity on 3/27/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class PostPreviewCell: UICollectionViewCell {
    
    var post:Post? = nil
    var postMessage:PostMessage? = nil
    var delegate:PostPreviewDelegate? = nil
    
    let iconView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = #imageLiteral(resourceName: "profilePlaceholder")
        return imageView
    }()
    
    let container:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "GR")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 40
        return v
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profilePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    
    let questionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "FG")
        label.lineBreakMode = .byTruncatingTail
        label.text = "This is my question. How Are we doing today"
        return label
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.appBlue
        label.lineBreakMode = .byTruncatingTail
        label.text = "@Johnnyjw"
        return label
    }()
    
    let hintLabel:UILabel = {
        let l = UILabel()
        l.text = "Tap to answer"
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let errorOverlay:UILabel = {
        let overlay = UILabel()
        overlay.text = "This Post Has Been Removed"
        overlay.textColor = UIColor.lightGray
        overlay.font = UIFont.systemFont(ofSize: 20)
        overlay.textAlignment = .center
        overlay.translatesAutoresizingMaskIntoConstraints = false
        return overlay
    }()
    
    var otherContraints:[NSLayoutConstraint] = []
    var meConstraints:[NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
        let iconLeft = iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8)
        let iconRight = iconView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        otherContraints.append(iconLeft)
        meConstraints.append(iconRight)
        
        contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        let containerLeftOther = container.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 8)
        let containerRightOther = container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        otherContraints.append(containerLeftOther)
        otherContraints.append(containerRightOther)
        
        let containerLeftMe = container.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
        let containerRightMe = container.rightAnchor.constraint(equalTo: iconView.leftAnchor, constant: -8)
        meConstraints.append(containerLeftMe)
        meConstraints.append(containerRightMe)
        
        NSLayoutConstraint.activate(otherContraints)
        
        
        container.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        container.addSubview(questionLabel)
        questionLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -8).isActive = true
        
        container.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 1).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        container.addSubview(hintLabel)
        hintLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        hintLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        container.addSubview(errorOverlay)
        errorOverlay.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        errorOverlay.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedPost)))
    }
    
    func setPost(message: PostMessage, post:Post) {
        self.postMessage = message
        self.post = post
        if message.style == .mine {
            NSLayoutConstraint.deactivate(otherContraints)
            NSLayoutConstraint.activate(meConstraints)
        }else{
            NSLayoutConstraint.deactivate(meConstraints)
            NSLayoutConstraint.activate(otherContraints)
        }
        Network.downloadImage(user: message.user) { (image) in
            self.iconView.image = image ?? #imageLiteral(resourceName: "profilePlaceholder")
        }
        update()
    }
    func update(){
        if let post = post {
            if post.fetched {
                if post.question == nil {
                    errorOverlay.isHidden = false
                    profileImageView.isHidden = true
                    questionLabel.isHidden = true
                    usernameLabel.isHidden = true
                    hintLabel.isHidden = true
                }else{
                    profileImageView.image = post.profilePicture ?? #imageLiteral(resourceName: "profilePlaceholder")
                    questionLabel.text = post.question ?? ""
                    usernameLabel.text = "@" + (post.user ?? "")
                    errorOverlay.isHidden = true
                    profileImageView.isHidden = false
                    questionLabel.isHidden = false
                    usernameLabel.isHidden = false
                    hintLabel.isHidden = false
                }
            }else{
                profileImageView.image = #imageLiteral(resourceName: "profilePlaceholder")
                questionLabel.text = ""
                usernameLabel.text = ""
                errorOverlay.isHidden = true
                profileImageView.isHidden = false
                questionLabel.isHidden = false
                usernameLabel.isHidden = false
                hintLabel.isHidden = false
            }
        }
    }
    
    @objc
    func tappedPost(){
        if errorOverlay.isHidden {
            if let p = post {
                delegate?.openPost(p)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PostPreviewDelegate {
    func openPost(_ post:Post)
}
