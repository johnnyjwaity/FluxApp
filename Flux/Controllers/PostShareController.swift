//
//  PostShareController.swift
//  Flux
//
//  Created by Johnny Waity on 7/12/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class PostShareController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let postID:String
    
    let containerView = UIView()
    var bottomConstraint:NSLayoutConstraint!
    var convos:[Convo] = []
    var selected:[Bool] = []
    
    init(_ postID:String){
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.bounds.height * 0.45)
        bottomConstraint.isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        let dismissArea = UIView()
        dismissArea.translatesAutoresizingMaskIntoConstraints = false
        dismissArea.backgroundColor = UIColor.clear
        view.addSubview(dismissArea)
        dismissArea.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dismissArea.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dismissArea.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dismissArea.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        dismissArea.addGestureRecognizer(tapGesture)
        
        
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        containerView.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
        
        let shareTitle = UILabel()
        shareTitle.translatesAutoresizingMaskIntoConstraints = false
        shareTitle.text = "Share Post"
        shareTitle.font = UIFont.boldSystemFont(ofSize: 20)
        shareTitle.textColor = UIColor.black
        containerView.addSubview(shareTitle)
        shareTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
        shareTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        shareTitle.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = UIColor.appBlue
        sendButton.setTitleColor(UIColor.white, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        containerView.addSubview(sendButton)
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(SelectConvoCell.self, forCellReuseIdentifier: "convo-select")
        containerView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: shareTitle.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        fetchConvos()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convo-select") as! SelectConvoCell
        cell.setName(convos[indexPath.row].recipient)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SelectConvoCell {
            cell.toggleCheck()
            selected[indexPath.row] = !selected[indexPath.row]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }) { (completed) in
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func fetchConvos(){
        Network.request(url: "https://api.tryflux.app/convos", type: .get, paramters: nil, auth: true) { (result, err) in
            if let e = err {
                print(e.localizedDescription)
                return
            }
            var newConvos:[Convo] = []
            if let cs = result["convos"] as? [[String:String]] {
                for c in cs {
                    newConvos.append(Convo(recipient: c["recipient"]!, preview: c["preview"]!, id: c["convoID"]!, time: c["time"]!))
                }
            }
            self.convos = newConvos
            self.selected = []
            for _ in newConvos {
                self.selected.append(false)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc
    func send(){
        var counter = 0
        for s in selected {
            if s {
                Network.request(url: "https://api.tryflux.app/sendDM", type: .post, paramters: ["convoID": convos[counter].id, "type": 1, "postID":postID], auth: true)
            }
            counter += 1
        }
        dismissView()
    }
    
    
    @objc
    func dismissView(){
        self.bottomConstraint.constant = view.bounds.height * 0.45
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: { (animated) in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
