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
class Post:Hashable{
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
    let type:PostType
    var amount:Int? = nil
    var fetched = false
    
    var question:String? = nil
    var timeStamp:String? = nil
    var user:String? = nil
    var answers:[Answer]? = nil
    var comments:[Comment] = []
    var choices:[String]? = nil
    var colors:[String]? = nil
    var profilePicture:UIImage? = nil
    
    init(postID:String, type:PostType) {
        self.postID = postID
        self.type = type
    }
    
    func fetch(completion:@escaping () -> Void){
        Network.request(url: "https://api.tryflux.app:3000/fetchPost?id="+postID, type: .get, paramters: nil, callback: { (response, error) in
            let rPost:[String:Any] = response["post"] as! [String:Any]
            self.question = (rPost["question"]! as! String)
            self.timeStamp = (rPost["timestamp"]! as! String)
            self.user = (rPost["user"]! as! String)
            self.answers = []
            let rawAnswers = (rPost["answers"]! as! [[String:Any]])
            for a in rawAnswers {
                self.answers?.append(Answer(a))
            }
            self.comments = []
            if let cs = rPost["comments"] as? [[String: String]] {
                for c in cs {
                    guard let user = c["user"] else {continue}
                    guard let comment = c["comment"] else {continue}
                    guard var timestamp = c["timestamp"] else {continue}
                    timestamp = Date.UTCToLocal(date: timestamp)
                    self.comments.append(Comment(user: user, comment: comment, timestamp: timestamp))
                }
            }
            if self.type == .Option {
                let options = (rPost["options"]! as! [String:Any])
                self.choices = (options["choices"]! as! [String])
                self.colors = (options["colors"]! as! [String])
            }
            self.fetched = true
//            print(rPost)
            Network.downloadImage(user: self.user!, callback: { (image) in
                self.profilePicture = image
                completion()
            })
            
        })
    }
    
    func answerOption(_ index:Int){
        Network.request(url: "https://api.tryflux.app:3000/answer", type: .post, paramters: ["postID": postID, "answer": index], auth: true)
        var username:String? = nil
        do{
            let jwt = try decode(jwt: Network.authToken!)
            username = (jwt.body["uID"] as! String)
        }catch{
            print(error)
        }
        if let u = username {
            answers?.append(Answer(["username": u, "answer": index, "time": ""]))
        }
    }
    
    func getAnswers() -> [Int] {
        var trimedAnswers:[String:Int] = [:]
        for a in answers ?? [] {
            trimedAnswers[a.user] = a.answer
        }
        var finalAnswers:[Int] = []
        for _ in choices ?? [] {
            finalAnswers.append(0)
        }
        for value in trimedAnswers.values {
            finalAnswers[value] += 1
        }
        return finalAnswers
    }
    
    func getAnswers(_ time:Date) -> [Int] {
        var filteredAnswers:[Answer] = []
        for a in answers ?? [] {
            let at = Date.fromStamp(a.timestamp)
            if at.timeIntervalSince1970 <= time.timeIntervalSince1970 {
                filteredAnswers.append(a)
            }
        }
        var trimedAnswers:[String:Int] = [:]
        for a in filteredAnswers {
            trimedAnswers[a.user] = a.answer
        }
        
        var finalAnswers:[Int] = []
        for _ in choices ?? [] {
            finalAnswers.append(0)
        }
        for value in trimedAnswers.values {
            print("value \(value)")
            finalAnswers[value] += 1
        }
        return finalAnswers
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
        var username:String? = nil
        do{
            let jwt = try decode(jwt: Network.authToken!)
            username = (jwt.body["uID"] as! String)
        }catch{
            print(error)
        }
        if let u = username {
            for a in answers ?? [] {
                if a.user == u {
                    return true
                }
            }
        }
        return false
    }
    
    func invalidate(){
        fetched = false
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
}
struct Comment {
    let user:String
    let comment:String
    let timestamp:String
}
enum PostType{
    case Option
    case Text
    static func getType(_ i:Int) -> PostType {
        if i == 0 {
            return PostType.Option
        }else if i == 1{
            return PostType.Text
        }
        return .Option
    }
}
enum PostState{
    case Question
    case Result
}
