//
//  DMController.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import JWTDecode

class DMController: UITableViewController, UserListControllerDelegate {
    
    
    var convos:[Convo] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(fetchConvos), for: .valueChanged)
        refreshControl = rc
        title = "Direct Messages"
        navigationItem.title = "Direct Messages"
        view.backgroundColor = UIColor.white
        tableView.register(ConvoCell.self, forCellReuseIdentifier: "convo")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        tableView.tableFooterView = UIView()
        fetchConvos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convos.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convo") as! ConvoCell
        cell.accessoryType = .disclosureIndicator
        cell.setCell(user: convos[indexPath.row].recipient, preview: convos[indexPath.row].preview)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ConvoController(convos[indexPath.row].id, title: convos[indexPath.row].recipient), animated: true)
    }

    @objc
    func fetchConvos(){
        Network.request(url: "https://api.tryflux.app/convos", type: .get, paramters: nil, auth: true) { (result, err) in
            if let e = err {
                print(e.localizedDescription)
                return
            }
            var newConvos:[Convo] = []
            if let cs = result["convos"] as? [[String:String]] {
                for c in cs {
                    newConvos.append(Convo(recipient: c["recipient"]!, preview: c["preview"]!, id: c["convoID"]!, time: c["time"]!))
                }
            }
            self.convos = newConvos
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc
    func compose(){
        let myUsername = Network.username ?? ""
        Network.request(url: "https://api.tryflux.app/account?user=\(myUsername)", type: .get, paramters: nil, auth: true) { (result, error) in
            if let err = error {
                print(err)
                return
            }
            let account = result["account"] as! [String:Any]
            let following = account["following"] as? [String] ?? []
            let cont = UserListController()
            cont.setUsers(following)
            cont.delegate = self
            self.navigationController?.pushViewController(cont, animated: true)
            
        }
    }
    func userClicked(_ user: String) {
        navigationController?.popViewController(animated: true)
        Network.request(url: "https://api.tryflux.app/createDM", type: .post, paramters: ["recipient":user], auth: true) { (result, error) in
            if error != nil {
                return
            }
            let convoID = result["convoID"] as! String
            var counter = 0
            for convo in self.convos {
                if convo.id == convoID {
                    self.tableView.selectRow(at: IndexPath(row: counter, section: 0), animated: true, scrollPosition: .none)
                    self.tableView(self.tableView, didSelectRowAt: IndexPath(row: counter, section: 0))
                    return
                }
                counter += 1
            }
            self.convos.insert(Convo(recipient: user, preview: "", id: convoID, time: "now"), at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
    }
    
}
struct Convo {
    let recipient:String
    let preview:String
    let id:String
    let time:String
}
