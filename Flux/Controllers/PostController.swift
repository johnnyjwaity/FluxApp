//
//  PostController.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class PostController: UIViewController, CreatePostDelegate{
    
    var postData:[String:Any] = [:]
    
    
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
    
    var controllers:[CreatePostPageController] = []
    var currentController = 0
    
    init(){
        let typeController = CreatePostTypeController()
        controllers.append(typeController)
        super.init(nibName: nil, bundle: nil)
        typeController.delegate = self
        view.backgroundColor = UIColor(named: "BG")
        
        view.addSubview(topBar)
        topBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePage(increment: false)
    }
    
    func changePage(increment:Bool = true, amount:Int=1) {
        if increment {
            currentController += amount
        }
        for v in pageDotStack.arrangedSubviews {
            pageDotStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }
        for i in 0..<controllers.count {
            if controllers.count == 1 {
                break
            }
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
            dot.backgroundColor = i == currentController ? UIColor.appBlue : UIColor(named: "GR")
            dot.layer.cornerRadius = 5
            pageDotStack.addArrangedSubview(dot)
        }
        pageViewController.setViewControllers([controllers[currentController]], direction: .forward, animated: true, completion: { (c:Bool) in
            self.controllers[self.currentController].setActive()
        })
    }
    
    
    
    func setType(_ postType: PostType) {
        postData = ["type": postType]
        let questionController = CreatePostTextController(titleText: "What question is on your mind today?", placeholderText: "What should I...", limit: 80, optional: false, field: "question")
        questionController.delegate = self
        controllers.append(questionController)
        
        
        switch postType {
        case .Option:
            for i in 1...4 {
                let optionController = CreatePostTextController(titleText: "What should Option \(i) be?", placeholderText: "Option \(i)", limit: 40, optional: i > 2, field: "option\(i)")
                optionController.delegate = self
                controllers.append(optionController)
            }
            break
        case .YesNo:
            postData["option1"] = "Yes"
            postData["option2"] = "No"
            break
        case .Emoji:
            let emojiController = CreatePostEmojiController()
            emojiController.delegate = self
            controllers.append(emojiController)
            break
        case .Rating:
            break
        }
        let reviewController = CreatePostReviewController()
        reviewController.delegate = self
        controllers.append(reviewController)
        changePage()
    }
    
    func setBarItem(text: String, disabled: Bool, hidden:Bool) {
        otherButton.setTitle(text, for: .normal)
        otherButton.isEnabled = !disabled
        otherButton.isHidden = hidden
        if disabled {
            otherButton.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
            otherButton.setTitleColor(UIColor.appBlue, for: .normal)
        }
    }
    
    @objc
    func rightButtonClicked(){
        if let val = controllers[currentController].getValue() {
            print(val)
            let convertedVal = val as [String:Any]
            postData.merge(convertedVal) { (one, two) -> Any in
                return one
            }
            changePage()
        }else{
            if (controllers[currentController] as? CreatePostTextController)?.field == "option3" {
                changePage(amount: 2)
            }else{
                changePage()
            }
        }
    }
    
    @objc
    func closeView(){
        dismiss(animated: true, completion: nil)
    }
    
    func getData() -> [String : Any] {
        return postData
    }
    
    func dismissPostController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
