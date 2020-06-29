//
//  UserListControllerTableViewController.swift
//  Flux
//
//  Created by Johnny Waity on 5/9/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {
    
    var users:[String] = []
    var delegate:UserListControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserCell(users[indexPath.row])
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = delegate {
            del.userClicked(users[indexPath.row])
        }else{
            let profile = Profile(username: users[indexPath.row])
            navigationController?.pushViewController(ProfileController(profile: profile), animated: true)
        }
    }
    
    func setUsers(_ users:[String]) {
        self.users = users
        tableView.reloadData()
    }

}

protocol UserListControllerDelegate {
    func userClicked(_ user:String)
}
