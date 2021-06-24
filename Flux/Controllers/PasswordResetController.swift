//
//  PasswordResetController.swift
//  Flux
//
//  Created by Johnny Waity on 7/31/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class PasswordResetController: UIViewController {

    let pageViewController:UIPageViewController = {
        let p = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        p.view.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    let topBar:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let cancelButton:UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    
    let pageDotStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.spacing = 5
        return s
    }()
    
    let otherButton:UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("", for:  .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    
    let controllers:[UIViewController]
    var currentController = 0
    var phoneCountryCode:CountryCode? = nil
    var phoneNumber:String? = nil
    
    init(_ presenter:LoginController){
        controllers = [UIViewController()]
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
        view.backgroundColor = UIColor(named: "BG")
        
        view.addSubview(topBar)
        topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        topBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        topBar.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: topBar.leftAnchor, constant: 8).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        
        topBar.addSubview(pageDotStack)
        pageDotStack.centerXAnchor.constraint(equalTo: topBar.centerXAnchor).isActive = true
        pageDotStack.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        
        
        otherButton.addTarget(self, action: #selector(rightButtonClicked), for: .touchUpInside)
        topBar.addSubview(otherButton)
        otherButton.rightAnchor.constraint(equalTo: topBar.rightAnchor, constant: -8).isActive = true
        otherButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor).isActive = true
        
        addChild(pageViewController)
        let pageView:UIView = pageViewController.view
        view.addSubview(pageView)
        pageView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        pageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        changePage(increment: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePage(increment:Bool = true, amount:Int=1, reverse:Bool = false) {
        if increment {
            if reverse {
                currentController -= 1
            }else{
                currentController += amount
            }
        }
        for v in pageDotStack.arrangedSubviews {
            pageDotStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        for i in 0..<controllers.count {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
            dot.backgroundColor = i == currentController ? UIColor.appBlue : UIColor(named: "GR")
            dot.layer.cornerRadius = 5
            pageDotStack.addArrangedSubview(dot)
        }
        pageViewController.setViewControllers([controllers[currentController]], direction: reverse ? .reverse : .forward, animated: true, completion: { (c:Bool) in
            
        })
    }
    
    @objc
    func closeView(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func rightButtonClicked(){
        
    }
    func next(){
        changePage()
    }
    
    func back() {
        changePage(reverse:true)
    }
}

