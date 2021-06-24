//
//  ProfileController.swift
//  Flux
//
//  Created by Johnny Waity on 5/7/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import JWTDecode
import CropViewController


class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProfileViewDelegate {
    
    let refreshControl = UIRefreshControl()
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let c = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.alwaysBounceVertical = true
        c.register(PostCell.self, forCellWithReuseIdentifier: "post")
        c.register(ProfileInfoView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeader")
        c.register(QuestionCell.self, forCellWithReuseIdentifier: "question")
        c.backgroundColor = UIColor(named: "BG")
        return c
    }()
    
    var profileView:ProfileInfoView? = nil
    
    
    
    var profile:Profile? = nil
    
    var settingsButton:UIBarButtonItem!
    
    
    init(profile:Profile? = nil){
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.white
        
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(openSettings))
        
        
        if let p = profile {
            setProfile(p)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc
    func refresh(){
        if let p = profile {
            p.fetched = false
            setProfile(p)
        }
    }
    
    func setProfile(_ profile:Profile){
        self.profile = profile
        if profile.fetched {
            collectionView.reloadData()
            fetchPosts()
            refreshControl.endRefreshing()
        }else {
            profile.fetch {
                self.collectionView.reloadData()
                self.fetchPosts()
                self.refreshControl.endRefreshing()
            }
        }
        if profile.username == Network.username {
            navigationItem.rightBarButtonItem = settingsButton
        }else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func fetchPosts(){
        var counter = 0
        for p in profile?.posts ?? [] {
            let c = counter
            if !p.fetched {
                p.fetch {
                    if let cell = self.collectionView.cellForItem(at: IndexPath(row: ((self.profile?.posts?.count ?? 0) - 1) - c, section: 0)) as? PostCell {
                        cell.update()
                    }else if let cell = self.collectionView.cellForItem(at: IndexPath(row: ((self.profile?.posts?.count ?? 0) - 1) - c, section: 0)) as? QuestionCell {
                        cell.questionLabel.text = p.question ?? ""
                    }
                }
            }
            counter += 1
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    func openSettings(){
        navigationController?.pushViewController(SettingsController(style: .grouped), animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    func followButtonClicked(){
        profile?.addLocalFollow(Network.username!)
        if let p = profile {
            Network.profile?.addLocalFollowing(p.username)
            profileView?.setInfo(p)
        }
        Network.request(url: "https://api.tryflux.app/follow", type: .post, paramters: ["account": profile!.username], auth: true)
    }
    func followingButtonClicked() {
        profile?.removeLocalFollow(Network.username!)
        if let p = profile {
            Network.profile?.removeLocalFollowing(p.username)
            profileView?.setInfo(p)
        }
        Network.request(url: "https://api.tryflux.app/unfollow", type: .post, paramters: ["account": profile!.username], auth: true)
    }
    func editButtonClicked() {
        present(UINavigationController(rootViewController: ProfileEditController(name: profile?.name ?? "", bio: profile?.bio ?? "", link: profile?.link ?? "")), animated: true, completion: nil)
    }
    
    func followersClicked() {
        print("followers clicked")
        let userListController = UserListController()
        userListController.setUsers(profile?.followers ?? [])
        navigationController?.pushViewController(userListController, animated: true)
    }
    
    func followingClicked() {
        let userListController = UserListController()
        userListController.setUsers(profile?.following ?? [])
        navigationController?.pushViewController(userListController, animated: true)
    }
    
    
    
    
    
    

    @objc
    func infoButtonClicked(_ sender:InfoButton) {
//        let listCont = UserListController(style: .plain)
//        listCont.setUsers(sender.tag == 1 ? followers : following)
//        navigationController?.pushViewController(listCont, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile?.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if profile?.username == Network.username {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "question", for: indexPath) as! QuestionCell
            cell.questionLabel.text = profile?.posts?[((profile?.posts?.count ?? 0) - 1) - indexPath.row].question ?? ""
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCell
            cell.setPost((profile?.posts![((profile?.posts?.count ?? 0) - 1) - indexPath.row])!)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if profile?.username == Network.username {
            return CGSize(width: UIScreen.main.bounds.width, height: 70)
        }else{
            return CGSize(width: UIScreen.main.bounds.width, height: 450)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeader", for: indexPath) as! ProfileInfoView
            if let p = profile {
                header.setInfo(p)
            }
            header.delegate = self
            profileView = header
            return header
        }else {
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                      withHorizontalFittingPriority: .required, // Width is fixed
                                                      verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if profile?.username == Network.username {
            let resultsController = PostResultsController((profile?.posts![(profile?.posts!.count)! - 1 - indexPath.row])!)
            navigationController?.pushViewController(resultsController, animated: true)
        }
    }
    
    
}

class ProfileInfoView:UICollectionReusableView {
    let profilePicture:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
        iv.backgroundColor = UIColor(named: "GR")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let infoBar:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "BG")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let box1 = InfoButton("Posts", showDivider: false)
    let box2 = InfoButton("Followers")
    let box3 = InfoButton("Following")
    
    let followButton:UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Follow", for: .normal)
        b.backgroundColor = UIColor.appBlue
        b.layer.cornerRadius = 15
        b.setTitleColor(UIColor.white, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return b
    }()
    
    let nameLabel:UILabel = {
        let l = UILabel()
        l.text = "Test Name"
        l.textColor = UIColor(named: "FG")
        l.font = UIFont.boldSystemFont(ofSize: 22)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let usernameLabel:UILabel = {
        let l = UILabel()
        l.text = "Test Username"
        l.textColor = UIColor.appBlue
        l.font = UIFont.boldSystemFont(ofSize: 16)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let bioField:UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = UIColor(named: "GR")
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byWordWrapping
        return textView
    }()
    var bioHeight:NSLayoutConstraint? = nil
    
    let divider:UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(named: "GR")
        divider.layer.cornerRadius = 0.5
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    var delegate:ProfileViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "BG")
        self.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        profilePicture.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        containerView.addSubview(infoBar)
        infoBar.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 10).isActive = true
        infoBar.topAnchor.constraint(equalTo: profilePicture.topAnchor, constant: 10).isActive = true
        infoBar.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        infoBar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        box1.tag = 0
        infoBar.addSubview(box1)
        box1.leftAnchor.constraint(equalTo: infoBar.leftAnchor).isActive = true
        box1.heightAnchor.constraint(equalTo: infoBar.heightAnchor).isActive = true
        box1.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor).isActive = true
        box1.widthAnchor.constraint(equalTo: infoBar.widthAnchor, multiplier: 1.0/3).isActive = true

        box2.tag = 1
        box2.addTarget(self, action: #selector(infoButtonClicked(_:)), for: .touchUpInside)
        infoBar.addSubview(box2)
        box2.leftAnchor.constraint(equalTo: box1.rightAnchor).isActive = true
        box2.heightAnchor.constraint(equalTo: infoBar.heightAnchor).isActive = true
        box2.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor).isActive = true
        box2.widthAnchor.constraint(equalTo: infoBar.widthAnchor, multiplier: 1.0/3).isActive = true

        box3.tag = 2
        box3.addTarget(self, action: #selector(infoButtonClicked(_:)), for: .touchUpInside)
        infoBar.addSubview(box3)
        box3.leftAnchor.constraint(equalTo: box2.rightAnchor).isActive = true
        box3.heightAnchor.constraint(equalTo: infoBar.heightAnchor).isActive = true
        box3.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor).isActive = true
        box3.widthAnchor.constraint(equalTo: infoBar.widthAnchor, multiplier: 1.0/3).isActive = true

        followButton.addTarget(self, action: #selector(followButtonClicked), for: .touchUpInside)
        containerView.addSubview(followButton)
//        followButton.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 0).isActive = true
        followButton.topAnchor.constraint(equalTo: infoBar.bottomAnchor, constant: 10).isActive = true
        followButton.leftAnchor.constraint(equalTo: infoBar.leftAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: infoBar.rightAnchor).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        containerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicture.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: infoBar.rightAnchor).isActive = true

        containerView.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: infoBar.rightAnchor).isActive = true


        containerView.addSubview(bioField)
        bioField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0).isActive = true
        bioField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        bioField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        containerView.addSubview(divider)
        divider.topAnchor.constraint(equalTo: bioField.bottomAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        divider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        divider.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc
    func followButtonClicked(){
        if followButton.tag == 0 {
            delegate?.editButtonClicked()
        }else if followButton.tag == 1 {
            delegate?.followingButtonClicked()
        }else if followButton.tag == 2 {
            delegate?.followButtonClicked()
        }
    }
    
    @objc
    func infoButtonClicked(_ sender:UIButton) {
        if sender.tag == 1 {
            delegate?.followersClicked()
        }else if sender.tag == 2 {
            delegate?.followingClicked()
        }
    }
    
    func setInfo(_ profile:Profile) {
        self.profilePicture.image = profile.photo ?? #imageLiteral(resourceName: "profilePlaceholder")
        box1.numberLabel.text = String(profile.posts?.count ?? 0)
        box2.numberLabel.text = String(profile.followers?.count ?? 0)
        box3.numberLabel.text = String(profile.following?.count ?? 0)
        nameLabel.text = profile.name ?? ""
        usernameLabel.text = "@\(profile.username)"
        setBio(bioText: profile.bio ?? "", linkText: profile.link)
        if profile.username == Network.username {
            followButton.setTitle("Edit", for: .normal)
            followButton.tag = 0
        }else{
            if Network.profile?.following?.contains(profile.username) ?? false {
                followButton.setTitle("Following", for: .normal)
                followButton.tag = 1
            }else{
                followButton.setTitle("Follow", for: .normal)
                followButton.tag = 2
            }
        }
        
    }
    
    func setBio(bioText:String, linkText:String? = nil){
        let finalBio = NSMutableAttributedString(string: bioText)
        finalBio.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: bioText.count))
        finalBio.addAttribute(.foregroundColor, value: UIColor(named: "FG") ?? UIColor.black, range: NSRange(location: 0, length: bioText.count))
        if linkText != "" && linkText != nil {
            if bioText != "" {
                finalBio.append(NSAttributedString(string: "\n\n"))
            }
            let linkstr = NSMutableAttributedString(string: linkText!)
            linkstr.addAttribute(.link, value: linkText!, range: NSRange(location: 0, length: linkText!.count))
            linkstr.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: linkText!.count))
            let imageAttatchment = NSTextAttachment()
            let titleFont = UIFont.systemFont(ofSize: 16)
            imageAttatchment.bounds = CGRect(x: 0.0, y: (titleFont.capHeight - 30).rounded() / 2, width: 30.0, height: 30.0)
            imageAttatchment.image = #imageLiteral(resourceName: "link").withRenderingMode(.alwaysTemplate)
            let imageStr = NSAttributedString(attachment: imageAttatchment)
            let colorStr = NSMutableAttributedString(string: " ")
            colorStr.append(imageStr)
            colorStr.append(NSAttributedString(string: "  "))
            colorStr.addAttribute(.foregroundColor, value: UIColor.appBlue, range: NSRange(location: 0, length: colorStr.length))
            finalBio.append(colorStr)
            finalBio.append(linkstr)
        }
        self.bioField.text = ""
        self.bioField.attributedText = finalBio
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ProfileViewDelegate {
    func followButtonClicked()
    func editButtonClicked()
    func followingButtonClicked()
    func followersClicked()
    func followingClicked()
}

class InfoButton:UIButton {
    let name:String
    let numberLabel = UILabel()
    
    init(_ name:String, showDivider:Bool = true) {
        self.name = name
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backgroundColor = UIColor(named: "BG")
        translatesAutoresizingMaskIntoConstraints = false
        
        if showDivider {
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = UIColor.lightGray
            divider.layer.cornerRadius = 0.5
            addSubview(divider)
            divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            divider.topAnchor.constraint(equalTo: topAnchor).isActive = true
            divider.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        }
        
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = name
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor(named: "FG")
        textLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(textLabel)
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "0"
        numberLabel.textColor = UIColor(named: "FG")
        numberLabel.font = UIFont.boldSystemFont(ofSize: 25)
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.textAlignment = .center
        addSubview(numberLabel)
        numberLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -4).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        numberLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
