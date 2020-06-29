//
//  FluxTabBarController.swift
//  Flux
//
//  Created by Johnny Waity on 4/4/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class FluxTabBarController: UITabBarController {
    
    static var shared:FluxTabBarController!
    
    let homeController:HomeController
    let exploreController:ExploreController
    let searchController:SearchController
    let profileController:ProfileController
    
    let centerButton:UIView = {
        let button = UIView()
        button.backgroundColor = UIColor.appBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 35
        let plusSign = UIImageView(image: #imageLiteral(resourceName: "plus2").withRenderingMode(.alwaysTemplate))
        plusSign.tintColor = UIColor.white
        plusSign.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(plusSign)
        plusSign.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        plusSign.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        plusSign.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusSign.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    
    init() {
        homeController = HomeController()
        exploreController = ExploreController()
        searchController = SearchController()
        profileController = ProfileController()
        super.init(nibName: nil, bundle: nil)
        
        FluxTabBarController.shared = self
        
        homeController.title = "Home"
        homeController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "home").withRenderingMode(.alwaysTemplate), tag: 0)
        
        exploreController.title = "Explore"
        exploreController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "compass"), tag: 1)
        
        let placeHolder = UIViewController()
        placeHolder.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        placeHolder.tabBarItem.isEnabled = false
        
        searchController.title = "Search"
        searchController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), tag: 3)
        
        profileController.title = "Profile"
        profileController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "profile").withRenderingMode(.alwaysTemplate), tag: 4)
        
        self.viewControllers = [UINavigationController(rootViewController: homeController),UINavigationController(rootViewController: exploreController), placeHolder, UINavigationController(rootViewController: searchController), UINavigationController(rootViewController: profileController)]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createPost))
        centerButton.addGestureRecognizer(tapGesture)
        tabBar.addSubview(centerButton)
        centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        centerButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -5).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    
    @objc
    func createPost(){
        let postController = PostController()
        present(postController, animated: true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
