//
//  ExploreController.swift
//  Flux
//
//  Created by Johnny Waity on 5/14/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class ExploreController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var posts:[Post] = []
    
    let refreshControl = UIRefreshControl()
    
    let sortToolbar:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        let border = UIView()
        border.backgroundColor = UIColor.lightGray
        border.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(border)
        border.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: v.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let border2 = UIView()
        border2.backgroundColor = UIColor.lightGray
        border2.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(border2)
        border2.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        border2.leftAnchor.constraint(equalTo: v.leftAnchor).isActive = true
        border2.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        border2.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let sortLabel = UILabel()
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.text = "Sort By:"
        sortLabel.textColor = UIColor.lightGray
        sortLabel.font = UIFont.systemFont(ofSize: 20)
        v.addSubview(sortLabel)
        sortLabel.leftAnchor.constraint(equalTo: v.leftAnchor, constant: 10).isActive = true
        sortLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        return v
    }()
    
    let sortByButton:UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Most Popular", for: .normal)
        b.setTitleColor(UIColor.appBlue, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return b
    }()
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.alwaysBounceVertical = true
        c.register(PostCell.self, forCellWithReuseIdentifier: "post")
        c.backgroundColor = UIColor.white
        return c
    }()

    init(){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.white
        view.addSubview(sortToolbar)
        sortToolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sortToolbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sortToolbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sortToolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sortByButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        sortToolbar.addSubview(sortByButton)
        sortByButton.rightAnchor.constraint(equalTo: sortToolbar.rightAnchor, constant: -10).isActive = true
        sortByButton.centerYAnchor.constraint(equalTo: sortToolbar.centerYAnchor).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: sortToolbar.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    func refresh(){
        fetchPosts(sort: sortByButton.titleLabel?.text == "Most Popular" ? "popular" : "trending")
    }
    
    
    func fetchPosts(sort:String="popular"){
        Network.request(url: "https://api.tryflux.app/explore?filter=\(sort)", type: .get, paramters: nil, auth: false) { (res, err) in
            if res["success"] as? Int == 1{
                self.posts = []
                let dataPosts = res["posts"] as! [[String:Any]]
                for dp in dataPosts {
                    let id = dp["postID"] as! String
                    self.posts.append(Post(postID: id))
                }
                for p in self.posts {
                    p.fetch {
                        if let index = self.posts.firstIndex(of: p) {
                            if let cell = self.collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? PostCell {
                                cell.update()
                            }
                        }
                    }
                }
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc
    func changeSort(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let popularAction = UIAlertAction(title: "Most Popular", style: .default, handler: { (action) in
            self.sortByButton.setTitle("Most Popular", for: .normal)
            self.fetchPosts(sort: "popular")
        })
        let trendingAction = UIAlertAction(title: "Trending", style: .default, handler: { (action) in
            self.sortByButton.setTitle("Trending", for: .normal)
            self.fetchPosts(sort: "trending")
        })
        optionMenu.addAction(popularAction)
        optionMenu.addAction(trendingAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCell
        cell.setPost(posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 450)
    }

}
