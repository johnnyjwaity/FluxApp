//
//  BubbleCell.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class BubbleCell: UICollectionViewCell {
    
    var delegate:BubbleDelegate? = nil
    
    fileprivate let message:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hellow World"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    fileprivate let bubble:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let iconView:UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var iconLeft:NSLayoutConstraint!
    fileprivate var iconRight:NSLayoutConstraint!
    
    fileprivate var bubbleLeft:NSLayoutConstraint!
    fileprivate var bubbleRight:NSLayoutConstraint!
    fileprivate var bubbleWidth:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        addSubview(iconView)
        iconLeft = iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        iconRight = iconView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconLeft.isActive = true
        
        addSubview(bubble)
        bubble.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubble.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bubbleLeft = bubble.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 8)
        bubbleRight = bubble.rightAnchor.constraint(equalTo: iconView.leftAnchor, constant: -8)
        bubbleWidth = bubble.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidth.isActive = true
        bubbleLeft.isActive = true
        
        bubble.addSubview(message)
        message.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8).isActive = true
        message.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8).isActive = true
        message.leftAnchor.constraint(equalTo: bubble.leftAnchor, constant: 10).isActive = true
        message.rightAnchor.constraint(equalTo: bubble.rightAnchor, constant: -10).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBubble(_:)))
        message.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBubble(_ m:TextMessage) {
        let text = m.message.highlightUsers(underline: true)
        text.addAttributes([.font: UIFont.systemFont(ofSize: 18)], range: NSRange(location: 0, length: m.message.count))
        text.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: m.message.count))
        message.attributedText = text
        switch m.style {
        case .mine:
            iconLeft.isActive = false
            iconRight.isActive = true
            bubbleLeft.isActive = false
            bubbleRight.isActive = true
            bubble.backgroundColor = UIColor.appBlue
            message.textColor = UIColor.white
            break
        case .other:
            iconRight.isActive = false
            iconLeft.isActive = true
            bubbleRight.isActive = false
            bubbleLeft.isActive = true
            bubble.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            message.textColor = UIColor.black
            break
        }
        
        let size = CGSize(width: 250 - 20, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrame = NSString(string: m.message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        bubbleWidth.constant = estimatedFrame.width + 22
        iconView.image = #imageLiteral(resourceName: "profilePlaceholder")
        Network.downloadImage(user: m.user) { (image) in
            if let i = image {
                self.iconView.image = i
            }else{
                self.iconView.image = #imageLiteral(resourceName: "profilePlaceholder")
            }
        }
    }
    
    @objc
    func tappedBubble(_ gesture:UITapGestureRecognizer) {
        let location = gesture.location(in: message)
        let tapPosition = message.indexOfAttributedTextCharacterAtPoint(point: location)
        let str = message.attributedText?.string ?? ""
        let ranges = str.getUserRanges()
        for range in ranges {
            if range.contains(tapPosition) {
                var username = str[range]
                username.removeFirst()
                delegate?.openProfileLink(username)
                print("Clicked \(username)")
                break
            }
        }
    }
    
}

protocol BubbleDelegate {
    func openProfileLink(_ username:String)
}
