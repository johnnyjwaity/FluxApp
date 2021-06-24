//
//  ProfileEditController.swift
//  Flux
//
//  Created by Johnny Waity on 7/2/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import CropViewController
import SCSDKBitmojiKit
import SCSDKLoginKit

class ProfileEditController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    let nameCell = TextFieldCell(style: .default, reuseIdentifier: nil)
    let wordCountCell = WordCountCell(style: .default, reuseIdentifier: nil)
    let linkCell = TextFieldCell(style: .default, reuseIdentifier: nil)
    
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
    
    let picker = UIImagePickerController()
    
    init(name:String = "", bio:String = "", link:String = "") {
        super.init(nibName: nil, bundle: nil)
        nameCell.textField.text = name
        self.wordCountCell.textField.insertText(bio)
        linkCell.textField.text = link
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "Edit"
        navigationItem.title = "Edit"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        // Do any additional setup after loading the view.
        
        
        
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WordCountCell.self, forCellReuseIdentifier: "word-count")
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        let headerView = UIView()
        headerView.frame.size.height = 150
        
        headerView.addSubview(profilePicture)
        profilePicture.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        profilePicture.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePictureClicked))
        tap.numberOfTapsRequired = 1
        profilePicture.addGestureRecognizer(tap)
        
        picker.delegate = self
        
        tableView.tableHeaderView = headerView
//        tableView.sectionHeaderHeight = 200
        
        nameCell.textField.placeholder = "Name"
        linkCell.textField.placeholder = "Link"
        
        Network.downloadImage(user: Network.username ?? "") { (img) in
            self.profilePicture.image = img
        }
    }
    
    @objc
    func profilePictureClicked(){
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
            self.present(self.picker, animated: true, completion: nil)
        }
        let linkBitmoji = UIAlertAction(title: "Link Bitmoji", style: .default) { (a) in
            self.getBitmoji()
        }
        let deletePhoto = UIAlertAction(title: "Delete Profile Picture", style: .destructive) { (a) in
            self.profilePicture.image = #imageLiteral(resourceName: "profilePlaceholder")
            if let username = Network.username {
                CacheManager.profilePictures[username] = nil
            }
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
        picker.pushViewController(cropController, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        setProifleImage(image)
    }
    
    func getBitmoji(){
        LinkedAccounts.shared.linkSnapchat { (linked) in
            if linked {
                SCSDKBitmojiClient.fetchAvatarURL { (url, error) in
                    if let e = error {
                        print("Link Error \(e.localizedDescription)")
                        return
                    }
                    guard
                        let avatarURLString = url,
                        let avatarURL = URL(string: avatarURLString)
                    else{
                        print("Missing URL")
                        return
                    }
                    do{
                        let data = try Data(contentsOf: avatarURL)
                        guard let image = UIImage(data: data) else {return}
                        self.setProifleImage(image)
                    }catch {
                        print("Failed Data Download")
                    }
                }
            }else{
                print("Link Fail")
            }
        }
    }
    
    func setProifleImage(_ image:UIImage){
        self.profilePicture.image = image
        if let u = Network.username {
            CacheManager.profilePictures[u] = image
        }
        Network.uploadImage(image: image)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return nameCell
            }else if indexPath.row == 1 {
                return wordCountCell
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return linkCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 && indexPath.row == 1 ? 170 : 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    let headers = ["Info", "Link"]
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    

    @objc
    func save() {
        let name:String = nameCell.textField.text ?? ""
        let bio:String = wordCountCell.textField.text
        let link:String = linkCell.textField.text ?? ""
        Network.request(url: "https://api.tryflux.app/updateProfile", type: .post, paramters: ["bio": bio, "name": name, "link": link], auth: true)
        dismiss(animated: true, completion: nil)
    }

}
