//
//  HomeController.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess

class HomeController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PostDelegate {
    
    static var shared:HomeController!
    let refreshControl = UIRefreshControl()
    var allowsRefresh = true
    var posts:[Post] = []
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        c.backgroundColor = UIColor.white
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(PostCell.self, forCellWithReuseIdentifier: "postCell")
//        c.isScrollEnabled = false
//        c.alwaysBounceVertical = true
        return c
    }()
    
    
    override func viewDidLoad() {
        if HomeController.shared == nil {
            HomeController.shared = self
        }
        view.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(getFeed), for: .valueChanged)
        if allowsRefresh {
            collectionView.refreshControl = refreshControl
        }
        
        
        let dmItem = UIBarButtonItem(image: #imageLiteral(resourceName: "message"), style: .plain, target: self, action: #selector(openDM))
        navigationItem.rightBarButtonItem = dmItem
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
        Network.request(url: "https://api.tryflux.app/feed", type: .get, paramters: nil, auth: true) { (response, error) in
            var posts:[Post] = []
            if let success = response["success"] as? Bool {
                if success {
                    let feed:[[String:Any]] = response["feed"] as! [[String:Any]]
                    for p in feed {
                        let id = p["id"]! as! String
                        let post = Post(postID: id)
//                        if p["type"] as! Int == 3 {
//                            continue
//                        }
                        posts.append(post)
                    }
                }
            }
            self.setPosts(posts)
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    func setPosts(_ posts:[Post]){
        self.posts = posts
        for p in self.posts {
            p.fetch {
                if let index = self.posts.firstIndex(of: p) {
                    if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PostCell {
                        cell.update()
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    
    @objc
    func openDM(){
        navigationController?.pushViewController(DMController(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        cell.setPost(posts[indexPath.row])
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 450)
    }
    
    func openProfile(for user: String) {
        var profile:Profile!
        if user == Network.username {
            profile = Network.profile
        }else{
            profile = Profile(username: user)
        }
        navigationController?.pushViewController(ProfileController(profile: profile), animated: true)
    }
    
    func openComments(for postID: String) {
        var post:Post? = nil
        for p in self.posts {
            if p.postID == postID {
                post = p
            }
        }
        if let p = post {
            let navigationController = UINavigationController(rootViewController: CommentsController(p))
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func refreshPost(for postID: String) {
        var counter = 0
        for p in posts {
            if p.postID == postID {
                p.invalidate()
                if let cell = collectionView.cellForItem(at: IndexPath(row: counter, section: 0)) as? PostCell {
                    cell.update()
                }
                p.fetch {
                    if let cell = self.collectionView.cellForItem(at: IndexPath(row: counter, section: 0)) as? PostCell {
                        cell.update()
                    }
                }
                break
            }
            counter += 1
        }
    }
    
    func sharePost(for postID: String) {
        let shareController = PostShareController(postID)
        tabBarController?.present(shareController, animated: true, completion: nil)
    }
}
