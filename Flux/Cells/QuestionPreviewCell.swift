//
//  QuestionPreviewCell.swift
//  Flux
//
//  Created by Johnny Waity on 5/3/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class QuestionPreviewCell: UITableViewCell {
    
    let typeImage:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "rating-post"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.text = "Hello how are you doing today i really like you"
        tv.isSelectable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(typeImage)
        typeImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12.5).isActive = true
        typeImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        typeImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        typeImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(textView)
        textView.leftAnchor.constraint(equalTo: typeImage.rightAnchor, constant: 12.5).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12.5).isActive = true
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.5).isActive = true
    }
    
    func setCell(postType: PostType, question:String) {
        switch postType {
        case .Option:
            typeImage.image = #imageLiteral(resourceName: "option-post")
            break
        case .Rating:
            typeImage.image = #imageLiteral(resourceName: "rating-post")
            break
        case .YesNo:
            typeImage.image = #imageLiteral(resourceName: "yes-no-post")
            break
        case .Emoji:
            typeImage.image = #imageLiteral(resourceName: "emoji-post")
            break
        }
        textView.text = question
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
