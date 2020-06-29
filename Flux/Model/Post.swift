//
//  Post.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import Foundation
import UIKit
import JWTDecode
class Post:Hashable, CustomStringConvertible{
    
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        if lhs.postID == rhs.postID {
            return true
        }
        return false
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(postID)
    }
    
    let postID:String
    var postType:PostType? = nil
    var fetched = false
    var question:String? = nil
    var timeStamp:String? = nil
    var user:String? = nil
    var answers:[Answer]? = nil
    var comments:[Comment] = []
    var choices:[String]? = nil
    var colors:[String]? = nil
    var profilePicture:UIImage? = nil
    
    init(postID:String) {
        self.postID = postID
    }
    
    func fetch(completion:@escaping () -> Void){
        Network.request(url: "https://api.tryflux.app/fetchPost?id="+postID, type: .get, paramters: nil, callback: { (response, error) in
            if let resPost = response["post"] as? [String:Any] {
                self.user = resPost["user"] as? String
                self.question = resPost["question"] as? String
                self.timeStamp = resPost["timestamp"] as? String
                if let postTypeNum = resPost["type"] as? Int {
                    self.postType = PostType.fromNum(postTypeNum)
                }else{
                    self.postType = nil
                }
                if let postOptions = resPost["options"] as? [String:[String]] {
                    self.choices = postOptions["choices"]
                    self.colors = postOptions["colors"]
                }
                self.answers = []
                if let resAnswers = resPost["answers"] as? [[String:Any]] {
                    for a in resAnswers {
                        let answer = Answer(a)
                        self.answers?.append(answer)
                    }
                }
                self.comments = []
                if let resComments = resPost["comments"] as? [[String:String]] {
                    for c in resComments {
                        let comment = Comment(c)
                        self.comments.append(comment)
                    }
                }
            }
            Network.downloadImage(user: self.user ?? "") { (image) in
                self.profilePicture = image
                self.fetched = true
                completion()
            }
        })
    }
    
    func answerOption(_ index:Int){
        print("Answering \(index)")
        Network.request(url: "https://api.tryflux.app/answer", type: .post, paramters: ["postID": postID, "answer": index], auth: true)
        answers?.append(Answer(user: Network.username ?? "", answer: index, timestamp: ""))
    }
    
    func getAnswers() -> [Int] {
        var trimedAnswers:[String:Int] = [:]
        for a in answers ?? [] {
            trimedAnswers[a.user] = a.answer
        }
        var finalAnswers:[Int] = []
        if (postType ?? .Option) == .Rating {
            for _ in 0...10 {
                finalAnswers.append(0)
            }
        }else{
            for _ in choices ?? [] {
                finalAnswers.append(0)
            }
        }
        for value in trimedAnswers.values {
            finalAnswers[value] += 1
        }
        return finalAnswers
    }
    
    func getAnswers(_ time:Date) -> [Int] {
        var filteredAnswers:[Answer] = []
        for a in answers ?? [] {
            let at = Date.UTCDate(date: a.timestamp)
            if at.timeIntervalSince1970 <= time.timeIntervalSince1970 {
                filteredAnswers.append(a)
                
            }
        }
        var trimedAnswers:[String:Int] = [:]
        for a in filteredAnswers {
            trimedAnswers[a.user] = a.answer
        }
        
        var finalAnswers:[Int] = []
        if (postType ?? .Option) == .Rating {
            for _ in 0...10 {
                finalAnswers.append(0)
            }
        }else{
            for _ in choices ?? [] {
                finalAnswers.append(0)
            }
        }
        for value in trimedAnswers.values {
            finalAnswers[value] += 1
        }
        return finalAnswers
    }
    func getRatingAverage() -> Float{
        let curAnswers = getAnswers()
        var sum = 0
        var totalAmount = 0
        for i in 0..<curAnswers.count {
            sum += (i * curAnswers[i])
            totalAmount += curAnswers[i]
        }
        var avg:Float = Float(sum) / Float(totalAmount)
        avg *= 10
        avg = roundf(avg)
        avg /= 10
        return avg
    }
    func getRatingAverage(_ time:Date) -> Float{
        let curAnswers = getAnswers(time)
        var sum = 0
        var totalAmount = 0
        for i in 0..<curAnswers.count {
            sum += (i * curAnswers[i])
            totalAmount += curAnswers[i]
        }
        if totalAmount == 0{
            return 0
        }
        var avg:Float = Float(sum) / Float(totalAmount)
        avg *= 10
        avg = roundf(avg)
        avg /= 10
        return avg
    }
    func getUsers(_ index:Int) -> [String] {
        var trimedAnswers:[String:Int] = [:]
        for a in answers ?? [] {
            trimedAnswers[a.user] = a.answer
        }
        var users:[String] = []
        for name in trimedAnswers.keys {
            if trimedAnswers[name] == index {
                users.append(name)
            }
        }
        return users
    }
    
    func didAnswer() -> Bool {
        for a in answers ?? [] {
            if a.user == Network.username ?? "" {
                return true
            }
        }
        return false
    }
    
    func invalidate(){
        fetched = false
    }
    
    var description: String {
        return "\(type(of: self))(Post ID: \(postID))"
    }
    
}

struct Answer {
    let user:String
    let answer:Int
    let timestamp:String
    init(_ answerDict:[String:Any]) {
        user = answerDict["username"] as! String
        answer = answerDict["answer"] as! Int
        timestamp = answerDict["time"] as! String
    }
    init(user: String, answer:Int, timestamp:String){
        self.user = user
        self.answer = answer
        self.timestamp = timestamp
    }
}
struct Comment {
    let user:String
    let comment:String
    let timestamp:String
    init(user:String, comment:String, timestamp:String){
        self.user = user
        self.comment = comment
        self.timestamp = timestamp
    }
    init(_ commentDict:[String:String]) {
        user = commentDict["user"] ?? ""
        comment = commentDict["comment"] ?? ""
        timestamp = commentDict["timestamp"] ?? ""
    }
}
enum PostState{
    case Question
    case Result
}
