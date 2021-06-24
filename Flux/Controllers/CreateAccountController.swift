//
//  CreateAccountController.swift
//  Flux
//
//  Created by Johnny Waity on 5/13/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class CreateAccountController: UIViewController, CreateAccountDelegate {
    
    let presenter:LoginController

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
        b.setTitle("", for: .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return b
    }()
    
    let controllers:[UIViewController]
    var currentController = 0
    var phoneCountryCode:CountryCode? = nil
    var phoneNumber:String? = nil
    
    init(_ presenter:LoginController){
        self.presenter = presenter
        let phoneEnter = PhoneNumberEnter()
        let phoneVerify = PhoneNumberVerify()
        let createPage = CreatePage()
        controllers = [phoneEnter, createPage]
        super.init(nibName: nil, bundle: nil)
        phoneEnter.delegate = self
        phoneVerify.delegate = self
        createPage.delegate = self
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
    func setPhone(code: CountryCode, number: String) {
        self.phoneCountryCode = code
        self.phoneNumber = number
    }
    func getPhone() -> (code: CountryCode, number: String)? {
        if let c = phoneCountryCode {
            if let n = phoneNumber {
                return (code: c, number: n)
            }
        }
        return nil
    }
    func login(username: String, password: String) {
        self.dismiss(animated: true) {
            self.presenter.login(username: username, password: password)
        }
    }
}

protocol CreateAccountDelegate {
    func next()
    func back()
    func setPhone(code:CountryCode, number:String)
    func getPhone() -> (code:CountryCode, number:String)?
    func login(username:String, password:String)
}

