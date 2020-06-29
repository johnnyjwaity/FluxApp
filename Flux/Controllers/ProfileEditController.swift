//
//  ProfileEditController.swift
//  Flux
//
//  Created by Johnny Waity on 7/2/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class ProfileEditController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    let origInfo:[[String]]
    
    init(name:String = "", bio:String = "", link:String = "") {
        origInfo = [[name, bio], [link]]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Edit"
        navigationItem.title = "Edit"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        // Do any additional setup after loading the view.
        
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    let placeholders = [["Name", "Bio"], ["Link"]]
    var placeholderLabels:[[UILabel?]] = [[nil, nil],[nil]]
    let wordCounter = UILabel()
    var textFields:[UITextView] = []
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let textField = UITextView()
        textFields.append(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textContainerInset.top = 12
        textField.isScrollEnabled = indexPath.section == 0 && indexPath.row == 1 ? true : false
        textField.delegate = self
        textField.tag = Int("\(indexPath.section)\(indexPath.row)")!
        textField.textContainer.maximumNumberOfLines = 5
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            textField.insertText(self.origInfo[indexPath.section][indexPath.row])
            _ = self.textView(textField, shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: "")
        }
        
        
        let placeholder = UILabel()
        placeholder.text = placeholders[indexPath.section][indexPath.row]
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.textColor = UIColor.lightGray
        textField.addSubview(placeholder)
        placeholder.topAnchor.constraint(equalTo: textField.topAnchor).isActive = true
        placeholder.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 8).isActive = true
        placeholder.heightAnchor.constraint(equalToConstant: 44).isActive = true
        placeholderLabels[indexPath.section][indexPath.row] = placeholder
        
        if indexPath.section == 0 && indexPath.row == 1 {
            print("Creating Label")
            let wordCounter = UILabel()
            wordCounter.text = "200"
            wordCounter.textColor = UIColor.lightGray
            wordCounter.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(wordCounter)
            wordCounter.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            wordCounter.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            wordCounter.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        textField.font = placeholder.font
        cell.addSubview(textField)
        textField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        
        if indexPath.section == 0 && indexPath.row == 1 {
            print("Creating Label")
            
            wordCounter.text = "200"
            wordCounter.textColor = UIColor.lightGray
            wordCounter.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(wordCounter)
            wordCounter.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            wordCounter.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -8).isActive = true
            wordCounter.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && indexPath.row == 1 ? 170 : 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    let headers = ["Info", "Link"]
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let section:Int = textView.tag / 10
        let row:Int = textView.tag % 10
        if textView.text == "" {
            placeholderLabels[section][row]?.alpha = 1
        }else{
            placeholderLabels[section][row]?.alpha = 0
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
            return false
        }
        let newStrCount = textView.text.count + (text.count - range.length)
        if newStrCount > 200 {
            return false
        }
        if textView.tag == 1 {
            wordCounter.text = "\(200 - newStrCount)"
        }
        return true
    }

    @objc
    func save() {
        let name:String = textFields[0].text
        let bio:String = textFields[1].text
        let link:String = textFields[2].text
//        print("\(name) \(bio) \(link)")
        Network.request(url: "https://api.tryflux.app/updateProfile", type: .post, paramters: ["bio": bio, "name": name, "link": link], auth: true)
        dismiss(animated: true, completion: nil)
    }

}
