//
//  PostCell.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    var questionLabel:UILabel!
    var profile:UIImageView!
    var content:UIView!
    var usernameButton:UIButton!
    var post:Post!
    
    let gradientLayer = CAGradientLayer()
    var cell:UICollectionViewCell!
    var totalPostContent:UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cell = self
        setup()
    }
    func setup(){
        layer.cornerRadius = 10
        backgroundColor = UIColor.white
        
        gradientLayer.colors = [UIColor.appBlue.cgColor, UIColor.appGreen.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.masksToBounds = true
        
//        gradientLayer.cornerRadius = 8
        layer.addSublayer(gradientLayer)
        clipsToBounds = true
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 8
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        totalPostContent = contentView
        
        profile = UIImageView(image: nil)
        profile.backgroundColor = UIColor.clear
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.contentMode = .scaleAspectFill
        profile.layer.cornerRadius = 20
        profile.layer.masksToBounds = true
        profile.clipsToBounds = true
        profile.backgroundColor = UIColor.black
        contentView.addSubview(profile)
        profile.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        profile.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        profile.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profile.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameButton = UIButton(type: .system)
        usernameButton.setTitle("", for: .normal)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.setTitleColor(UIColor.appBlue, for: .normal)
        usernameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        usernameButton.contentHorizontalAlignment = .left
        contentView.addSubview(usernameButton)
        usernameButton.leftAnchor.constraint(equalTo: profile.rightAnchor, constant: 10).isActive = true
        usernameButton.topAnchor.constraint(equalTo: profile.topAnchor).isActive = true
        usernameButton.bottomAnchor.constraint(equalTo: profile.bottomAnchor).isActive = true
        usernameButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor.appBlue
        contentView.addSubview(divider)
        divider.topAnchor.constraint(equalTo: profile.bottomAnchor, constant: 5).isActive = true
        divider.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        questionLabel = UILabel()
        questionLabel.numberOfLines = 2
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        questionLabel.textColor = UIColor.appBlue
        questionLabel.textAlignment = .center
        contentView.addSubview(questionLabel)
        questionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        
        let subContent = UIView()
        subContent.backgroundColor = UIColor.clear
        subContent.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subContent)
        subContent.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10).isActive = true
        subContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        subContent.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        subContent.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        self.content = subContent
        
        addObserver(self, forKeyPath: #keyPath(UIView.bounds), options: .new, context: nil)
        
        
        
    }
    
    func setPost(_ post:Post, collectionView:UICollectionView){
        if post.fetched {
            self.update(post)
//            (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).invalidateLayout()
        }else{
            let coverView = UIView()
            coverView.backgroundColor = UIColor.white
            coverView.translatesAutoresizingMaskIntoConstraints = false
            coverView.layer.cornerRadius = totalPostContent.layer.cornerRadius
            totalPostContent.addSubview(coverView)
            coverView.topAnchor.constraint(equalTo: totalPostContent.topAnchor).isActive = true
            coverView.bottomAnchor.constraint(equalTo: totalPostContent.bottomAnchor).isActive = true
            coverView.leftAnchor.constraint(equalTo: totalPostContent.leftAnchor).isActive = true
            coverView.rightAnchor.constraint(equalTo: totalPostContent.rightAnchor).isActive = true
            post.fetch {
                self.update(post)
                UIView.animate(withDuration: 0.7, animations: {
                    coverView.alpha = 0
                }, completion: { (completed) in
                    coverView.removeFromSuperview()
                })
                (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).invalidateLayout()
            }
        }
    }
    
    func update(_ post:Post){
        profile.image = post.profilePicture
        questionLabel.text = post.question
        self.post = post
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: CGFloat(112 + round((Double(post.choices!.count) / 2)) * 70))
        usernameButton.setTitle(post.user ?? "", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let objectView = object as? UIView,
            objectView === self,
            keyPath == #keyPath(UIView.bounds) {
            gradientLayer.frame = objectView.bounds
        }
    }
}
