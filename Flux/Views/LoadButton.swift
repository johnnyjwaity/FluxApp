//
//  LoadButton.swift
//  Flux
//
//  Created by Johnny Waity on 5/6/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class LoadButton: UIButton {
    
    let title:String
    let activityIndicator = UIActivityIndicatorView(style: .white)

    init(title:String) {
        self.title = title
        super.init(frame: CGRect.zero)
        setTitleColor(UIColor.white, for: .normal)
        setTitle(title, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        backgroundColor = UIColor.appBlue
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setEnabled(_ e:Bool) {
        if e {
            self.isEnabled = true
            self.backgroundColor = UIColor.appBlue
        }else{
            self.isEnabled = false
            self.backgroundColor = UIColor.lightGray
        }
    }
    
    func startRefresh(){
        setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func endRefresh(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
