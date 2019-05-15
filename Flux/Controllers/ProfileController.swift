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

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    static var myProfile:ProfileController? = nil
    let followButton = UIButton(type: .system)
    var followButtonHeight:NSLayoutConstraint!
    
    var profilePicture:UIImageView!
    let box1 = InfoButton("Posts", showDivider: false)
    let box2 = InfoButton("Followers")
    let box3 = InfoButton("Following")
    let usernameLabel = UILabel()
    var postContoller:HomeController? = nil
    
    let picker = UIImagePickerController()
    
    var user:String? = nil
    
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    
    init(_ user:String){
        self.user = user
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
        
        profilePicture = UIImageView(image: nil)
        profilePicture.backgroundColor = UIColor.clear
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = 37.5
        profilePicture.layer.masksToBounds = true
        profilePicture.clipsToBounds = true
        profilePicture.backgroundColor = UIColor.black
        profilePicture.isUserInteractionEnabled = true
        view.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        profilePicture.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 75).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 75).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePictureClicked))
        tap.numberOfTapsRequired = 1
        profilePicture.addGestureRecognizer(tap)
        
        
        let infoBar = UIView()
        infoBar.translatesAutoresizingMaskIntoConstraints = false
        infoBar.backgroundColor = UIColor.white
        view.addSubview(infoBar)
        infoBar.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 10).isActive = true
        infoBar.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor).isActive = true
        infoBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        infoBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        infoBar.addSubview(box1)
        box1.leftAnchor.constraint(equalTo: infoBar.leftAnchor).isActive = true
        box1.heightAnchor.constraint(equalTo: infoBar.heightAnchor).isActive = true
        box1.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor).isActive = true
        box1.widthAnchor.constraint(equalTo: infoBar.widthAnchor, multiplier: 1.0/3).isActive = true
        
        
        infoBar.addSubview(box2)
        box2.leftAnchor.constraint(equalTo: box1.rightAnchor).isActive = true
        box2.heightAnchor.constraint(equalTo: infoBar.heightAnchor).isActive = true
        box2.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor).isActive = true
        box2.widthAnchor.constraint(equalTo: infoBar.widthAnchor, multiplier: 1.0/3).isActive = true
        
        
        infoBar.addSubview(box3)
        box3.leftAnchor.constraint(equalTo: box2.rightAnchor).isActive = true
        box3.heightAnchor.constraint(equalTo: infoBar.heightAnchor).isActive = true
        box3.centerYAnchor.constraint(equalTo: infoBar.centerYAnchor).isActive = true
        box3.widthAnchor.constraint(equalTo: infoBar.widthAnchor, multiplier: 1.0/3).isActive = true
        
        
        
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = UIColor.appBlue
        followButton.layer.cornerRadius = 20
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        followButton.addTarget(self, action: #selector(followButtonClicked), for: .touchUpInside)
        view.addSubview(followButton)
        followButton.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 5).isActive = true
        followButton.centerXAnchor.constraint(equalTo: profilePicture.centerXAnchor).isActive = true
        followButton.widthAnchor.constraint(equalTo: profilePicture.widthAnchor, multiplier: 1.2).isActive = true
        followButtonHeight = followButton.heightAnchor.constraint(equalToConstant: 0)
        followButtonHeight.isActive = true
        
        usernameLabel.text = "Test Username"
        usernameLabel.textColor = UIColor.appBlue
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: followButton.centerYAnchor, constant: 0).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: infoBar.leftAnchor, constant: 10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        divider.layer.cornerRadius = 0.5
        divider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(divider)
        divider.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 12).isActive = true
        divider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        divider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        homeController.allowsRefresh = false
        addChild(homeController)
        homeController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeController.view)
        homeController.view.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 0).isActive = true
        homeController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        homeController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        homeController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        postContoller = homeController
        
        if let u = user {
            setAccount(u)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if user == nil {
            setAccount()
        }
    }
    
    func setAccount(_ username:String = ""){
        var username:String = username
        followButtonHeight.constant = 40
        
        var myUsername = ""
        do{
            let jwt = try decode(jwt: Network.authToken!)
            myUsername = (jwt.body["uID"] as! String)
        }catch{
            print(error)
        }
        
        if username == "" {
            followButtonHeight.constant = 0
            username = myUsername
            self.user = username
        }
        Network.request(url: "https://api.tryflux.app:3000/account?user=\(username)", type: .get, paramters: nil, auth: true) { (result, error) in
            if let err = error {
                print(err)
                return
            }
            
            let account = result["account"] as! [String:Any]
            self.usernameLabel.text = account["username"] as? String
            self.box1.numberLabel.text = "\((account["posts"] as? [Any] ?? []).count)"
            self.box2.numberLabel.text = "\((account["followers"] as! [Any]).count)"
            self.box3.numberLabel.text = "\((account["following"] as! [Any]).count)"
            
            var posts:[Post] = []
            var postsData = account["posts"] as? [[String:Any]] ?? []
            postsData.reverse()
            for post in postsData {
                let p = Post(postID: post["id"] as! String, type: PostType.getType(post["type"] as! Int))
                posts.append(p)
            }
            
            if let cont = self.postContoller {
                cont.setPosts(posts)
            }
            
            if let followers = account["followers"] as? [String] {
                for follower in followers {
                    if follower == myUsername {
                        self.followButton.setTitle("Following", for: .normal)
                        break
                    }
                }
            }
        }
        Network.downloadImage(user: username) { (image) in
            self.profilePicture.image = image
        }
    }
    
    @objc
    func profilePictureClicked(){
        print("Cliked")
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
        let deletePhoto = UIAlertAction(title: "Delete Profile Picture", style: .destructive) { (a) in
            self.profilePicture.image = nil
            Network.request(url: "https://api.tryflux.app:3000/profilePicture", type: .delete, paramters: nil, auth: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (a) in
            
        }
        action.addAction(takePhoto)
        action.addAction(choosePhoto)
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
                Network.request(url: "https://api.tryflux.app:3000/follow", type: .post, paramters: ["account": u], auth: true)
            }
        }else{
            followButton.setTitle("Follow", for: .normal)
            if let u = user {
                Network.request(url: "https://api.tryflux.app:3000/unfollow", type: .post, paramters: ["account": u], auth: true)
            }
        }
    }
    
    @objc
    func refresh(_ refreshControl:UIRefreshControl){
        
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
        numberLabel.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -8).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        numberLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
