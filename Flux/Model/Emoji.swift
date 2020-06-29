//
//  Emoji.swift
//  Flux
//
//  Created by Johnny Waity on 4/8/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import Foundation
import UIKit

class Emoji {
    
    static let emojiColors:[CGColor] = [UIColor(red: 1, green: 220/255, blue: 93/255, alpha: 1).cgColor, UIColor(red: 247/255, green: 222/255, blue: 206/255, alpha: 1).cgColor, UIColor(red: 243/255, green: 210/255, blue: 162/255, alpha: 1).cgColor, UIColor(red: 213/255, green: 171/255, blue: 136/255, alpha: 1).cgColor, UIColor(red: 175/255, green: 126/255, blue: 87/255, alpha: 1).cgColor, UIColor(red: 124/255, green: 83/255, blue: 62/255, alpha: 1).cgColor]
    
    static let skinColors:[Unicode.Scalar] = [Unicode.Scalar(Int("1F3FB", radix: 16)!)!, Unicode.Scalar(Int("1F3FC", radix: 16)!)!, Unicode.Scalar(Int("1F3FD", radix: 16)!)!, Unicode.Scalar(Int("1F3FE", radix: 16)!)!, Unicode.Scalar(Int("1F3FF", radix: 16)!)!]
    
    static var emojis:[Emoji] = []
    
    static func loadEmojis() {
        var validEmojis:[Emoji] = []
        var tempEmojis:[Emoji] = []
        let file = "emoji"
        if let path = Bundle.main.path(forResource: file, ofType: "csv"){
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                for l in lines {
                    if l.count > 0 {
                        let emoji = Emoji(dataString: l)
                        tempEmojis.append(emoji)
                    }
                }
                for e in tempEmojis {
                    var isSkinVarient = false
                    for c in e.codes {
                        if skinColors.contains(c) {
                            isSkinVarient = true
                        }
                    }
                    if isSkinVarient {
                        if let last = validEmojis.last {
                            last.hasSkinVarients = true
                        }
                    }else{
                        validEmojis.append(e)
                    }
                }
                self.emojis = validEmojis
            } catch {
                print(error)
            }
        }
    }
    
    let emojiString:String
    let codes:[Unicode.Scalar]
    let name:String
    let category:String
    var hasSkinVarients = false
    
    init(dataString:String) {
        let components = dataString.components(separatedBy: ",")
        emojiString = components[0]
        name = components[1]
        category = components[2]
        let codeParts = components[4].components(separatedBy: " ")
        var tempArr:[Unicode.Scalar] = []
        for c in codeParts {
            if let num = Int(c, radix: 16) {
                if let scalar = Unicode.Scalar(num) {
                    tempArr.append(scalar)
                }
            }
        }
        codes = tempArr
    }
    
    func generateEmoji(skinColor:Int=0) -> String{
        var newCodes:[Unicode.Scalar] = []
        newCodes.append(contentsOf: codes)
        if skinColor != 0 {
            newCodes.insert(Emoji.skinColors[skinColor - 1], at: 1)
        }
        let unicodeScalarView = String.UnicodeScalarView(newCodes)
        let newString = String(unicodeScalarView)
        return newString
    }
}
