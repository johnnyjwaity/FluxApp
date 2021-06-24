//
//  CommentsController.swift
//  Flux
//
//  Created by Johnny Waity on 7/3/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import NotificationCenter


class CommentsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CommentCellDelegate {
    
    let post:Post
    
    let messageInputContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "GR")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor.lightGray
        view.addSubview(divider)
        divider.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        divider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    var messageInputContainerBottomConstraint:NSLayoutConstraint!
    
    let inputTextField:UITextView = {
        let field = UITextView()
        field.font = UIFont.systemFont(ofSize: 16)
        field.isScrollEnabled = false
//        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
//        field.placeholder = "Enter Comment"
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    let placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "Enter Comment..."
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    
    
    init(_ post:Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        navigationItem.title = "Comments"
        view.backgroundColor = UIColor.white
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: "comment-cell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
//        tabBarController?.tabBar.isHidden = true
        
        view.addSubview(messageInputContainer)
        messageInputContainerBottomConstraint = messageInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageInputContainerBottomConstraint.isActive = true
        messageInputContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageInputContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        messageInputContainer.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.setTitle("Send", for: .normal)
        sendButton.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate), for: .normal)
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        sendButton.tintColor = UIColor.appBlue
        sendButton.setTitleColor(UIColor.appBlue, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        messageInputContainer.addSubview(sendButton)
        sendButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageInputContainer.bottomAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: messageInputContainer.rightAnchor, constant: -8).isActive = true
        
        messageInputContainer.addSubview(inputTextField)
        inputTextField.delegate = self
//        inputTextField.topAnchor.constraint(equalTo: messageInputContainer.topAnchor).isActive = true
        inputTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: messageInputContainer.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: messageInputContainer.bottomAnchor, constant: -8).isActive = true
        
        inputTextField.addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: inputTextField.topAnchor, constant: 1).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: inputTextField.leftAnchor, constant: 4).isActive = true
//        placeholderLabel.widthAnchor.constraint(equalTo: inputTextField.widthAnchor, constant: -4).isActive = true
        placeholderLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        messageInputContainer.topAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -8.5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor).isActive = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    @objc
    func handleKeyboard(notification:Notification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            print(keyboardFrame)
            let keyboardIsShowing = notification.name == UIResponder.keyboardWillShowNotification
            messageInputContainerBottomConstraint.constant = keyboardIsShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                let commentCount = self.post.comments.count
                if commentCount > 0 {
                    print("Scrolling to \(commentCount - 1)")
                    if keyboardIsShowing {
                        self.tableView.scrollToRow(at: IndexPath(row: commentCount - 1, section: 0), at: .bottom, animated: true)
                    }
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        inputTextField.insertText("@\(post.comments[indexPath.row].user) ")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment-cell") as! CommentCell
        cell.setCell(post.comments[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            placeholderLabel.alpha = 1
        }else{
            placeholderLabel.alpha = 0
        }
    }
    
    @objc
    func sendButtonClicked(){
        let newComment = inputTextField.text
        inputTextField.text = ""
        let nc = Comment(user: "Johnnyjw", comment: newComment!, timestamp: "now")
        post.comments.append(nc)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: post.comments.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: IndexPath(row: post.comments.count - 1, section: 0), at: .bottom, animated: true)
        
        Network.request(url: "https://api.tryflux.app/comment", type: .post, paramters: ["postID": post.postID, "comment": newComment ?? ""], auth: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let commentText = post.comments![indexPath.row].comment
//        let amountOfLines = commentText.components(separatedBy: "\n").count - 1
//        return CGFloat(76 + (20 * amountOfLines))
//    }
    
    func openProfile(_ username: String) {
        navigationController?.pushViewController(ProfileController(profile: Profile(username: username)), animated: true)
    }

}
