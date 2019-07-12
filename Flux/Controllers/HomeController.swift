//
//  HomeController.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PostDelegate {
    
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(openDirectMessages))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getFeed), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        if allowsRefresh {
            collectionView.refreshControl = refreshControl
        }
        
        
    }
    @objc
    func openDirectMessages(){
        navigationController?.pushViewController(DMController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    
    @objc
    func getFeed(){
        CacheManager.clearCache()
        if !AppDelegate.hasAttemptedRegistrantion{
            AppDelegate.hasAttemptedRegistrantion = true
            AppDelegate.registerForPushNotifications()
        }
        URLCache.shared = URLCache()
        
        Network.request(url: "https://api.tryflux.app:3000/feed", type: .get, paramters: nil, auth: true) { (response, error) in
            var posts:[Post] = []
            if let success = response["success"] as? Bool {
                if success {
                    let feed:[[String:Any]] = response["feed"] as! [[String:Any]]
                    for p in feed {
                        let id = p["id"]! as! String
                        let type = p["type"]! as! Int
                        posts.append(Post(postID: id, type: PostType.getType(type)))
                        if type == 0 {
                            let choices = p["choices"] as! Int
                            posts.last?.amount = choices
                        }
                    }
                }
            }
            self.setPosts(posts)
            self.refreshControl.endRefreshing()
        }
    }
    
    func setPosts(_ posts:[Post]){
        self.posts = posts
        self.collectionView.reloadData()
//        for post in self.posts {
//            post.fetch {
//
//            }
//        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: posts[indexPath.row].type == .Option ? "option" : "text", for: indexPath) as! PostCell
        cell.collectionView = collectionView
        cell.delegate = self
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
                    return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(162 + (posts[indexPath.row].choices!.count * 72)))
                }
                return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + round((Double(posts[indexPath.row].choices!.count) / 2)) * 70))
            }
        case .Text:
            return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: 245)
        }
    }
    
    func openProfile(_ user: String) {
        navigationController?.pushViewController(ProfileController(user), animated: true)
    }
    
    func openComments(_ post: Post) {
        navigationController?.pushViewController(CommentsController(post), animated: true)
    }
    
}
