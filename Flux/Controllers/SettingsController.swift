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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Logout"
        cell.textLabel?.textColor = UIColor.red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logout()
    }
    
    
    func logout(){
        Network.authToken = nil
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