protocol CreatePostDelegate {
    func setBarItem(text:String, disabled:Bool, hidden:Bool)
    func setType(_ postType:PostType)
    func getData() -> [String:Any]
    func dismissPostController()
}
enum PostType {
    case Option
    case YesNo
    case Emoji
    case Rating
    static func fromNum(_ i:Int) -> PostType{
        switch i {
        case 0:
            return .Option
        case 1:
            return .YesNo
        case 2:
            return .Emoji
        case 3:
            return .Rating
        default:
            return .Option
        }
    }
    static func toNum(_ type:PostType) -> Int{
        switch type {
        case .Option:
            return 0
        case .YesNo:
            return 1
        case .Emoji:
            return 2
        case .Rating:
            return 3
        }
    }
}
class CreatePostPageController:UIViewController {
    var delegate:CreatePostDelegate? = nil
    func setActive(){
        
    }
    func getValue() -> [String:String]? {
        return nil
    }
}
class CreatePostTypeController: CreatePostPageController, UITableViewDelegate, UITableViewDataSource  {
    let icons:[UIImage] = [#imageLiteral(resourceName: "option-post"), #imageLiteral(resourceName: "yes-no-post"), #imageLiteral(resourceName: "emoji-post"), #imageLiteral(resourceName: "rating-post")]
    let titles:[String] = ["Option Post", "Yes/No Post", "Emoji Post", "Rating Post"]
    let subtitles:[String] = ["Create a post with up to four options for friends to choose from", "Create a post for friends to answer a yes or no question!", "Choose up to four emojis for friends to use when answering a question!", "Create a post where friends can aswer on a scale of 1-10"]
    
    let tableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTypeCell.self, forCellReuseIdentifier: "postType")
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = UIColor(named: "BG")
        return tableView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postType") as! PostTypeCell
        cell.setCell(image: icons[indexPath.row], title: titles[indexPath.row], subtitle: subtitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setType(PostType.fromNum(indexPath.row))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func setActive() {
        delegate?.setBarItem(text: "", disabled: true, hidden: true)
    }
}

class CreatePostTextController:CreatePostPageController, UITextViewDelegate{
    
    let limit:Int
    let optional:Bool
    let field:String
    
    let label:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 30)
        l.textColor = UIColor.black
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        return l
    }()
    
    let inputField:UITextView = {
        let tf = UITextView()
        tf.isEditable = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 25)
        tf.backgroundColor = UIColor(named: "BG")
        return tf
    }()
    var inputHeightContraint:NSLayoutConstraint!
    
    let placeholder:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.lightGray
        l.text = "Placeholder"
        l.font = UIFont.systemFont(ofSize: 20)
        l.isUserInteractionEnabled = false
        return l
    }()
    
    let border:UIView = {
        let border = UIView()
        border.backgroundColor = UIColor.appBlue
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    let charCount:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .right
        return l
    }()
    
    init(titleText:String, placeholderText:String, limit:Int, optional:Bool, field:String){
        self.limit = limit
        self.optional = optional
        self.field = field
        super.init(nibName: nil, bundle: nil)
        label.text = titleText
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        inputField.delegate = self
        view.addSubview(inputField)
        inputField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        inputField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        inputHeightContraint = inputField.heightAnchor.constraint(equalToConstant: 46)
        inputHeightContraint.isActive = true
        
        placeholder.text = "\(placeholderText) (\(optional ? "Optional" : "Required"))"
        inputField.addSubview(placeholder)
        placeholder.leftAnchor.constraint(equalTo: inputField.leftAnchor, constant: 4).isActive = true
        placeholder.centerYAnchor.constraint(equalTo: inputField.centerYAnchor).isActive = true
        
        view.addSubview(border)
        border.topAnchor.constraint(equalTo: inputField.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: inputField.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: inputField.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        charCount.text = "\(limit)"
        view.addSubview(charCount)
        charCount.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 4).isActive = true
        charCount.rightAnchor.constraint(equalTo: border.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var text:String = textView.text
        if text.count > limit {
            text = String(text.prefix(limit))
        }
        textView.text = text
        charCount.text = "\(limit - text.count)"
        
        if text.count != 0 {
            placeholder.isHidden = true
            delegate?.setBarItem(text: "Next", disabled: false, hidden: false)
        }else{
            placeholder.isHidden = false
            delegate?.setBarItem(text: "Next", disabled: true, hidden: false)
        }
        if optional {
            delegate?.setBarItem(text: "Next", disabled: false, hidden: false)
        }
        
        var newHeight = inputField.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width * 0.9, height: 10000)).height
        if newHeight > 150 {
            newHeight = 150
        }
        inputHeightContraint.constant = newHeight
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func setActive() {
        if optional {
            delegate?.setBarItem(text: "Next", disabled: false, hidden: false)
        }else{
            delegate?.setBarItem(text: "Next", disabled: true, hidden: false)
        }
        DispatchQueue.main.async {
            self.inputField.becomeFirstResponder()
        }
    }
    
    override func getValue() -> [String : String]? {
        if inputField.text.count > 0 {
            return [field:inputField.text]
        }
        return nil
    }
}

