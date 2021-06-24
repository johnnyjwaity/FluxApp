//
//  FluxTabBarController.swift
//  Flux
//
//  Created by Johnny Waity on 4/4/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class FluxTabBarController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, TabBarDelegate {
    
    
    static var shared:FluxTabBarController!
    
    let pageController:UIPageViewController
    let tabBar:FluxTabBar
    var tabBarBottom:NSLayoutConstraint!
    
    let homeController:HomeController
    let exploreController:ExploreController
    let searchController:SearchController
    let profileController:ProfileController
    
    var currentController = 0
    let controllers:[UIViewController]
    
    var tabBarDisplayed:Bool = true
    
    
    init() {
        homeController = HomeController()
        exploreController = ExploreController()
        searchController = SearchController()
        profileController = ProfileController()
        controllers = [UINavigationController(rootViewController: homeController), UINavigationController(rootViewController: exploreController), UINavigationController(rootViewController: searchController), UINavigationController(rootViewController: profileController)]
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        tabBar = FluxTabBar()
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(named: "BG")
        
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
        
        tabBar.delegate = self
        view.addSubview(tabBar)
        tabBarBottom = tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tabBarBottom.isActive = true
        tabBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tabBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        addChild(pageController)
        pageController.delegate = self
        pageController.dataSource = self
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageController.view)
        pageController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageController.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: false, completion: nil)
        
        view.bringSubviewToFront(tabBar)

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let curController = pageViewController.viewControllers?[0] {
                let index = controllers.firstIndex(of: curController) ?? currentController
                currentController = index
                tabBar.changeTab(index)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let newIndex = currentController - 1
        if newIndex < 0 {
            return nil
        }
        return controllers[newIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let newIndex = currentController + 1
        if newIndex >= controllers.count {
            return nil
        }
        return controllers[newIndex]
    }
    
    
    @objc
    func createPost(){
        let postController = PostController()
        present(postController, animated: true)
    }
    
    func tabClicked(_ index:Int) {
        if index != currentController {
            pageController.setViewControllers([controllers[index]], direction: index > currentController ? .forward : .reverse, animated: true, completion: nil)
            currentController = index
        }else{
            if let navCont = controllers[index] as? UINavigationController {
                navCont.popToRootViewController(animated: true)
            }
        }
    }
    
    func toggleTabBar(shouldDisplay:Bool){
        if shouldDisplay != tabBarDisplayed {
            tabBarBottom.constant = shouldDisplay ? 0 : 50
            let newAlpha:CGFloat = shouldDisplay ? 1 : 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = newAlpha
            }) { (c) in
                self.pageController.dataSource = shouldDisplay ? self : nil
            }
            tabBarDisplayed = shouldDisplay
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
