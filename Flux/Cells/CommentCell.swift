//
//  CommentCell.swift
//  Flux
//
//  Created by Johnny Waity on 7/3/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    let profile = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
    let username:UIButton = UIButton()
    let timestamp = UILabel()
    let comment = UILabel()
    
    var delegate:CommentCellDelegate? = nil
    
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
        profile.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        username.setTitle("", for: .normal)
        username.translatesAutoresizingMaskIntoConstraints = false
        username.setTitleColor(UIColor.appBlue, for: .normal)
        username.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(username)
        username.topAnchor.constraint(equalTo: profile.topAnchor, constant: 0).isActive = true
        username.leftAnchor.constraint(equalTo: profile.rightAnchor, constant: 8).isActive = true
        username.addTarget(self, action: #selector(tappedUsername), for: .touchUpInside)
        
        timestamp.text = "11/19/01 10:45 AM"
        timestamp.translatesAutoresizingMaskIntoConstraints = false
        timestamp.textColor = UIColor.lightGray
        timestamp.font = UIFont.systemFont(ofSize: 16)
        timestamp.textAlignment = .right
        addSubview(timestamp)
        timestamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        timestamp.centerYAnchor.constraint(equalTo: username.centerYAnchor).isActive = true
        
        comment.text = "Hello World\nHello"
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.numberOfLines = 0
//        comment.isEditable = false
//        comment.isScrollEnabled = false
        comment.isUserInteractionEnabled = true
        comment.font = UIFont.systemFont(ofSize: 15)
        addSubview(comment)
        comment.leftAnchor.constraint(equalTo: username.leftAnchor).isActive = true
        comment.rightAnchor.constraint(equalTo: timestamp.rightAnchor).isActive = true
        comment.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 0).isActive = true
        comment.bottomAnchor.constraint(greaterThanOrEqualTo: profile.bottomAnchor, constant: 0).isActive = true
        comment.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedComment(_:)))
        comment.addGestureRecognizer(tapGesture)
    }
    
    func setCell(_ comment:Comment){
        let text = comment.comment.highlightUsers()
        text.addAttributes([.font: UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: comment.comment.count))
        self.comment.attributedText = text
        self.username.setTitle(comment.user, for: .normal)
        let date = Date.UTCDate(date: comment.timestamp)
        self.timestamp.text = Date.elapsedTime(date: date)
        self.profile.image = #imageLiteral(resourceName: "profilePlaceholder")
        Network.downloadImage(user: comment.user) { (image) in
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
    
    @objc
    func tappedComment(_ gesture:UITapGestureRecognizer) {
        let location = gesture.location(in: comment)
        let tapPosition = comment.indexOfAttributedTextCharacterAtPoint(point: location)
        let str = comment.attributedText?.string ?? ""
        let ranges = str.getUserRanges()
        for range in ranges {
            if range.contains(tapPosition) {
                var username = str[range]
                username.removeFirst()
                delegate?.openProfile(username)
                print("Clicked \(username)")
                break
            }
        }
    }
    
    @objc
    func tappedUsername() {
        let username = self.username.titleLabel?.text ?? ""
        delegate?.openProfile(username)
    }
    
}
protocol CommentCellDelegate {
    func openProfile(_ username:String)
}
