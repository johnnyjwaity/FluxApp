//
//  PostTypeCell.swift
//  Flux
//
//  Created by Johnny Waity on 4/10/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class PostTypeCell: UITableViewCell {
    
    let iconView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let title:UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.black
        return l
    }()
    
    let subtitleLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = UIColor.lightGray
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        contentView.addSubview(iconView)
        iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
        
        contentView.addSubview(title)
        title.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 8).isActive = true
        title.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
    func setCell(image:UIImage, title:String, subtitle:String){
        self.iconView.image = image
        self.title.text = title
        self.subtitleLabel.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
