//
//  SelectConvoCell.swift
//  Flux
//
//  Created by Johnny Waity on 7/12/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class SelectConvoCell: UITableViewCell {
    
    let profileView = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
    let recipientLabel = UILabel()
    let selectView = UIView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileView.layer.masksToBounds = true
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.layer.cornerRadius = 20
        contentView.addSubview(profileView)
        profileView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        profileView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 40).isActive = true

        recipientLabel.text = "Test"
        recipientLabel.textColor = UIColor.black
        recipientLabel.translatesAutoresizingMaskIntoConstraints = false
        recipientLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(recipientLabel)
        recipientLabel.leftAnchor.constraint(equalTo: profileView.rightAnchor, constant: 8).isActive = true
        recipientLabel.centerYAnchor.constraint(equalTo: profileView.centerYAnchor).isActive = true
        
        selectView.translatesAutoresizingMaskIntoConstraints = false
        selectView.layer.cornerRadius = 15
        selectView.layer.borderWidth = 0.5
        selectView.layer.borderColor = UIColor.lightGray.cgColor
        selectView.backgroundColor = UIColor.white
        contentView.addSubview(selectView)
        selectView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13).isActive = true
        selectView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        selectView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        selectView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let checkMark = UIImageView(image: #imageLiteral(resourceName: "check").withRenderingMode(.alwaysTemplate))
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        checkMark.tintColor = UIColor.white
        selectView.addSubview(checkMark)
        checkMark.centerYAnchor.constraint(equalTo: selectView.centerYAnchor).isActive = true
        checkMark.centerXAnchor.constraint(equalTo: selectView.centerXAnchor).isActive = true
        checkMark.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkMark.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selectView.backgroundColor == UIColor.white {
//            selectView.backgroundColor = UIColor.appBlue
//        }else{
//            selectView.backgroundColor = UIColor.white
//        }
//        // Configure the view for the selected state
    }
    
    func setName(_ name:String){
        recipientLabel.text = name
        profileView.image = #imageLiteral(resourceName: "profilePlaceholder")
        Network.downloadImage(user: name) { (image) in
            if let i = image {
                self.profileView.image = i
            }
        }
    }
    
    func toggleCheck(){
        if selectView.backgroundColor == UIColor.white {
            selectView.backgroundColor = UIColor.appBlue
        }else{
            selectView.backgroundColor = UIColor.white
        }
    }

}