class EmojiButton:UIView {
    
    let required:Bool
    var value:String? = nil
    
    let label:UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = UIColor.appBlue
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        return l
    }()
    
    let emojiLabel:UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 80)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()
    
    init(required:Bool){
        self.required = required
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 75, y: 75), radius: 75, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        let shape = CAShapeLayer()
        shape.path = circularPath.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.appBlue.cgColor
        shape.strokeStart = 0
        shape.strokeEnd = 1
        shape.lineDashPattern = [18.5, 5]
        shape.lineWidth = 5
        layer.addSublayer(shape)
        
        
        let labelString = NSMutableAttributedString(string: "Select Emoji\n(\(required ? "Required" : "Optional"))")
        labelString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 20), range: NSRange(location: 0, length: 12))
        label.attributedText = labelString
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(emojiLabel)
        emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEmoji(_ emoji:String?){
        self.value = emoji
        if let e = emoji {
            emojiLabel.text = e
            emojiLabel.isHidden = false
            label.isHidden = true
        }else{
            emojiLabel.isHidden = true
            label.isHidden = false
        }
    }
}

class CreatePostEmojiController:CreatePostPageController, EmojiPickerDelegate {
    
    var currentSelection:EmojiButton? = nil
    var emojiButtons:[EmojiButton]!
    
    let label:UILabel = {
        let l = UILabel()
        l.text = "Select up to four emojis to use"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 30)
        l.textColor = UIColor.black
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 2
        return l
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        let spacingConstant = (UIScreen.main.bounds.width - (150 * 2)) / 3
        
