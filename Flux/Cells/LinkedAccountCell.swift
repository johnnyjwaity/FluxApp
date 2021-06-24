//
//  LinkedAccountCell.swift
//  Flux
//
//  Created by Johnny Waity on 7/1/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class LinkedAccountCell: UITableViewCell {
    
    var type:LinkedAccountType!
    
    let icon:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        return iv
    }()
    
    let label:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let linkSwitch:UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(icon)
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(label)
        label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(linkSwitch)
        linkSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        linkSwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        linkSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(type:LinkedAccountType){
        self.type = type
        if type == .Snapchat {
            icon.image = #imageLiteral(resourceName: "snapchat").withRenderingMode(.alwaysTemplate)
            label.text = "Snapchat"
            linkSwitch.isOn = LinkedAccounts.shared.isLinked(.Snapchat)
        }else if type == .Twitter {
            icon.image = #imageLiteral(resourceName: "twiiter").withRenderingMode(.alwaysTemplate)
            label.text = "Twitter"
            linkSwitch.isOn = LinkedAccounts.shared.isLinked(.Twitter)
        }
    }
    
    @objc
    func switchChange(){
        if linkSwitch.isOn {
            LinkedAccounts.shared.linkAccount(self.type) { (linked) in
                print("Linked \(linked)")
                if !linked {
                    self.linkSwitch.setOn(false, animated: true)
                }
            }
        }else{
            LinkedAccounts.shared.unlinkAccount(self.type) { (unlinked) in
                print("Unlinked \(unlinked)")
                if !unlinked {
                    self.linkSwitch.setOn(true, animated: true)
                }
            }
        }
    }
    
}
