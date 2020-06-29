//
//  IconTextField.swift
//  Flux
//
//  Created by Johnny Waity on 5/6/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class IconTextField: UIView {
    
    let iconGlyph:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.lightGray
        return iv
    }()
    
    let textField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.font = UIFont.systemFont(ofSize: 20)
        return tf
    }()
    
    let bottomBorder:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    init(icon:UIImage, field:String, secure:Bool=false){
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        
        iconGlyph.image = icon.withRenderingMode(.alwaysTemplate)
        addSubview(iconGlyph)
        iconGlyph.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconGlyph.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        iconGlyph.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconGlyph.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textField.isSecureTextEntry = secure
        textField.placeholder = field
        addSubview(textField)
        textField.leftAnchor.constraint(equalTo: iconGlyph.rightAnchor, constant: 8).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(bottomBorder)
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: UIScreen.main.bounds.width * 0.9, height: 40)
    }

}
