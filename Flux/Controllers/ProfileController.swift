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
import SCSDKBitmojiKit
import SCSDKLoginKit

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    static var myProfile:ProfileController? = nil
    let followButton = UIButton(type: .system)
    
    var profilePicture:UIImageView!
    let box1 = InfoButton("Posts", showDivider: false)
    let box2 = InfoButton("Followers")
    let box3 = InfoButton("Following")
    let usernameLabel = UILabel()
    let nameLabel = UILabel()
    let bioField = UITextView()
    var bioHeight:NSLayoutConstraint!
    let linkField = UITextView()
    var containerHeight:NSLayoutConstraint!
    var postContoller:HomeController? = nil
    var isMe = false
    
    var tableView:UITableView? = nil
    var tablePosts:[Post] = []
    
    let picker = UIImagePickerController()
    
    var user:String? = nil
    
    let refreshControl = UIRefreshControl()
    var followers:[String] = []
    var following:[String] = []
    
//    let tableView = UITableView()
    var scrollView:UIScrollView!
    var constraintedScrollView = false
    
    var profile:Profile? = nil
    
    init(_ user:String){
        self.user = user
        if user == ""{
            isMe = true
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Amandita", size: 28)!]
        navigationController?.navigationBar.tintColor = UIColor.appBlue
        navigationController?.navigationBar.barTintColor = UIColor.appBlue
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        scrollView = UIScrollView()//UIScrollView(frame: view.safeAreaLayoutGuide.layoutFrame)
        scrollView.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        
        let containerView = UIView()//UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.safeAreaLayoutGuide.layoutFrame.height))
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerHeight = containerView.heightAnchor.constraint(equalToConstant: 180)
//        containerHeight.isActive = true
        
        profilePicture = UIImageView(image: #imageLiteral(resourceName: "profilePlaceholder"))
        profilePicture.backgroundColor = UIColor.lightGray
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = 50
        profilePicture.layer.masksToBounds = true
        profilePicture.clipsToBounds = true
        profilePicture.isUserInteractionEnabled = true
        containerView.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        profilePicture.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePictureClicked))
        tap.numberOfTapsRequired = 1
        profilePicture.addGestureRecognizer(tap)
        
        
        let infoBar = UIView()
        infoBar.translatesAutoresizingMaskIntoConstraints = false
        infoBar.backgroundColor = UIColor.white
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
        
        
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = UIColor.appBlue
        followButton.layer.cornerRadius = 15
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        followButton.addTarget(self, action: #selector(followButtonClicked), for: .touchUpInside)
        containerView.addSubview(followButton)
        followButton.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 0).isActive = true
        followButton.topAnchor.constraint(equalTo: infoBar.bottomAnchor, constant: 10).isActive = true
        followButton.leftAnchor.constraint(equalTo: infoBar.leftAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: infoBar.rightAnchor).isActive = true
        
        nameLabel.text = "Test Username"
        nameLabel.textColor = UIColor.appBlue
        nameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profilePicture.leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: infoBar.rightAnchor).isActive = true
        
        
        usernameLabel.text = "Test Username"
        usernameLabel.textColor = UIColor.appGreen
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: infoBar.rightAnchor).isActive = true
        
        linkField.text = "https://johnnywaity.com"
        linkField.font = UIFont.systemFont(ofSize: 16)
        linkField.textColor = UIColor.appBlue
        linkField.translatesAutoresizingMaskIntoConstraints = false
        linkField.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        linkField.isEditable = false
        linkField.isScrollEnabled = false
//        containerView.addSubview(linkField)
//        linkField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        linkField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        linkField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        bioField.text = ""
        bioField.textColor = UIColor.black
        bioField.font = UIFont.boldSystemFont(ofSize: 15)
        bioField.translatesAutoresizingMaskIntoConstraints = false
        bioField.isEditable = false
        bioField.isScrollEnabled = false
        bioField.textContainer.lineBreakMode = .byWordWrapping
        containerView.addSubview(bioField)
        bioField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0).isActive = true
        bioField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        bioField.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        bioHeight = bioField.heightAnchor.constraint(equalToConstant: 0)
        bioHeight.isActive = true
        containerView.bottomAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 10).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        divider.layer.cornerRadius = 0.5
        divider.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(divider)
        divider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        divider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        divider.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
