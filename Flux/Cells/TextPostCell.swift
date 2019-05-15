//
//  TextPostCell.swift
//  Flux
//
//  Created by Johnny Waity on 4/3/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class TextPostCell: PostCell {
    override func setup() {
        super.setup()
        let textBox = UITextView()
        textBox.translatesAutoresizingMaskIntoConstraints = false
        textBox.layer.cornerRadius = 8
        textBox.layer.borderWidth = 1
        textBox.layer.borderColor = UIColor.lightGray.cgColor
        textBox.isEditable = true
        textBox.isSelectable = true
        
        content.addSubview(textBox)
        textBox.topAnchor.constraint(equalTo: content.topAnchor, constant: 10).isActive = true
        textBox.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 10).isActive = true
        textBox.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -10).isActive = true
        textBox.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = UIColor.appBlue
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 25
        content.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: textBox.bottomAnchor, constant: 10).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
//    override func update(_ post: Post) {
//        super.update(post)
//    }
}
