//
//  FluxTabBar.swift
//  Flux
//
//  Created by Johnny Waity on 6/29/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class FluxTabBar: UIView {
    
    let homeTab = Tab(icon: #imageLiteral(resourceName: "house"), selectedIcon: #imageLiteral(resourceName: "house-selected"))
    let exploreTab = Tab(icon: #imageLiteral(resourceName: "explore"), selectedIcon: #imageLiteral(resourceName: "explore-selected"))
    let searchTab = Tab(icon: #imageLiteral(resourceName: "find"), selectedIcon: #imageLiteral(resourceName: "find"))
    let profileTab = Tab(icon: #imageLiteral(resourceName: "person"), selectedIcon: #imageLiteral(resourceName: "person-selected"))
    let tabs:[Tab]
    
    var currentTab = 0
    
    var delegate:TabBarDelegate? = nil
    
    let centerButton:UIView = {
        let button = UIView()
        button.backgroundColor = UIColor.appBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30
        let plusSign = UIImageView(image: #imageLiteral(resourceName: "plus2").withRenderingMode(.alwaysTemplate))
        plusSign.tintColor = UIColor.white
        plusSign.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(plusSign)
        plusSign.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        plusSign.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        plusSign.widthAnchor.constraint(equalToConstant: 35).isActive = true
        plusSign.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return button
    }()
    
    let divider:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let selectedIndicator:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.appBlue
        v.layer.cornerRadius = 2.5
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var indicatorX:NSLayoutConstraint? = nil

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 50)
    }
    
    init(){
        tabs = [homeTab, exploreTab, searchTab, profileTab]
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "BG")
        
        tabs[currentTab].select()
        
        addSubview(divider)
        divider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createPostClicked))
        centerButton.addGestureRecognizer(tapGesture)
        addSubview(centerButton)
        centerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        exploreTab.tag = 1
        addSubview(exploreTab)
        exploreTab.rightAnchor.constraint(equalTo: centerButton.leftAnchor, constant: -20).isActive = true
        exploreTab.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        exploreTab.widthAnchor.constraint(equalToConstant: 40).isActive = true
        exploreTab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        homeTab.tag = 0
        addSubview(homeTab)
        homeTab.rightAnchor.constraint(equalTo: exploreTab.leftAnchor, constant: -20).isActive = true
        homeTab.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        homeTab.widthAnchor.constraint(equalToConstant: 40).isActive = true
        homeTab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchTab.tag = 2
        addSubview(searchTab)
        searchTab.leftAnchor.constraint(equalTo: centerButton.rightAnchor, constant: 20).isActive = true
        searchTab.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        searchTab.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchTab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileTab.tag = 3
        addSubview(profileTab)
        profileTab.leftAnchor.constraint(equalTo: searchTab.rightAnchor, constant: 20).isActive = true
        profileTab.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileTab.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileTab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        for t in tabs {
            let tapGestureRecogizer = UITapGestureRecognizer(target: self, action: #selector(tabSelected(_:)))
            t.addGestureRecognizer(tapGestureRecogizer)
        }
        
        addSubview(selectedIndicator)
        selectedIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        selectedIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
        selectedIndicator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        indicatorX = selectedIndicator.centerXAnchor.constraint(equalTo: tabs[currentTab].centerXAnchor)
        indicatorX?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func createPostClicked(){
        delegate?.createPost()
    }
    
    @objc
    func tabSelected(_ gesture:UITapGestureRecognizer){
        if let index = gesture.view?.tag {
            changeTab(index)
            delegate?.tabClicked(index)
        }
    }
    
    func changeTab(_ index:Int){
        for t in tabs {
            t.unselect()
        }
        tabs[index].select()
        indicatorX?.isActive = false
        indicatorX = selectedIndicator.centerXAnchor.constraint(equalTo: tabs[index].centerXAnchor)
        indicatorX?.isActive = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }) { (c) in
            
        }
    }
    
}

protocol TabBarDelegate {
    func tabClicked(_ index:Int)
    func createPost()
}