//        let scrollTable = UITableView(frame: CGRect.zero, style: .plain)
//        scrollTable.translatesAutoresizingMaskIntoConstraints = false
//        tableView?.clipsToBounds = false
//        tableView?.layer.masksToBounds = false
//        scrollTable.tableHeaderView = containerView
//        view.addSubview(scrollTable)
//        scrollTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        scrollTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        scrollTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
////        scrollTable.heightAnchor.constraint(equalToConstant: 160).isActive = true
//        scrollTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        var myUsername = ""
        if let auth = Network.authToken {
            do{
                let jwt = try decode(jwt: auth)
                myUsername = (jwt.body["uID"] as! String)
                
            }catch{
                print(error)
            }
        }
        
        
        if user != nil && user != myUsername {
            let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
            homeController.allowsRefresh = false
            addChild(homeController)
            homeController.view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(homeController.view)
            homeController.view.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
            homeController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            homeController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
            homeController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            postContoller = homeController
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(openSettings))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//            navigationItem.rightBarButtonItem?.imageInsets = UIImagr
            let tableView = UITableView(frame: CGRect.zero, style: .plain)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            scrollView.addSubview(tableView)
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            
            self.tableView = tableView
        }
        
        
        
//        if let u = user {
            setAccount(user ?? "")
//        }
        
    }
    
    @objc
    func openSettings(){
        navigationController?.pushViewController(SettingsController(style: .grouped), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if user == nil {
//            setAccount()
//        }
//        scrollView.frame = view.safeAreaLayoutGuide.layoutFrame
        if !constraintedScrollView {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            constraintedScrollView = true
        }
        
    }
    
    @objc
    func refresh(_ indicator:UIRefreshControl){
        if let u = user {
            setAccount(u)
        }else{
            setAccount()
        }
    }
    
    func setAccount(_ username:String = ""){
        var username:String = username
        
        var myUsername = ""
        do{
            let jwt = try decode(jwt: Network.authToken!)
            myUsername = (jwt.body["uID"] as! String)
            
        }catch{
            print(error)
        }
        
        if username == "" || username == myUsername {
            username = myUsername
            self.user = username
            followButton.setTitle("Edit", for: .normal)
        }
        Network.request(url: "https://api.tryflux.app/account?user=\(username)", type: .get, paramters: nil, auth: true) { (result, error) in
            if let err = error {
                print(err)
                self.refreshControl.endRefreshing()
                return
            }
            let account = result["account"] as! [String:Any]
            
            self.followers = account["followers"] as? [String] ?? []
            self.following = account["following"] as? [String] ?? []
            
            
            
            self.usernameLabel.text = "@\((account["username"] as? String) ?? "n/a")"
            self.box1.numberLabel.text = "\((account["posts"] as? [Any] ?? []).count)"
            self.box2.numberLabel.text = "\((account["followers"] as! [Any]).count)"
            self.box3.numberLabel.text = "\((account["following"] as! [Any]).count)"
            
            let name = (account["name"] as? String) ?? "\((account["username"] as? String) ?? "n/a")"
            self.nameLabel.text = name
            
            let link = (account["link"] as? String) ?? ""
//
            let bio = (account["bio"] as? String) ?? ""
            self.profile = Profile(username: username, name: name, bio: bio, link: link)
            
            var posts:[Post] = []
            var postsData = account["posts"] as? [[String:Any]] ?? []
            postsData.reverse()
            for post in postsData {
                let p = Post(postID: post["id"] as! String, type: PostType.getType(post["type"] as! Int))
                posts.append(p)
            }
            
            if let cont = self.postContoller {
                cont.setPosts(posts)
            }else {
                self.tablePosts = posts
                self.tableView?.reloadData()
                var counter = 0
                for post in self.tablePosts {
                    let indexPath = IndexPath(row: counter, section: 0)
                    post.fetch {
                        self.tableView?.cellForRow(at: indexPath)?.textLabel?.text = post.question
                    }
                    counter += 1
                }
            }
            
            if let followers = account["followers"] as? [String] {
                for follower in followers {
                    if follower == myUsername {
                        self.followButton.setTitle("Following", for: .normal)
                        break
                    }
                }
            }
            let finalBio = NSMutableAttributedString(string: bio)
            finalBio.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: bio.count))
            if link != "" {
                if bio != "" {
                    finalBio.append(NSAttributedString(string: "\n\n"))
                }
                let linkstr = NSMutableAttributedString(string: link)
                linkstr.addAttribute(.link, value: self.linkField.text ?? "", range: NSRange(location: 0, length: link.count))
                linkstr.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: link.count))
                let imageAttatchment = NSTextAttachment()
                let titleFont = UIFont.systemFont(ofSize: 16)
                imageAttatchment.bounds = CGRect(x: 0.0, y: (titleFont.capHeight - 30).rounded() / 2, width: 30.0, height: 30.0)//CGRect(x: 0, y: 8, width: 30, height: 30)
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
            self.bioHeight.isActive = false
            if finalBio.string.count == 0 {
                self.bioHeight.isActive = true
            }
            self.refreshControl.endRefreshing()
        }
        Network.downloadImage(user: username) { (image) in
            if let i = image {
                self.profilePicture.image = i
            }
        }
    }
    
    @objc
    func profilePictureClicked(){
        print("Cliked")
        var myUsername = ""
        do{
            let jwt = try decode(jwt: Network.authToken!)
            myUsername = (jwt.body["uID"] as! String)
            
        }catch{
            print(error)
        }
        if user != "" && user != myUsername {
            return
        }
        let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (a) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode =  UIImagePickerController.CameraCaptureMode.photo
                self.picker.modalPresentationStyle = .custom
                self.present(self.picker,animated: true,completion: nil)
            }else{
                //action performed if there is no camera in device.
            }
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { (a) in
            self.picker.sourceType = .photoLibrary
//            action.dismiss(animated: true, completion: nil)
            self.present(self.picker, animated: true, completion: nil)
        }
        let linkBitmoji = UIAlertAction(title: "Link Bitmoji", style: .default) { (a) in
            SCSDKLoginClient.login(from: self, completion: { (res, err) in
                if res {
                    self.getBitmoji()
                }
                
            })
        }
        let deletePhoto = UIAlertAction(title: "Delete Profile Picture", style: .destructive) { (a) in
            self.profilePicture.image = #imageLiteral(resourceName: "profilePlaceholder")
            Network.request(url: "https://api.tryflux.app/profilePicture", type: .delete, paramters: nil, auth: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (a) in
            
        }
        action.addAction(takePhoto)
        action.addAction(choosePhoto)
        action.addAction(linkBitmoji)
        action.addAction(deletePhoto)
        action.addAction(cancel)
        present(action, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let cropController = CropViewController(croppingStyle: .circular, image: chosenImage)
        cropController.delegate = self
        if picker.sourceType == .camera {
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
        } else {
            picker.pushViewController(cropController, animated: true)
        }
        
    }
    
    func getBitmoji(){
        let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: ["page": "bitmoji"], success: { (resource) in
            guard let resources = resource,
                let data = resources["data"] as? [String: Any],
                let me = data["me"] as? [String: Any] else { return }
            var bitmojiAvatarUrl: String?
            if let bitmoji = me["bitmoji"] as? [String: Any] {
                bitmojiAvatarUrl = bitmoji["avatar"] as? String
            }
            if let link = bitmojiAvatarUrl {
                do {
                    let url = URL(string: link)!
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    
                    let bottomImage = UIImage.from(color: UIColor.white)
                    let size = CGSize(width: 200, height: 200)
                    UIGraphicsBeginImageContext(size)
                    
                    let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    bottomImage.draw(in: areaSize)
                    
                    image!.draw(in: areaSize, blendMode: .normal, alpha: 1)
                    
                    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    DispatchQueue.main.async {
                        self.profilePicture.image = newImage
                    }
                    Network.uploadImage(image: newImage)
                }catch{
                    print(error)
                }
            }
        }, failure: { (err, loggedOut) in
            
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        profilePicture.image = image
        print("HiISAODOJSAKLDJKLSAJNDKNSA<MDN<MSAND<MNSADMAS<MND<MASN<M>DN")
        cropViewController.dismiss(animated: true, completion: nil)
        Network.uploadImage(image: image)
    }
    
    @objc
    func followButtonClicked(){
        if followButton.titleLabel?.text == "Follow"{
            followButton.setTitle("Following", for: .normal)
            if let u = user {
                Network.request(url: "https://api.tryflux.app/follow", type: .post, paramters: ["account": u], auth: true)
            }
        }else if followButton.titleLabel?.text == "Following"{
            followButton.setTitle("Follow", for: .normal)
            if let u = user {
                Network.request(url: "https://api.tryflux.app/unfollow", type: .post, paramters: ["account": u], auth: true)
            }
        }else if followButton.titleLabel?.text == "Edit" {
            
            present(UINavigationController(rootViewController: ProfileEditController(name: profile?.name ?? "", bio: profile?.bio ?? "", link: profile?.link ?? "")), animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = ""
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.textColor = UIColor.appBlue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.textLabel?.text == "" {
            return
        }
        let controller = PostResultsController(tablePosts[indexPath.row])
        controller.title = "Post"
        navigationController?.pushViewController(controller, animated: true)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        scrollView.frame = view.safeAreaLayoutGuide.layoutFrame
//    }

    @objc
    func infoButtonClicked(_ sender:InfoButton) {
        let listCont = UserListController(style: .plain)
        listCont.setUsers(sender.tag == 1 ? followers : following)
        navigationController?.pushViewController(listCont, animated: true)
    }
}

class InfoButton:UIButton {
    let name:String
    let numberLabel = UILabel()
    
    init(_ name:String, showDivider:Bool = true) {
        self.name = name
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backgroundColor = UIColor.white
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
        textLabel.textColor = UIColor.appBlue
        textLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(textLabel)
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "0"
        numberLabel.textColor = UIColor.appBlue
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

struct Profile {
    let username:String
    let name:String
    let bio:String
    let link:String
}
