//
//  EmojiCell.swift
//  Flux
//
//  Created by Johnny Waity on 4/9/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    
    var emoji:Emoji? = nil
    
    let emojiLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 40)
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        emojiLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        emojiLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        emojiLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEmoji(_ emoji:Emoji){
        emojiLabel.text = emoji.generateEmoji()
        self.emoji = emoji
    }
    
}
