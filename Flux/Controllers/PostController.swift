//
//  PostController.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class PostController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Amandita", size: 28)!]
        navigationController?.navigationBar.tintColor = UIColor.appBlue
        navigationController?.navigationBar.barTintColor = UIColor.appBlue
        
        let createPostLabel = UILabel()
        createPostLabel.font = UIFont(name: "Amandita", size: 60)
        createPostLabel.text = "Create Post"
        createPostLabel.textColor = UIColor.appBlue
        createPostLabel.translatesAutoresizingMaskIntoConstraints = false
        createPostLabel.adjustsFontSizeToFitWidth = true
        createPostLabel.textAlignment = .center
        view.addSubview(createPostLabel)
        createPostLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createPostLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        createPostLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        createPostLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        // Do any additional setup after loading the view.
        
        
        
        
        let optionButton = UIButton(type: .system)
        optionButton.setTitle("Create", for: .normal)
        optionButton.backgroundColor = UIColor.appGreen
        optionButton.setTitleColor(UIColor.white, for: .normal)
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.layer.cornerRadius = 25
        optionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        optionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        optionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(optionButton)
        optionButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 15).isActive = true
        optionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        optionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        optionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        optionButton.addTarget(self, action: #selector(createOptionPost), for: .touchUpInside)
        
        let writtenButton = UIButton(type: .system)
        writtenButton.setTitle("Text", for: .normal)
        writtenButton.backgroundColor = UIColor.appGreen
        writtenButton.setTitleColor(UIColor.white, for: .normal)
        writtenButton.translatesAutoresizingMaskIntoConstraints = false
        writtenButton.layer.cornerRadius = 25
        writtenButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        writtenButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        writtenButton.titleLabel?.adjustsFontSizeToFitWidth = true
        writtenButton.alpha = 0
        view.addSubview(writtenButton)
        writtenButton.topAnchor.constraint(equalTo: optionButton.bottomAnchor, constant: 10).isActive = true
        writtenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        writtenButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        writtenButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc
    func createOptionPost(){
        navigationController?.pushViewController(CreateOptionPostController(), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
