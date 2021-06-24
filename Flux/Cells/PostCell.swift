//
//  PostCell.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    var post:Post!
    var delegate:PostDelegate? = nil
    
    let loadingView = LoadingView()
    let profilePicture:UIImageView = {
        let i = UIImageView()
        i.layer.cornerRadius = 20
        i.layer.masksToBounds = true
        i.translatesAutoresizingMaskIntoConstraints = false
        i.backgroundColor = UIColor(named: "GR")
        return i
    }()
    let usernameButton:UIButton = {
       let b = UIButton()
        b.setTitleColor(UIColor(named: "FG"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return b
    }()
    
    let timestampLabel:UILabel = {
        let l = UILabel()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .right
        return l
    }()
    
    let refreshButton:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "refresh").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = UIColor.appBlue
        return b
    }()
    
    let headerDivider:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "GR")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let startView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let endView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    /* Question View Start*/
    let questionView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let questionLabel:UILabel = {
        let l = UILabel()
        l.textColor = UIColor(named: "FG")
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .center
        return l
    }()
    
    let answerStackView:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .fill
        s.distribution = .fillEqually
        s.axis = .vertical
        s.spacing = 8
        return s
    }()
    
    func answerButton() -> UIButton {
        let b = UIButton()
        b.setTitle("Answer", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.backgroundColor = UIColor.appBlue
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 25
        return b
    }
    /* Question View End*/
    
    /* Emoji Question View Start */
    let emojiQuestionView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let emojiQuestionLabel:UILabel = {
        let l = UILabel()
        l.textColor = UIColor(named: "FG")
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .center
        return l
    }()
    
    let emojiVerticalStackView:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .center
        s.distribution = .equalCentering
        s.axis = .vertical
        s.spacing = 8
        return s
    }()
    
    func emojiHorizStackView() -> UIStackView {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .center
        s.distribution = .equalCentering
        s.axis = .horizontal
        s.spacing = 8
        s.heightAnchor.constraint(greaterThanOrEqualToConstant: 75).isActive = true
//        s.heightAnchor.constraint(equalToConstant: 125).isActive = true
//        let debugView = UIView()
//        debugView.backgroundColor = UIColor.red
//        debugView.translatesAutoresizingMaskIntoConstraints = false
//        s.addSubview(debugView)
//        debugView.topAnchor.constraint(equalTo: s.topAnchor).isActive = true
//        debugView.bottomAnchor.constraint(equalTo: s.bottomAnchor).isActive = true
//        debugView.leftAnchor.constraint(equalTo: s.leftAnchor).isActive = true
//        debugView.rightAnchor.constraint(equalTo: s.rightAnchor).isActive = true
        return s
    }
    
    func emojiAnswerButton() -> UIButton {
        let b = UIButton()
        b.setTitle("Answer", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 60)
        b.backgroundColor = UIColor.appBlue
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 62.5
        return b
    }
    
    /* Emoji Question View End */
    
    /* Rating Question View Start */
    let ratingQuestionView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let ratingQuestionLabel:UILabel = {
        let l = UILabel()
        l.textColor = UIColor(named: "FG")
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .center
        return l
    }()
    
    let ratingControl:RatingControl = {
        let r = RatingControl(frame: CGRect.zero)
        r.translatesAutoresizingMaskIntoConstraints = false
        
        return r
    }()
    
    let ratingAnswerButton:UIButton = {
        let b = UIButton()
        b.setTitle("Submit Answer", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        b.backgroundColor = UIColor.appBlue
        b.layer.cornerRadius = 25
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let ratingResultView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let ratingAnswerLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.textAlignment = .center
        return l
    }()
    
    let ratingGraph = RatingResultView()
    
    /* Rating Question View End */
    
    let answerView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let questionAnswerLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.lineBreakMode = .byTruncatingTail
        l.textAlignment = .center
        return l
    }()
    
    func createDot(_ index:Int) -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 8
        v.widthAnchor.constraint(equalToConstant: 16).isActive = true
        v.heightAnchor.constraint(equalToConstant: 16).isActive = true
        switch index {
        case 0:
            v.backgroundColor = UIColor.appBlue
            break
        case 1:
            v.backgroundColor = UIColor.appGreen
            break
        case 2:
            v.backgroundColor = UIColor.red
            break
        default:
            v.backgroundColor = UIColor.purple
        }
        return v
    }
    func createAnswerLabel(_ index:Int) -> UILabel {
        let l = UILabel()
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 1
        if index == 0 || index == 1 {
            l.textAlignment = .right
        }else{
            l.textAlignment = .left
        }
        return l
    }
    
    let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
    func createCircle(_ index:Int) -> CAShapeLayer {
        let circle = CAShapeLayer()
        circle.path = circularPath.cgPath
        circle.lineWidth = 50
        circle.fillColor = UIColor.clear.cgColor
        switch index {
        case 0:
            circle.strokeColor = UIColor.appBlue.cgColor
            circle.strokeStart = 0
            circle.strokeEnd = 0.25
            break
        case 1:
            circle.strokeColor = UIColor.appGreen.cgColor
            circle.strokeStart = 0.25
            circle.strokeEnd = 0.5
            break
        case 2:
            circle.strokeColor = UIColor.red.cgColor
            circle.strokeStart = 0.5
            circle.strokeEnd = 0.75
            break
        default:
            circle.strokeColor = UIColor.purple.cgColor
            circle.strokeStart = 0.75
            circle.strokeEnd = 1
        }
        return circle
    }
    func createLineLayer() -> CAShapeLayer{
        let shape = CAShapeLayer()
        shape.strokeColor = UIColor.lightGray.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 2
        shape.lineJoin = .round
        shape.lineCap = .round
        return shape
    }
    func createLine(index:Int, progress:Float, frame:CGRect) -> UIBezierPath{
        let path = UIBezierPath()
        var startPoint = CGPoint()
        switch index {
        case 0:
            startPoint.x = frame.width - 24
            startPoint.y = 24 + 58
            break
        case 1:
            startPoint.x = frame.width - 24
            startPoint.y = frame.height - 24
            break
        case 2:
            startPoint.x = 24
            startPoint.y = frame.height - 24
            break
        default:
            startPoint.x = 24
            startPoint.y = 24 + 58
            break
        }
        var extensionPoint = CGPoint(x: startPoint.x, y: startPoint.y)
        if index == 0 || index == 3 {
            extensionPoint.y += (frame.midY - 24) * 0.5
        }else{
            extensionPoint.y -= (frame.midY - 24) * 0.5
        }
        let circleRadius:CGFloat = 80
        let adjustedProgress:CGFloat = CGFloat(progress) - 0.25
        let angle = adjustedProgress * CGFloat.pi * 2
        var circlePoint = CGPoint(x: circleRadius * cos(angle), y: circleRadius * sin(angle))
        circlePoint.x += frame.midX
        circlePoint.y += frame.midY + 29
        path.move(to: startPoint)
        path.addLine(to: extensionPoint)
        path.addLine(to: circlePoint)
        return path
    }
    
    let graphView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let shareButton:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "share").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = UIColor.appBlue
        return b
    }()
    
    let changeAnswerButton:UIButton = {
        let b = UIButton()
        b.setTitle("Change Answer", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        b.setTitleColor(UIColor.white, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 15
        b.backgroundColor = UIColor.appBlue
        return b
    }()
    
    let commentButton:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = UIColor.appBlue
        return b
    }()
    
    let bottomDivider:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "GR")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var answerButtons:[UIButton] = []
    var emojiAnswerButtons:[UIButton] = []
    var dots:[UIView] = []
    var answerLabels:[UILabel] = []
    var circles:[CAShapeLayer] = []
    var lines:[CAShapeLayer] = []
    var pageAnchor:NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "BG")
        contentView.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        profilePicture.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameButton.addTarget(self, action: #selector(usernameClicked), for: .touchUpInside)
        contentView.addSubview(usernameButton)
        usernameButton.setTitle("Username", for: .normal)
        usernameButton.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 12).isActive = true
        usernameButton.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        
        contentView.addSubview(timestampLabel)
        timestampLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        timestampLabel.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
   
        contentView.addSubview(headerDivider)
        headerDivider.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 8).isActive = true
        headerDivider.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        headerDivider.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        headerDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentView.addSubview(bottomDivider)
        bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomDivider.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bottomDivider.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        bottomDivider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        refreshButton.addTarget(self, action: #selector(refreshPost), for: .touchUpInside)
        contentView.addSubview(refreshButton)
        refreshButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(changeAnswerButton)
        changeAnswerButton.addTarget(self, action: #selector(changedAnswerButtonClicked), for: .touchUpInside)
        changeAnswerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        changeAnswerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        changeAnswerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        changeAnswerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        commentButton.addTarget(self, action: #selector(commentsClicked), for: .touchUpInside)
        contentView.addSubview(commentButton)
        commentButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        commentButton.bottomAnchor.constraint(equalTo: bottomDivider.topAnchor, constant: -8).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        shareButton.addTarget(self, action: #selector(sharePost), for: .touchUpInside)
        contentView.addSubview(shareButton)
        shareButton.leftAnchor.constraint(equalTo: commentButton.rightAnchor, constant: 8).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: bottomDivider.topAnchor, constant: -8).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(startView)
        startView.topAnchor.constraint(equalTo: headerDivider.bottomAnchor, constant: 16).isActive = true
        startView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -16).isActive = true
        pageAnchor = startView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        pageAnchor.isActive = true
        startView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        startView.addSubview(questionView)
        questionView.topAnchor.constraint(equalTo: startView.topAnchor).isActive = true
        questionView.bottomAnchor.constraint(equalTo: startView.bottomAnchor).isActive = true
        questionView.leftAnchor.constraint(equalTo: startView.leftAnchor).isActive = true
        questionView.rightAnchor.constraint(equalTo: startView.rightAnchor).isActive = true
        
        
        for i in 0..<4{
            let answer = answerButton()
            answer.tag = i
            answerButtons.append(answer)
            answerStackView.addArrangedSubview(answer)
            answer.addTarget(self, action: #selector(answerButtonClicked(_:)), for: .touchUpInside)
        }
        
        questionView.addSubview(answerStackView)
        answerStackView.bottomAnchor.constraint(equalTo: questionView.bottomAnchor).isActive = true
        answerStackView.centerXAnchor.constraint(equalTo: questionView.centerXAnchor).isActive = true
        answerStackView.widthAnchor.constraint(equalTo: questionView.widthAnchor, multiplier: 0.8).isActive = true
        answerStackView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        
        questionView.addSubview(questionLabel)
        questionLabel.text = "Hello this is my question. how are you"
        questionLabel.topAnchor.constraint(equalTo: questionView.topAnchor).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: questionView.leftAnchor, constant: 8).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: questionView.rightAnchor, constant: -8).isActive = true
        questionLabel.bottomAnchor.constraint(equalTo: answerStackView.topAnchor, constant: -16).isActive = true
        
        startView.addSubview(emojiQuestionView)
        emojiQuestionView.topAnchor.constraint(equalTo: startView.topAnchor).isActive = true
        emojiQuestionView.bottomAnchor.constraint(equalTo: startView.bottomAnchor).isActive = true
        emojiQuestionView.leftAnchor.constraint(equalTo: startView.leftAnchor).isActive = true
        emojiQuestionView.rightAnchor.constraint(equalTo: startView.rightAnchor).isActive = true
        
        emojiQuestionView.addSubview(emojiQuestionLabel)
        emojiQuestionLabel.topAnchor.constraint(equalTo: emojiQuestionView.topAnchor).isActive = true
        emojiQuestionLabel.leftAnchor.constraint(equalTo: emojiQuestionView.leftAnchor, constant: 8).isActive = true
        emojiQuestionLabel.rightAnchor.constraint(equalTo: emojiQuestionView.rightAnchor, constant: -8).isActive = true
        
        emojiQuestionView.addSubview(emojiVerticalStackView)
        emojiVerticalStackView.bottomAnchor.constraint(equalTo: emojiQuestionView.bottomAnchor).isActive = true
        emojiVerticalStackView.leftAnchor.constraint(equalTo: emojiQuestionView.leftAnchor).isActive = true
        emojiVerticalStackView.rightAnchor.constraint(equalTo: emojiQuestionView.rightAnchor).isActive = true
//        emojiVerticalStackView.heightAnchor.constraint(equalToConstant: 258).isActive = true
        
        var horizEmojiStackViews:[UIStackView] = []
        
        for _ in 0..<2 {
            let stack = emojiHorizStackView()
            emojiVerticalStackView.addArrangedSubview(stack)
            horizEmojiStackViews.append(stack)
        }
        
        for i in 0..<4 {
            let emojiAnswer = emojiAnswerButton()
            emojiAnswer.tag = i
            emojiAnswerButtons.append(emojiAnswer)
            emojiAnswer.addTarget(self, action: #selector(answerButtonClicked(_:)), for: .touchUpInside)
            emojiAnswer.widthAnchor.constraint(equalToConstant: 125).isActive = true
            emojiAnswer.heightAnchor.constraint(equalToConstant: 125).isActive = true
            if i == 0 || i == 1{
                horizEmojiStackViews[0].addArrangedSubview(emojiAnswer)
            }else if i == 2 || i == 3 {
                horizEmojiStackViews[1].addArrangedSubview(emojiAnswer)
            }
        }
        
        startView.addSubview(ratingQuestionView)
        ratingQuestionView.topAnchor.constraint(equalTo: startView.topAnchor).isActive = true
        ratingQuestionView.bottomAnchor.constraint(equalTo: startView.bottomAnchor).isActive = true
        ratingQuestionView.leftAnchor.constraint(equalTo: startView.leftAnchor).isActive = true
        ratingQuestionView.rightAnchor.constraint(equalTo: startView.rightAnchor).isActive = true
        
        ratingQuestionView.addSubview(ratingQuestionLabel)
        ratingQuestionLabel.topAnchor.constraint(equalTo: ratingQuestionView.topAnchor).isActive = true
        ratingQuestionLabel.leftAnchor.constraint(equalTo: ratingQuestionView.leftAnchor, constant: 8).isActive = true
        ratingQuestionLabel.rightAnchor.constraint(equalTo: ratingQuestionView.rightAnchor, constant: -8).isActive = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: nil)
        panGesture.cancelsTouchesInView = false
        ratingControl.addGestureRecognizer(panGesture)
        ratingQuestionView.addSubview(ratingControl)
        ratingControl.centerXAnchor.constraint(equalTo: ratingQuestionView.centerXAnchor).isActive = true
        ratingControl.centerYAnchor.constraint(equalTo: ratingQuestionView.centerYAnchor).isActive = true
        ratingControl.widthAnchor.constraint(equalTo: ratingQuestionView.widthAnchor, multiplier: 0.85).isActive = true
        ratingControl.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        ratingAnswerButton.addTarget(self, action: #selector(answerButtonClicked(_:)), for: .touchUpInside)
        ratingQuestionView.addSubview(ratingAnswerButton)
        ratingAnswerButton.topAnchor.constraint(equalTo: ratingControl.bottomAnchor, constant: 24).isActive = true
        ratingAnswerButton.centerXAnchor.constraint(equalTo: questionView.centerXAnchor).isActive = true
        ratingAnswerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ratingAnswerButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        contentView.addSubview(endView)
        endView.topAnchor.constraint(equalTo: headerDivider.bottomAnchor, constant: 16).isActive = true
        endView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -16).isActive = true
        endView.leftAnchor.constraint(equalTo: startView.rightAnchor).isActive = true
        endView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        endView.addSubview(ratingResultView)
        ratingResultView.topAnchor.constraint(equalTo: endView.topAnchor).isActive = true
        ratingResultView.bottomAnchor.constraint(equalTo: endView.bottomAnchor).isActive = true
        ratingResultView.leftAnchor.constraint(equalTo: endView.leftAnchor).isActive = true
        ratingResultView.rightAnchor.constraint(equalTo: endView.rightAnchor).isActive = true
        
        ratingResultView.addSubview(ratingAnswerLabel)
        ratingAnswerLabel.topAnchor.constraint(equalTo: ratingResultView.topAnchor).isActive = true
        ratingAnswerLabel.leftAnchor.constraint(equalTo: ratingResultView.leftAnchor, constant: 8).isActive = true
        ratingAnswerLabel.rightAnchor.constraint(equalTo: ratingResultView.rightAnchor, constant: -8).isActive = true
        
        ratingResultView.addSubview(ratingGraph)
        ratingGraph.centerXAnchor.constraint(equalTo: ratingResultView.centerXAnchor).isActive = true
        ratingGraph.centerYAnchor.constraint(equalTo: ratingResultView.centerYAnchor).isActive = true
        
        endView.addSubview(answerView)
        answerView.topAnchor.constraint(equalTo: endView.topAnchor).isActive = true
        answerView.bottomAnchor.constraint(equalTo: endView.bottomAnchor).isActive = true
        answerView.leftAnchor.constraint(equalTo: endView.leftAnchor).isActive = true
        answerView.rightAnchor.constraint(equalTo: endView.rightAnchor).isActive = true
        
        answerView.addSubview(questionAnswerLabel)
        questionAnswerLabel.topAnchor.constraint(equalTo: answerView.topAnchor, constant: 0).isActive = true
        questionAnswerLabel.leftAnchor.constraint(equalTo: answerView.leftAnchor, constant: 4).isActive = true
        questionAnswerLabel.rightAnchor.constraint(equalTo: answerView.rightAnchor, constant: -4).isActive = true
        questionAnswerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let dot0 = createDot(0)
        answerView.addSubview(dot0)
        dot0.topAnchor.constraint(equalTo: questionAnswerLabel.bottomAnchor, constant: 8).isActive = true
        dot0.rightAnchor.constraint(equalTo: answerView.rightAnchor, constant: -16).isActive = true
        
        let answerLabel0 = createAnswerLabel(0)
        answerView.addSubview(answerLabel0)
        answerLabel0.rightAnchor.constraint(equalTo: dot0.leftAnchor, constant: -8).isActive = true
        answerLabel0.leftAnchor.constraint(equalTo: answerView.centerXAnchor, constant: 8).isActive = true
        answerLabel0.centerYAnchor.constraint(equalTo: dot0.centerYAnchor).isActive = true
        
        let dot1 = createDot(1)
        answerView.addSubview(dot1)
        dot1.bottomAnchor.constraint(equalTo: answerView.bottomAnchor).isActive = true
        dot1.rightAnchor.constraint(equalTo: answerView.rightAnchor, constant: -16).isActive = true
        
        let answerLabel1 = createAnswerLabel(1)
        answerView.addSubview(answerLabel1)
        answerLabel1.rightAnchor.constraint(equalTo: dot1.leftAnchor, constant: -8).isActive = true
        answerLabel1.leftAnchor.constraint(equalTo: answerView.centerXAnchor, constant: 8).isActive = true
        answerLabel1.centerYAnchor.constraint(equalTo: dot1.centerYAnchor).isActive = true
        
        let dot2 = createDot(2)
        answerView.addSubview(dot2)
        dot2.bottomAnchor.constraint(equalTo: answerView.bottomAnchor).isActive = true
        dot2.leftAnchor.constraint(equalTo: answerView.leftAnchor, constant: 16).isActive = true
        
        let answerLabel2 = createAnswerLabel(2)
        answerView.addSubview(answerLabel2)
        answerLabel2.leftAnchor.constraint(equalTo: dot2.rightAnchor, constant: 8).isActive = true
        answerLabel2.rightAnchor.constraint(equalTo: answerView.centerXAnchor, constant: -8).isActive = true
        answerLabel2.centerYAnchor.constraint(equalTo: dot2.centerYAnchor).isActive = true
        
        let dot3 = createDot(3)
        answerView.addSubview(dot3)
        dot3.topAnchor.constraint(equalTo: questionAnswerLabel.bottomAnchor, constant: 8).isActive = true
        dot3.leftAnchor.constraint(equalTo: answerView.leftAnchor, constant: 16).isActive = true
        
        let answerLabel3 = createAnswerLabel(3)
        answerView.addSubview(answerLabel3)
        answerLabel3.leftAnchor.constraint(equalTo: dot3.rightAnchor, constant: 8).isActive = true
        answerLabel3.rightAnchor.constraint(equalTo: answerView.centerXAnchor, constant: -8).isActive = true
        answerLabel3.centerYAnchor.constraint(equalTo: dot3.centerYAnchor).isActive = true
        
        dots = [dot0, dot1, dot2, dot3]
        answerLabels = [answerLabel0, answerLabel1, answerLabel2, answerLabel3]
        
        answerView.addSubview(graphView)
        graphView.topAnchor.constraint(equalTo: answerView.centerYAnchor, constant: 29).isActive = true
        graphView.leftAnchor.constraint(equalTo: answerView.centerXAnchor).isActive = true
        
        for i in 0..<4 {
            let circle = createCircle(i)
            graphView.layer.addSublayer(circle)
            circles.append(circle)
        }
        
        for _ in 0..<4 {
            let lineLayer = createLineLayer()
            answerView.layer.addSublayer(lineLayer)
            lines.append(lineLayer)
        }
        
    }
    
    
    func setPost(_ post:Post){
        self.post = post
        update()
    }
    
    func update(){
        if !post.fetched {
            showLoadingView()
            return
        }else{
            hideLoadingView()
        }
        if let t = post.postType {
            if t == .Option || t == .YesNo {
                emojiQuestionView.isHidden = true
                ratingQuestionView.isHidden = true
                ratingResultView.isHidden = true
                questionView.isHidden = false
                answerView.isHidden = false
            }else if t == .Emoji {
                questionView.isHidden = true
                ratingQuestionView.isHidden = true
                ratingResultView.isHidden = true
                emojiQuestionView.isHidden = false
                answerView.isHidden = false
            }else if t == .Rating {
                questionView.isHidden = true
                emojiQuestionView.isHidden = true
                answerView.isHidden = true
                ratingQuestionView.isHidden = false
                ratingResultView.isHidden = false
            }
        }
        usernameButton.setTitle(post.user ?? "", for: .normal)
        questionLabel.text = post.question ?? ""
        questionAnswerLabel.text = post.question ?? ""
        emojiQuestionLabel.text = post.question ?? ""
        ratingQuestionLabel.text = post.question ?? ""
        ratingAnswerLabel.text = post.question ?? ""
        ratingControl.setRatingValue(val: 5)
        profilePicture.image = post.profilePicture
        let date = Date.UTCDate(date: post.timeStamp!)
        timestampLabel.text = Date.elapsedTime(date: date)
        let answers = post.choices ?? []
        for i in 0..<4 {
            if i + 1 > answers.count {
                answerButtons[i].isUserInteractionEnabled = false
                answerButtons[i].isHidden = true
                emojiAnswerButtons[i].isUserInteractionEnabled = false
                emojiAnswerButtons[i].isHidden = true
                dots[i].isHidden = true
                answerLabels[i].isHidden = true
            }else{
                answerButtons[i].isUserInteractionEnabled = true
                answerButtons[i].isHidden = false
                emojiAnswerButtons[i].isUserInteractionEnabled = true
                emojiAnswerButtons[i].isHidden = false
                answerButtons[i].setTitle(answers[i], for: .normal)
                emojiAnswerButtons[i].setTitle(answers[i], for: .normal)
                dots[i].isHidden = false
                answerLabels[i].isHidden = false
                answerLabels[i].text = answers[i]
            }
        }
        updatePieChart(answers: post.getAnswers())
        updateRatingChart(avg: post.getRatingAverage())
        changeAnswerButton.isUserInteractionEnabled = false
        changeAnswerButton.alpha = 0
        if post.didAnswer() {
            switchPage(1, animated: false)
        }else{
            switchPage(0, animated: false)
        }
    }
    
    @objc
    func answerButtonClicked(_ sender:UIButton) {
        var answerOption = sender.tag
        if (post.postType ?? .Option) == .Rating {
            answerOption = ratingControl.getValue()
        }
        post.answerOption(answerOption)
        updatePieChart(answers: post.getAnswers())
        updateRatingChart(avg: post.getRatingAverage())
        switchPage(1)
    }
    @objc
    func changedAnswerButtonClicked(){
        switchPage(0)
    }
    @objc
    func usernameClicked(){
        if let user = post.user {
            delegate?.openProfile(for: user)
        }
    }
    @objc
    func commentsClicked(){
        delegate?.openComments(for: post.postID)
    }
    @objc
    func refreshPost(){
        delegate?.refreshPost(for: post.postID)
    }
    @objc
    func sharePost(){
        delegate?.sharePost(for: post.postID)
    }
    
    func switchPage(_ index:Int, animated:Bool = true) {
        if index == 0 {
            pageAnchor.constant = 0
            changeAnswerButton.isUserInteractionEnabled = false
        }else{
            pageAnchor.constant = -UIScreen.main.bounds.width
            changeAnswerButton.isUserInteractionEnabled = true
        }
        UIView.animate(withDuration: animated ? 0.3 : 0, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.layoutIfNeeded()
            self.changeAnswerButton.alpha = index == 0 ? 0 : 1
        }, completion: { (_) in
            self.updatePieChart(answers: self.post.getAnswers())
            self.updateRatingChart(avg: self.post.getRatingAverage())
        })
    }
    
    func showLoadingView(){
        loadingView.startAnimation()
        contentView.addSubview(loadingView)
        loadingView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: bottomDivider.topAnchor).isActive = true
        loadingView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 1
        }, completion: nil)
    }
    func hideLoadingView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 0
        }) { (c) in
            self.loadingView.removeFromSuperview()
            self.loadingView.endAnimation()
        }
    }
    
    func updateRatingChart(avg:Float){
        ratingGraph.updateValue(avg: avg)
    }
    
    func updatePieChart(answers:[Int]){
        let totalAnswers = CGFloat(answers.reduce(0, +))
        var startPoint:CGFloat = 0
        for i in 0..<4 {
            if i > answers.count - 1 || totalAnswers == 0 {
                circles[i].strokeStart = 0
                circles[i].strokeEnd = 0
                continue
            }
            circles[i].strokeStart = startPoint
            let distance = CGFloat(answers[i]) / totalAnswers
            startPoint += distance
            circles[i].strokeEnd = startPoint
        }
        for i in 0..<4 {
            if i > answers.count - 1 || answers[i] == 0 {
                lines[i].path = nil
                continue
            }
            let startProgress = Float(circles[i].strokeStart)
            let endProgress = Float(circles[i].strokeEnd)
            var adjustedProgress = ((endProgress - startProgress) / 2) + startProgress
            if answers[i] == Int(totalAnswers) {
                if i == 0 || i == 1 {
                    adjustedProgress = 0.25
                }else{
                    adjustedProgress = 0.75
                }
            }
            let path = createLine(index: i, progress: adjustedProgress, frame: CGRect(x: 0, y: 0, width: answerView.bounds.width, height: answerView.bounds.height))
            lines[i].path = path.cgPath
            
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
