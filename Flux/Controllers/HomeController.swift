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
    var postStates:[PostState] = []
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
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        self.postStates = []
        for _ in 0..<posts.count {
            postStates.append(.Question)
        }
        self.collectionView.reloadData()
        
        var counter = 0
        for post in self.posts {
            let index = counter
            fetchPost(post, index: index)
            counter += 1
        }
    }
    
    func fetchPost(_ post:Post, index:Int){
        post.fetch {
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PostCell {
                cell.update(post)
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: posts[indexPath.row].type == .Option ? "option" : "text", for: indexPath) as! PostCell
        cell.delegate = self
        cell.setPost(posts[indexPath.row].postID, collectionView: collectionView)
        if posts[indexPath.row].fetched {
            cell.update(posts[indexPath.row])
        }
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
                if postStates[indexPath.row] == .Result {
                    return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(162 + (posts[indexPath.row].choices!.count * 72)))
                }
                return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: CGFloat(112 + round((Double(posts[indexPath.row].choices!.count) / 2)) * 70))
            }
        case .Text:
            return CGSize(width: (UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height) * 0.96, height: 245)
        }
    }
    
    /* PostDelegate START */
    func openProfile(for postID:String) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                navigationController?.pushViewController(ProfileController(posts[i].user ?? ""), animated: true)
                break
            }
        }
    }
    
    func openComments(for postID:String) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                navigationController?.pushViewController(CommentsController(posts[i]), animated: true)
                break
            }
        }
        
    }
    func postState(for postID: String) -> PostState{
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return postStates[i]
            }
        }
        fatalError("No Post State")
    }
    func setPostState(for postID: String, with state: PostState) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                postStates[i] = state
                break
            }
        }
    }
    func answerPost(for postID: String, with answer: Int) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                posts[i].answerOption(answer)
                break
            }
        }
    }
    func getAnswers(for postID: String) -> [Int] {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].getAnswers()
            }
        }
        fatalError("Couldnt get answers")
    }
    func getCommentCount(for postID: String) -> Int {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].comments.count
            }
        }
        fatalError("Couldnt get Comment Count")
    }
    func getPostChoices(for postID: String) -> [String] {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].choices ?? []
            }
        }
        fatalError("Couldnt get Choices")
    }
    func getPostColors(for postID: String) -> [String] {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                return posts[i].colors ?? []
            }
        }
        fatalError("Couldnt get Colors")
    }
    func refreshPost(for postID: String) {
        for i in 0..<posts.count {
            if posts[i].postID == postID {
                posts[i].invalidate()
                if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? PostCell {
                    cell.setPost(postID, collectionView: collectionView)
                }
                fetchPost(posts[i], index: i)
                break
            }
        }
    }
    func shouldShowShare() -> Bool {
        return true
    }
    func sharePost(for postID: String) {
        tabBarController?.present(PostShareController(postID), animated: false, completion: nil)
    }
    /* PostDelegate END */
}
