//
//  ConvoController.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import JWTDecode

class ConvoController: UIViewController, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, PostDelegate, BubbleDelegate {

    let convoID:String
    var posts:[Post] = []
    var postStates:[PostState] = []

    init(_ convoID:String, title:String) {
        self.convoID = convoID
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    var messages:[Message] = []
    let messageInputContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
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
        field.backgroundColor = UIColor.white
        field.layer.cornerRadius = 8
        //        field.placeholder = "Enter Comment"
        field.translatesAutoresizingMaskIntoConstraints = false

        return field
    }()
    let placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "Enter Message..."
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    var collectionView:UICollectionView!

    let bubbleID = "bubble"
    let postCellId = "post"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchMessages))
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        

        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        fetchMessages()

        collectionView.register(BubbleCell.self, forCellWithReuseIdentifier: bubbleID)
        collectionView.register(OptionPostCell.self, forCellWithReuseIdentifier: postCellId)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true



        view.addSubview(messageInputContainer)
        messageInputContainerBottomConstraint = messageInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageInputContainerBottomConstraint.isActive = true
        messageInputContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageInputContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

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

        let postButton = UIButton(type: .system)
        postButton.setTitle("+", for: .normal)
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        postButton.titleEdgeInsets.bottom = 4
        postButton.setTitleColor(UIColor.white, for: .normal)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.backgroundColor = UIColor.appBlue
        postButton.layer.cornerRadius = 16
        messageInputContainer.addSubview(postButton)
        postButton.leftAnchor.constraint(equalTo: messageInputContainer.leftAnchor, constant: 8).isActive = true
        postButton.bottomAnchor.constraint(equalTo: messageInputContainer.bottomAnchor, constant: -8).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 32).isActive = true

        messageInputContainer.addSubview(inputTextField)
        inputTextField.delegate = self
        //        inputTextField.topAnchor.constraint(equalTo: messageInputContainer.topAnchor).isActive = true
        inputTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: postButton.rightAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: messageInputContainer.bottomAnchor, constant: -8).isActive = true

        inputTextField.addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: inputTextField.topAnchor, constant: 1).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: inputTextField.leftAnchor, constant: 4).isActive = true
        //        placeholderLabel.widthAnchor.constraint(equalTo: inputTextField.widthAnchor, constant: -4).isActive = true
        placeholderLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true


        messageInputContainer.topAnchor.constraint(equalTo: inputTextField.topAnchor, constant: -8.5).isActive = true

        collectionView.bottomAnchor.constraint(equalTo: messageInputContainer.topAnchor).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let textMessage = messages[indexPath.row] as? TextMessage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bubbleID, for: indexPath) as! BubbleCell
            cell.setBubble(textMessage)
            cell.delegate = self
            return cell
        }else if let postMessage = messages[indexPath.row] as? PostMessage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as! OptionPostCell
            cell.setPost(postMessage.postID, collectionView: collectionView)
            cell.delegate = self
            if posts[postMessage.postIndex].fetched {
                cell.update(posts[postMessage.postIndex])
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let textMessage = messages[indexPath.row] as? TextMessage {
            let message = textMessage.message
            let size = CGSize(width: 250 - 20, height: 10000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

            let estimatedFrame = NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)


            return CGSize(width: UIScreen.main.bounds.width, height: estimatedFrame.height + 20)
        }else if let postMessage = messages[indexPath.row] as? PostMessage{
            switch posts[postMessage.postIndex].type {
            case .Option:
                if posts[postMessage.postIndex].fetched == false {
                    return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + round((Double(posts[postMessage.postIndex].amount ?? 1) / 2)) * 70))
                }else{
                    if postStates[postMessage.postIndex] == .Result {
                        return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(162 + (posts[postMessage.postIndex].choices!.count * 72)))
                    }
                    return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + round((Double(posts[postMessage.postIndex].choices!.count) / 2)) * 70))
                }
            case .Text:
                return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: 245)
            }
        }
        return CGSize(width: 0, height: 0)
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
                self.scrollToBottom()
            })
        }
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
        var myUsername = ""
        do{
            let jwt = try decode(jwt: Network.authToken!)
            myUsername = (jwt.body["uID"] as! String)

        }catch{
            print(error)
        }
        let message = inputTextField.text!
        messages.append(TextMessage(user: myUsername, time: "now", message: message, style: .mine))
        collectionView.insertItems(at: [IndexPath(row: messages.count - 1, section: 0)])
        Network.request(url: "https://api.tryflux.app/sendDM", type: .post, paramters: ["convoID": convoID, "type": 0, "message": message], auth: true)
        inputTextField.text = ""
        collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
    }



    

    @objc
    func fetchMessages(){
        Network.request(url: "https://api.tryflux.app/messages", type: .post, paramters: ["convoID":convoID], auth: true) { (result, err) in
            if let e = err {
                print(e.localizedDescription)
                return
            }
            var posts:[Post] = []
            var cellIndexes:[Int] = []
            var states:[PostState] = []
            var newMessages:[Message] = []
            if let ms = result["messages"] as? [[String:Any]] {
                for m in ms {
                    guard let user = m["user"] as? String else{continue}
                    guard let type = m["type"] as? Int else{continue}
                    guard let time = m["time"] as? String else{continue}
                    guard let isMe = m["isMe"] as? Bool else{continue}
                    if type == 0 {
                        guard let message = m["message"] as? String else{continue}
                        let text = TextMessage(user: user, time: time, message: message, style: isMe ? BubbleStyle.mine : BubbleStyle.other)
                        newMessages.append(text)
                    }else if type == 1 {
                        guard let postID = m["postID"] as? String else{continue}
                        let postMessage = PostMessage(user: user, time: time, postID: postID, postIndex: posts.count, cellIndex: newMessages.count)
                        posts.append(Post(postID: postID, type: .Option))
                        states.append(.Question)
                        cellIndexes.append(newMessages.count)
                        newMessages.append(postMessage)
                    }
                }
            }
            self.posts = posts
            self.postStates = states
            for i in 0..<self.posts.count {
                self.fetchPost(self.posts[i], index: cellIndexes[i])
            }
            self.messages = newMessages
            self.collectionView.reloadData()
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                self.scrollToBottom()
            })
            
        }
    }
    
    func scrollToBottom(){
        collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func fetchPost(_ post:Post, index:Int){
        post.fetch {
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PostCell {
                cell.update(post)
            }
        }
    }
    
    /* BubbleDelegate START */
    func openProfileLink(_ username: String) {
        navigationController?.pushViewController(ProfileController(username), animated: true)
    }
    /* BubbleDelegate END */
    
    /* PostDelegate START */
    func openProfile(for postID: String) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                navigationController?.pushViewController(ProfileController(posts[i].user ?? ""), animated: true)
                break
            }
        }
    }
    func openComments(for postID: String) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                navigationController?.pushViewController(CommentsController(posts[i]), animated: true)
                break
            }
        }
    }
    func postState(for postID: String) -> PostState {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return postStates[i]
            }
        }
        return .Question
    }
    func setPostState(for postID: String, with state: PostState) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                postStates[i] = state
                break
            }
        }
    }
    func answerPost(for postID: String, with answer: Int) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                posts[i].answerOption(answer)
                break
            }
        }
    }
    func getAnswers(for postID: String) -> [Int] {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].getAnswers()
            }
        }
        fatalError("No Answers")
    }
    func getCommentCount(for postID: String) -> Int {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].comments.count
            }
        }
        return 0
    }
    func getPostChoices(for postID: String) -> [String] {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].choices ?? []
            }
        }
        fatalError("No Choices")
    }
    func getPostColors(for postID: String) -> [String] {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].colors ?? []
            }
        }
        fatalError("No Colors")
    }
    func refreshPost(for postID: String) {
        for i in 0..<messages.count {
            if let postMessage = messages[i] as? PostMessage {
                if let cell = collectionView.cellForItem(at: IndexPath(row: postMessage.cellIndex, section: 0)) as? PostCell {
                    cell.setPost(postMessage.postID, collectionView: collectionView)
                }
                fetchPost(posts[postMessage.postIndex], index: postMessage.cellIndex)
            }
        }
    }
    func shouldShowShare() -> Bool {
        return false
    }
    /* PostDelegate END */

}
class Message {
    let user:String
    let time:String
    init(user:String, time:String) {
        self.user = user
        self.time = time
    }
}
class TextMessage:Message {
    let message:String
    let style:BubbleStyle
    init(user:String, time:String, message:String, style:BubbleStyle) {
        self.message = message
        self.style = style
        super.init(user: user, time: time)
    }
}
class PostMessage:Message {
    let postID:String
    let postIndex:Int
    let cellIndex:Int
    init(user:String, time:String, postID:String, postIndex:Int, cellIndex:Int) {
        self.postID = postID
        self.postIndex = postIndex
        self.cellIndex = cellIndex
        super.init(user: user, time: time)
    }
}
