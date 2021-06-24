//
//  SettingsController.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import KeychainAccess

class SettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationItem.title = "Settings"
        tableView.register(LinkedAccountCell.self, forCellReuseIdentifier: "linked-account")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "linked-account") as! LinkedAccountCell
            cell.setCell(type: indexPath.row == 0 ? .Snapchat : .Twitter)
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = UIColor.red
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Linked Accounts"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            logout()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func logout(){
        
        Network.setToken(nil)
        AppDelegate.hasAttemptedRegistrantion = false
        let keychain = Keychain(service: "com.johnnywaity.flux")
        Network.request(url: "https://api.tryflux.app/invalidateToken", type: .delete, paramters: ["refreshToken": keychain["refresh"] ?? ""])
        if let t = AppDelegate.deviceToken {
            Network.request(url: "https://api.tryflux.app/deviceToken", type: .delete, paramters: ["deviceToken" : t])
        }
        keychain["refresh"] = nil
        tabBarController?.present(LoginController(), animated: true, completion: nil)
    }
}