class PhoneNumberEnter:UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var delegate:CreateAccountDelegate? = nil
    var curCode:CountryCode!
    
    let label:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 35)
        l.textColor = UIColor(named: "FG")
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        return l
    }()
    let subLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = UIColor.lightGray
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        return l
    }()
    
    let countryInput:UIButton = {
        let l = UIButton()
        l.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
   
    let inputField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.placeholder = "(000) 000-0000"
        tf.keyboardType = .numberPad
        tf.textColor = UIColor.appBlue
        return tf
    }()
    
    
    let border:UIView = {
        let border = UIView()
        border.backgroundColor = UIColor.appBlue
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    let pickerView:UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        return p
    }()
    var pickerBottom:NSLayoutConstraint!
    var pickerTop:NSLayoutConstraint!
    
    let pickerToolbar:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let border = UIView()
        border.backgroundColor = UIColor.lightGray
        border.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(border)
        border.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: v.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let border2 = UIView()
        border2.backgroundColor = UIColor.lightGray
        border2.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(border2)
        border2.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        border2.leftAnchor.constraint(equalTo: v.leftAnchor).isActive = true
        border2.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        border2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return v
    }()
    
    let pickerSelectButton:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Select", for: .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        return b
    }()
    
    let pickerCancelButton:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        return b
    }()
    
    let nextButton = LoadButton(title: "Next")
    var nextBottom:NSLayoutConstraint!
    
    init(){
        super.init(nibName: nil, bundle: nil)
        label.text = "Let's Get Started!"
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        subLabel.text = "First, enter a phone number so we can verify who you are!"
        view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        countryInput.addTarget(self, action: #selector(openPickerView), for: .touchUpInside)
        view.addSubview(countryInput)
        countryInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        countryInput.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
//        countryInput.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        countryInput.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        inputField.delegate = self
        view.addSubview(inputField)
        inputField.centerYAnchor.constraint(equalTo: countryInput.centerYAnchor).isActive = true
        inputField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        inputField.leftAnchor.constraint(equalTo: countryInput.rightAnchor, constant: 10).isActive = true
//        inputField.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        view.addSubview(border)
        border.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: 2).isActive = true
        border.leftAnchor.constraint(equalTo: countryInput.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: inputField.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        nextButton.setEnabled(false)
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        view.addSubview(nextButton)
        nextBottom = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        nextBottom.isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(pickerView)
        pickerBottom = pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        pickerBottom.isActive = false
        pickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pickerTop = pickerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
        pickerTop.isActive = true
        
        view.addSubview(pickerToolbar)
        pickerToolbar.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        pickerToolbar.leftAnchor.constraint(equalTo: pickerView.leftAnchor).isActive = true
        pickerToolbar.rightAnchor.constraint(equalTo: pickerView.rightAnchor).isActive = true
        pickerToolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pickerSelectButton.addTarget(self, action: #selector(pickerSelectButtonClicked), for: .touchUpInside)
        pickerToolbar.addSubview(pickerSelectButton)
        pickerSelectButton.centerYAnchor.constraint(equalTo: pickerToolbar.centerYAnchor).isActive = true
        pickerSelectButton.rightAnchor.constraint(equalTo: pickerToolbar.rightAnchor, constant: -8).isActive = true
        
        pickerCancelButton.addTarget(self, action: #selector(closePickerView), for: .touchUpInside)
        pickerToolbar.addSubview(pickerCancelButton)
        pickerCancelButton.centerYAnchor.constraint(equalTo: pickerToolbar.centerYAnchor).isActive = true
        pickerCancelButton.leftAnchor.constraint(equalTo: pickerToolbar.leftAnchor, constant: 8).isActive = true
        
        setCountryCode(CountryCode.unitedStates)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func keyboardWillShow(notification:Notification){
        closePickerView()
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        nextBottom.constant = -((keyboardHeight ?? 0) + 10)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(notification:Notification){
        nextBottom.constant = -10
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func setCountryCode(_ code:CountryCode) {
        let finalString = NSMutableAttributedString()
        let countryString = NSMutableAttributedString(string: code.abreviation + " ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let codeString = NSMutableAttributedString(string: "+\(code.code)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appBlue])
        finalString.append(countryString)
        finalString.append(codeString)
        countryInput.setAttributedTitle(finalString, for: .normal)
        curCode = code
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            nextButton.setEnabled(false)
            return true
        }
        if ((textField.text ?? "") + string).count > 10 {
            return false
        }
        
        let numbersSet = CharacterSet(charactersIn: "0123456789")
        let textCharacterSet = CharacterSet(charactersIn: string)
        if !textCharacterSet.isSubset(of: numbersSet) {
            return false
        }
        
        if ((textField.text ?? "") + string).count == 10 {
            nextButton.setEnabled(true)
        }else{
            nextButton.setEnabled(false)
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryCode.codes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(CountryCode.codes[row].name) +\(CountryCode.codes[row].code)"
    }
    
    @objc
    func openPickerView(){
        view.endEditing(true)
        pickerTop.isActive = false
        pickerBottom.isActive = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc
    func pickerSelectButtonClicked(){
        let row = pickerView.selectedRow(inComponent: 0)
        setCountryCode(CountryCode.codes[row])
        closePickerView()
    }
    
    @objc
    func closePickerView(){
        pickerBottom.isActive = false
        pickerTop.isActive = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc
    func nextButtonClicked(){
        nextButton.startRefresh()
        var parameters:[String:Any] = [:]
        parameters["phone"] = self.inputField.text ?? ""
        parameters["countryCode"] = self.curCode.code
        Network.request(url: "https://api.tryflux.app/validPhone", type: .post, paramters: parameters, auth: false) { (res, err) in
            self.nextButton.endRefresh()
            if res["success"] as? Int == 1 {
                self.delegate?.setPhone(code: self.curCode, number: self.inputField.text ?? "")
                self.delegate?.next()
            }else{
                let alert = UIAlertController(title: "Sorry...", message: "Phone number is already in use", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }

}

class PhoneNumberVerify:UIViewController{
    
    var delegate:CreateAccountDelegate? = nil
    
    let label:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 35)
        l.textColor = UIColor(named: "FG")
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        return l
    }()
    let subLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = UIColor.lightGray
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        return l
    }()
    
    
    let verifyButton = LoadButton(title: "I've Verified My Number")
    
    let backButton:UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Didn't Recieve a Message?", for: .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        return b
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        label.text = "Verify Your Number"
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        subLabel.text = "A text message was sent to you with a verification link. Click the link to verify your number."
        view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        
        
        verifyButton.layer.cornerRadius = 8
        verifyButton.addTarget(self, action: #selector(verifyButtonClicked), for: .touchUpInside)
        view.addSubview(verifyButton)
        verifyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verifyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        backButton.addTarget(self, action: #selector(noCode), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(verifyNotif), name: Notification.Name(rawValue: "verify"), object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func noCode(){
        delegate?.back()
    }
    
    @objc
    func verifyButtonClicked(){
        self.delegate?.next()
        if let number = delegate?.getPhone() {
            verifyButton.startRefresh()
            let params:[String:String] = ["countryCode": "\(number.code.code)", "phone": "\(number.number)"]
            print(params)
            Network.request(url: "https://api.tryflux.app/isVerified", type: .post, paramters: params, auth: false) { (res, err) in
                self.verifyButton.endRefresh()
                if res["success"] as? Int == 1 {
                    if res["verified"] as? Int == 1 {
                        self.delegate?.next()
                    }else{
                        let alert = UIAlertController(title: "Sorry...", message: "The phone number was not verified. Please Try Again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }else{
                    let alert = UIAlertController(title: "Sorry...", message: "Unknown Error Occurred. Please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc
    func verifyNotif(){
        verifyButtonClicked()
    }
    
}

class CreatePage:UIViewController {
    
    var delegate:CreateAccountDelegate? = nil
    
    let label:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 35)
        l.textColor = UIColor(named: "FG")
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        return l
    }()
    let subLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.textColor = UIColor.lightGray
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        return l
    }()
    
    
    let usernameField = IconTextField(icon: #imageLiteral(resourceName: "profile"), field: "Username")
    let passwordField = IconTextField(icon: #imageLiteral(resourceName: "lock"), field: "Password", secure: true)
    let passwordConfirmField = IconTextField(icon: #imageLiteral(resourceName: "lock"), field: "Confirm Password", secure: true)
    
    let button:LoadButton = LoadButton(title: "Create Account")
    init(){
        super.init(nibName: nil, bundle: nil)
        
        label.text = "Create your Account"
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        subLabel.text = "Next step to create your account is to create your username and password"
        view.addSubview(subLabel)
        subLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        view.addSubview(usernameField)
        usernameField.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passwordField)
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20).isActive = true
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passwordConfirmField)
        passwordConfirmField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20).isActive = true
        passwordConfirmField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: passwordConfirmField.bottomAnchor, constant: 20).isActive = true
        button.leftAnchor.constraint(equalTo: passwordField.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: passwordField.rightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    func buttonClicked() {
        guard let username = usernameField.textField.text else {return}
        guard let password = passwordField.textField.text else {return}
        guard let confirmPassword = passwordConfirmField.textField.text else {return}
        
        if username.count == 0 {
            let alert = UIAlertController(title: "Sorry...", message: "Please Enter Username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if password != confirmPassword {
            let alert = UIAlertController(title: "Sorry...", message: "Password does not match confiration password. Please check both and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if password.count <= 6 {
            let alert = UIAlertController(title: "Sorry...", message: "Password is too short. Passwords need to be greater than 6 characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        button.startRefresh()
        var parameters:[String:Any] = [:]
        parameters["username"] = username
        parameters["password"] = password
        if let phone = delegate?.getPhone() {
            parameters["phone"] = phone.number
            parameters["countryCode"] = phone.code.code
        }else{
            return
        }
        Network.request(url: "https://api.tryflux.app/createAccount", type: .post, paramters: parameters, auth: false) { (res, err) in
            self.button.endRefresh()
            if res["success"] as? Int == 1 {
                self.delegate?.login(username: username, password: password)
            }else{
                let alert = UIAlertController(title: "Sorry...", message: res["reason"] as? String ?? "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
