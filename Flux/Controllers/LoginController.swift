//
//  LoginController.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let fields = ["Username", "Password", "Email"]
    var textFields:[UITextField?] = [nil, nil, nil]
    
    var loggingIn = true
    var heightAnchor:NSLayoutConstraint!
    
    var tableView:UITableView!
    
    var segmentedIndex:UISegmentedControl!
    var button:UIButton!
    
    let errorBox = UILabel()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.appBlue.cgColor, UIColor.appGreen.cgColor]
        gradientLayer.frame = view.bounds
        gradientLayer.masksToBounds = true
        view.layer.addSublayer(gradientLayer)
        
        
        errorBox.text = "Test Error"
        errorBox.backgroundColor = UIColor.red
        errorBox.textColor = UIColor.white
        errorBox.font = UIFont.boldSystemFont(ofSize: 20)
        errorBox.adjustsFontSizeToFitWidth = true
        errorBox.translatesAutoresizingMaskIntoConstraints = false
        errorBox.textAlignment = .center
        view.addSubview(errorBox)
        errorBox.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorBox.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        errorBox.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        errorBox.heightAnchor.constraint(equalToConstant: 35).isActive = true
        errorBox.alpha = 0
        
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 14
        self.view.addSubview(tableView)
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -44).isActive = true
        heightAnchor = tableView.heightAnchor.constraint(equalToConstant: 44 * 2)
        heightAnchor.isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        segmentedIndex = UISegmentedControl(items: ["Login", "Create Account"])
        segmentedIndex.selectedSegmentIndex = 0
        segmentedIndex.translatesAutoresizingMaskIntoConstraints = false
        segmentedIndex.tintColor = UIColor.white
        view.addSubview(segmentedIndex)
        segmentedIndex.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12).isActive = true
        segmentedIndex.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
        segmentedIndex.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive = true
        segmentedIndex.addTarget(self, action: #selector(switchType(_:)), for: .valueChanged)
        
        button = UIButton(type: .system)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 14
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//        button.backgroundColor = UIColor.white
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12).isActive = true
        button.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "Flux"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Amandita", size: 75)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loggingIn ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        let textView = UITextField(frame: cell.bounds)
        textView.placeholder = fields[indexPath.row]
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isSecureTextEntry = indexPath.row == 1
        cell.addSubview(textView)
        textView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
        textFields[indexPath.row] = textView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offset = button.frame.maxY - (self.view.frame.height / 2)
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y -= offset
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let offset = button.frame.maxY - (self.view.frame.height / 2)
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y += offset
        }
    }
    
    @objc
    func switchType(_ sender:UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            heightAnchor.constant = 44 * 2
            loggingIn = true
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
//            tableView.endUpdates()
        }else{
            heightAnchor.constant = 44 * 3
            loggingIn = false
//            tableView.beginUpdates()
//            tableView.insertRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
//            tableView.endUpdates()
        }
        tableView.reloadData()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func buttonClicked(){
        self.view.endEditing(true)
        var parameters:[String:Any] = [:]
        guard let username = textFields[0]?.text else {
            return
        }
        guard let password = textFields[1]?.text else {
            return
        }
        parameters["username"] = username
        parameters["password"] = password
        if loggingIn == false {
            guard let email = textFields[2]?.text else{
                return
            }
            parameters["email"] = email
            if username.count < 6 {
                errorBox.text = "Username Needs To Be At Least 6 Characters Long"
                displayErrorBox()
                return
            }
            if password.count < 6 {
                errorBox.text = "Password Needs To Be At Least 6 Characters Long"
                displayErrorBox()
                return
            }
            if !isValidEmail(email: email){
                errorBox.text = "Email Not Valid"
                displayErrorBox()
                return
            }
        }
        let loading = LoadingController(loggingIn ? "Logging In" : "Creating Account")
        present(loading, animated: true, completion: nil)
        Network.request(url: "https://api.tryflux.app/\(loggingIn ? "login": "createAccount")", type: .post, paramters: parameters) { (response, error) in
            if let err = error {
                loading.dismiss(animated: true, completion: nil)
                print(err)
                self.errorBox.text = err.localizedDescription
                self.displayErrorBox()
                return
            }
            let keychain = Keychain(service: "com.johnnywaity.flux")
            keychain["refresh"] = response["refresh"] as? String
            Network.authToken = (response["token"] as! String)
            
            HomeController.shared.getFeed()
            loading.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let prospectiveText = (oldText as NSString).replacingCharacters(in: range, with: string)
        if prospectiveText == "" {
            return true
        }
        if prospectiveText.count > 320 {
            return false
        }
        if textField.placeholder != "Email" {
            if prospectiveText.count > 20 {
                return false
            }
            let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
            for char in prospectiveText {
                if !allowedChars.contains(char) {
                    return false
                }
            }
        }
        return true
        
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
        UIView.animate(withDuration: 0.2) {
            self.errorBox.alpha = 1
        }
    }
}
