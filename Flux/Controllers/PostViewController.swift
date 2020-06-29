//
//  PostViewController.swift
//  Flux
//
//  Created by Johnny Waity on 3/27/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    let post:Post
    
    
    
    init(_ post:Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        
        let homeController = HomeController()
        homeController.allowsRefresh = false
        homeController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeController.view)
        homeController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        homeController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addChild(homeController)
        homeController.setPosts([post])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
