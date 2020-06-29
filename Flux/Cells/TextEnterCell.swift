//
//  TextEnterCell.swift
//  Flux
//
//  Created by Johnny Waity on 5/4/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class TextEnterCell: UITableViewCell, UITextViewDelegate {
    
    let placeholderLabel:UILabel = {
        let l = UILabel()
        l.text = "Add Comment..."
        l.textColor = UIColor.lightGray
        l.isUserInteractionEnabled = false
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = true
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textView.delegate = self
        contentView.addSubview(textView)
        textView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 4).isActive = true
        
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 0 {
            placeholderLabel.isHidden = false
        }else{
            placeholderLabel.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getValue() -> String {
        return textView.text ?? ""
    }
}
