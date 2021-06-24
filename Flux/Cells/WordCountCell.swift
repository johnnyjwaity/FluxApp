//
//  WordCountCell.swift
//  Flux
//
//  Created by Johnny Waity on 6/30/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class WordCountCell: UITableViewCell, UITextViewDelegate {
    
    let placeholder:UILabel = {
        let l = UILabel()
        l.text = "Bio"
        l.textColor = UIColor(named: "GR")
        l.font = UIFont.systemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let textField:UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textContainerInset.top = 12
        tv.textContainerInset.left = 8
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let wordCounter:UILabel = {
        let l = UILabel()
        l.text = "200"
        l.textColor = UIColor(named: "FG")
        l.font = UIFont.systemFont(ofSize: 18)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(wordCounter)
        wordCounter.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        wordCounter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        textField.delegate = self
        addSubview(textField)
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: wordCounter.topAnchor, constant: -8).isActive = true
        textField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        textField.addSubview(placeholder)
        placeholder.topAnchor.constraint(equalTo: textField.topAnchor, constant: 12).isActive = true
        placeholder.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeholder.isHidden = false
        }else{
            placeholder.isHidden = true
        }
        let length = textView.text.count
        wordCounter.text = "\(200 - length)"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("RUn")
        if text.contains("\n") {
            return false
        }
        let newStrCount = textView.text.count + (text.count - range.length)
        if newStrCount > 200 {
            return false
        }
//        wordCounter.text = "\(200 - newStrCount)"
        return true
    }
    
}
