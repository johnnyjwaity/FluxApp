//
//  LoginController.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginController: UIViewController, UITextFieldDelegate {
    
    let titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Flux"
        titleLabel.textColor = UIColor.appBlue
        titleLabel.font = UIFont(name: "Amandita", size: 75)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let usernameField = IconTextField(icon: #imageLiteral(resourceName: "profile"), field: "Username")
    let passwordField = IconTextField(icon: #imageLiteral(resourceName: "lock"), field: "Password", secure: true)
    
    let forgotPasswordButton:UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Forgot Password?", for: .normal)
        b.setTitleColor(UIColor.lightGray, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let button:LoadButton = LoadButton(title: "Login")
    
    let signupButton:UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        var attributedString = NSMutableAttributedString(string: "Don't have an account? Sign up!")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 22))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appBlue, range: NSRange(location: 23, length: 8))
        b.setAttributedTitle(attributedString, for: .normal)
        
        return b
    }()
    
    let privacyButton:UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        let titleString = NSMutableAttributedString(string: "Privacy Policy")
        titleString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: 14))
        titleString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 14))
        b.setAttributedTitle(titleString, for: .normal)
        return b
    }()
    
    let errorBox = UILabel()
    var errorBottom:NSLayoutConstraint!
    
    init(){
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BG")
        view.clipsToBounds = true
        
        errorBox.text = "Test Error"
        errorBox.backgroundColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 1)
        errorBox.textColor = UIColor.white
        errorBox.font = UIFont.systemFont(ofSize: 18)
        errorBox.adjustsFontSizeToFitWidth = true
        errorBox.translatesAutoresizingMaskIntoConstraints = false
        errorBox.textAlignment = .center
        errorBox.layer.masksToBounds = true
        errorBox.layer.cornerRadius = 16
        view.addSubview(errorBox)
        errorBottom = errorBox.bottomAnchor.constraint(equalTo: view.topAnchor)
        errorBottom.isActive = true
        errorBox.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        errorBox.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        errorBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        view.addSubview(usernameField)
        usernameField.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordClicked), for: .touchUpInside)
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 6).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: passwordField.rightAnchor).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: usernameField.topAnchor, constant: -10).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20).isActive = true
        button.leftAnchor.constraint(equalTo: passwordField.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: passwordField.rightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        signupButton.addTarget(self, action: #selector(createAccountButtonClicked), for: .touchUpInside)
        view.addSubview(signupButton)
        signupButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
        signupButton.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
        signupButton.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
        
        privacyButton.addTarget(self, action: #selector(openPrivacyPolicy), for: .touchUpInside)
        view.addSubview(privacyButton)
        privacyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        privacyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        
        let dismissGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(dismissGesture)
    }
    
    @objc
    func buttonClicked(){
        self.view.endEditing(true)
        guard let username = usernameField.textField.text else {
            return
        }
        guard let password = passwordField.textField.text else {
            return
        }
        login(username: username, password: password)
    }
    
    @objc
    func forgotPasswordClicked(){
        
    }
    
    func login(username:String, password:String) {
        var parameters:[String:Any] = [:]
        parameters["username"] = username
        parameters["password"] = password
        button.startRefresh()
        Network.request(url: "https://api.tryflux.app/login", type: .post, paramters: parameters) { (response, error) in
            if let err = error {
                self.button.endRefresh()
                print(err)
                self.errorBox.text = err.localizedDescription
                self.displayErrorBox()
                return
            }
            let keychain = Keychain(service: "com.johnnywaity.flux")
            keychain["refresh"] = response["refresh"] as? String
            Network.setToken(response["token"] as? String)
            Network.profile = Profile(username: Network.username!)
            FluxTabBarController.shared.profileController.setProfile(Network.profile!)
            FluxTabBarController.shared.homeController.getFeed()
            self.button.endRefresh()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    func createAccountButtonClicked(){
        present(CreateAccountController(self), animated: true, completion: nil)
    }
    
    
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func displayErrorBox(){
        errorBottom.constant = 60
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func openPrivacyPolicy(){
        AppDelegate.openPrivacyPolicy()
    }
}
