//
//  Profile.swift
//  Flux
//
//  Created by Johnny Waity on 3/28/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class Profile {
    let username:String
    var name:String? = nil
    var bio:String? = nil
    var link:String? = nil
    var followers:[String]? = nil
    var following:[String]? = nil
    var posts:[Post]? = nil
    var fetched = false
    var photo:UIImage? = nil
    
    init(username:String) {
        self.username = username
    }
    
    func fetch(completion:@escaping () -> Void){
        Network.request(url: "https://api.tryflux.app/account?user=\(username)", type: .get, paramters: nil, auth: true) { (result, error) in
            let success = result["success"] as? Bool
            if success ?? false {
                let accountDictionary = result["account"] as? [String:Any]
                if let ad = accountDictionary {
                    self.name = ad["name"] as? String ?? self.username
                    self.bio = ad["bio"] as? String ?? ""
                    self.link = ad["link"] as? String ?? ""
                    self.followers = ad["followers"] as? [String] ?? []
                    self.following = ad["following"] as? [String] ?? []
                    if let postsDict = ad["posts"] as? [[String:Any]] {
                        var postIds:[Post] = []
                        for p in postsDict {
                            postIds.append(Post(postID: p["id"] as? String ?? ""))
                        }
                        self.posts = postIds
                    }
                    self.fetched = true
                    Network.downloadImage(user: self.username) { (img) in
                        self.photo = img
                        completion()
                    }
                }
            }
        }
    }
    
    func removeLocalFollow(_ user:String) {
        if let index = followers?.firstIndex(of: user) {
            followers?.remove(at: index)
        }
    }
    
    func addLocalFollow(_ user:String) {
        followers?.append(user)
    }
    
    func removeLocalFollowing(_ user:String) {
        if let index = following?.firstIndex(of: user) {
            following?.remove(at: index)
        }
    }
    
    func addLocalFollowing(_ user:String) {
        following?.append(user)
    }
}
