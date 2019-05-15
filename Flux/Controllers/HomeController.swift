//
//  HomeController.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    static var shared:HomeController!
    
    var posts:[Post] = []
    let refreshControl = UIRefreshControl()
    var allowsRefresh = true

    override func viewDidLoad() {
        if HomeController.shared == nil {
            HomeController.shared = self
        }
        collectionView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        collectionView.register(OptionPostCell.self, forCellWithReuseIdentifier: "option")
        collectionView.register(TextPostCell.self, forCellWithReuseIdentifier: "text")
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Amandita", size: 28)!]
        navigationController?.navigationBar.barTintColor = UIColor.appBlue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getFeed), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        if allowsRefresh {
            collectionView.refreshControl = refreshControl
        }
        
        
        
    }
    
    
    @objc
    func logout(){
        Network.authToken = nil
        let keychain = Keychain(service: "com.johnnywaity.flux")
        Network.request(url: "https://api.tryflux.app:3000/invalidateToken", type: .delete, paramters: ["refreshToken": keychain["refresh"] ?? ""])
        keychain["refresh"] = nil
        tabBarController?.present(LoginController(), animated: true, completion: nil)
    }
    @objc
    func getFeed(){
        Network.request(url: "https://api.tryflux.app:3000/feed", type: .get, paramters: nil, auth: true) { (response, error) in
            if let success = response["success"] as? Bool {
                if success {
                    self.posts = []
                    let feed:[[String:Any]] = response["feed"] as! [[String:Any]]
                    for p in feed {
                        let id = p["id"]! as! String
                        let type = p["type"]! as! Int
                        self.posts.append(Post(postID: id, type: PostType.getType(type)))
                        if type == 0 {
                            let choices = p["choices"] as! Int
                            self.posts.last?.amount = choices
                        }
                    }
                }
            }
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func setPosts(_ posts:[Post]){
        self.posts = posts
        self.collectionView.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: posts[indexPath.row].type == .Option ? "option" : "text", for: indexPath) as! PostCell
        cell.setPost(posts[indexPath.row], collectionView: collectionView)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row >= posts.count {
            return CGSize(width: 0, height: 0)
        }
        switch posts[indexPath.row].type {
        case .Option:
            if posts[indexPath.row].fetched == false {
                return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + round((Double(posts[indexPath.row].amount ?? 1) / 2)) * 70))
            }else{
                if posts[indexPath.row].showingResults {
                    return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + (posts[indexPath.row].choices!.count * 72)))
                }
                return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + round((Double(posts[indexPath.row].choices!.count) / 2)) * 70))
            }
        case .Text:
            return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: 245)
        }
    }
}
