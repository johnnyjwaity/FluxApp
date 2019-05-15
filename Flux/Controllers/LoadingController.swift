//
//  LoadingController.swift
//  Flux
//
//  Created by Johnny Waity on 4/23/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class LoadingController: UIViewController {
    
    let message:String
    
    init(_ message:String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        
        let box = UIView()
        box.backgroundColor = UIColor.white
        box.translatesAutoresizingMaskIntoConstraints = false
        box.layer.masksToBounds = true
        box.layer.cornerRadius = 15
        view.addSubview(box)
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        box.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        box.heightAnchor.constraint(equalToConstant: 200).isActive = true
        box.widthAnchor.constraint(equalToConstant: 300).isActive = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appBlue.cgColor, UIColor.appGreen.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        gradientLayer.masksToBounds = true
        box.layer.addSublayer(gradientLayer)
        
        let whiteLayer = CALayer()
        whiteLayer.backgroundColor = UIColor.white.cgColor
        whiteLayer.cornerRadius = 14
        whiteLayer.frame = CGRect(x: 1, y: 1, width: 298, height: 198)
        whiteLayer.masksToBounds = true
        box.layer.addSublayer(whiteLayer)
        
        let label = UILabel()
        label.text = message
        label.font = UIFont(name: "Amandita", size: 35)
        label.textColor = UIColor.appBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        box.addSubview(label)
        label.topAnchor.constraint(equalTo: box.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: box.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: box.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: box.centerYAnchor).isActive = true
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.tintColor = UIColor.appGreen
        activityIndicator.color = UIColor.appGreen
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: box.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: box.centerYAnchor, constant: 35).isActive = true
        activityIndicator.startAnimating()
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