        let emojiButton = EmojiButton(required: true)
        view.addSubview(emojiButton)
        emojiButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: spacingConstant).isActive = true
        emojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75).isActive = true
        emojiButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        emojiButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        let tapGestureRecongizer = UITapGestureRecognizer(target: self, action: #selector(emojiButtonClicked(_:)))
        emojiButton.addGestureRecognizer(tapGestureRecongizer)
        
        let emojiButton2 = EmojiButton(required: true)
        view.addSubview(emojiButton2)
        emojiButton2.leftAnchor.constraint(equalTo: emojiButton.rightAnchor, constant: spacingConstant).isActive = true
        emojiButton2.centerYAnchor.constraint(equalTo: emojiButton.centerYAnchor).isActive = true
        emojiButton2.widthAnchor.constraint(equalToConstant: 150).isActive = true
        emojiButton2.heightAnchor.constraint(equalToConstant: 150).isActive = true
        let tapGestureRecongizer2 = UITapGestureRecognizer(target: self, action: #selector(emojiButtonClicked(_:)))
        emojiButton2.addGestureRecognizer(tapGestureRecongizer2)
        
        let emojiButton3 = EmojiButton(required: false)
        view.addSubview(emojiButton3)
        emojiButton3.leftAnchor.constraint(equalTo: emojiButton.leftAnchor).isActive = true
        emojiButton3.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: spacingConstant).isActive = true
        emojiButton3.widthAnchor.constraint(equalToConstant: 150).isActive = true
        emojiButton3.heightAnchor.constraint(equalToConstant: 150).isActive = true
        let tapGestureRecongizer3 = UITapGestureRecognizer(target: self, action: #selector(emojiButtonClicked(_:)))
        emojiButton3.addGestureRecognizer(tapGestureRecongizer3)
        
        let emojiButton4 = EmojiButton(required: false)
        view.addSubview(emojiButton4)
        emojiButton4.leftAnchor.constraint(equalTo: emojiButton3.rightAnchor, constant: spacingConstant).isActive = true
        emojiButton4.topAnchor.constraint(equalTo: emojiButton2.bottomAnchor, constant: spacingConstant).isActive = true
        emojiButton4.widthAnchor.constraint(equalToConstant: 150).isActive = true
        emojiButton4.heightAnchor.constraint(equalToConstant: 150).isActive = true
        let tapGestureRecongizer4 = UITapGestureRecognizer(target: self, action: #selector(emojiButtonClicked(_:)))
        emojiButton4.addGestureRecognizer(tapGestureRecongizer4)
        
        emojiButtons = [emojiButton, emojiButton2, emojiButton3, emojiButton4]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setActive() {
        delegate?.setBarItem(text: "Next", disabled: true, hidden: false)
    }
    
    @objc
    func emojiButtonClicked(_ sender:UITapGestureRecognizer){
        currentSelection = sender.view as? EmojiButton
        let emojiPicker = EmojiPickerController()
        emojiPicker.delegate = self
        present(emojiPicker, animated: true, completion: nil)
    }
    
    func selectedEmoji(_ emoji: String) {
        currentSelection?.setEmoji(emoji)
        var satisfied = true
        for b in emojiButtons {
            if b.required {
                if b.value == nil {
                    satisfied = false
                }
            }
        }
        if satisfied {
            delegate?.setBarItem(text: "Next", disabled: false, hidden: false)
        }else{
            delegate?.setBarItem(text: "Next", disabled: true, hidden: false)
        }
    }
    
    override func getValue() -> [String : String]? {
        var dict:[String:String] = [:]
        var counter = 1
        for b in emojiButtons {
            if let emoji = b.value {
                dict["option\(counter)"] = emoji
                counter += 1
            }
        }
        return dict
    }
    
}

class CreatePostReviewController:CreatePostPageController, UITableViewDelegate, UITableViewDataSource {
    
    var data:[String:Any]? = nil
    
    let postButton:UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Post", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = UIColor.appBlue
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return b
    }()
    var postButtonBottomContraint:NSLayoutConstraint!
    
    let tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(QuestionPreviewCell.self, forCellReuseIdentifier: "questionPreview")
        tableView.register(TextEnterCell.self, forCellReuseIdentifier: "textEnter")
        return tableView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        postButton.addTarget(self, action: #selector(submitPost), for: .touchUpInside)
        view.addSubview(postButton)
        postButtonBottomContraint = postButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        postButtonBottomContraint.isActive = true
        postButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: postButton.topAnchor).isActive = true
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
    func keyboardWillShow(notification: Notification){
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        postButtonBottomContraint.constant = -(keyboardHeight ?? 0)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @objc
    func keyboardWillHide(){
        postButtonBottomContraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func setActive() {
        delegate?.setBarItem(text: "", disabled: true, hidden: true)
        data = delegate?.getData()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = data {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Question Preview"
        case 1:
            return "First Comment"
        case 2:
            return "Share"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 0) {
            return 125
        }else{
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionPreview") as! QuestionPreviewCell
            if let d = data {
                cell.setCell(postType: d["type"] as! PostType, question: d["question"] as! String)
            }
            return cell
        }else if indexPath.section == 1 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textEnter") as! TextEnterCell
            return cell
        }
        return UITableViewCell()
    }
    
    @objc
    func submitPost(){
        if let d = data {
            let question = d["question"] as! String
            let comment:String = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextEnterCell)?.getValue() ?? ""
            let postType:Int = PostType.toNum(d["type"]! as! PostType)
            var options:[String:[String]] = [:]
            if postType != 3 {
                var choices:[String] = []
                for i in 1...4 {
                    if let c = d["option\(i)"] as? String {
                        if c != "" {
                            choices.append(c)
                        }
                    }
                }
                options["choices"] = choices
            }
            let sendData:[String:Any] = ["question":question, "type":postType, "options":options, "comment":comment]
            Network.request(url: "https://api.tryflux.app/post", type: .post, paramters: sendData, auth: true) { (res, err) in
                if err != nil {
                    print(err)
                }else{
                    print(res["postID"] as! String)
                }
                self.delegate?.dismissPostController()
            }
        }
    }
    
}
