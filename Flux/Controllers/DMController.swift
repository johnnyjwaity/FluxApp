//
//  DMController.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class DMController: UITableViewController {
    
    var convos:[Convo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Direct Messages"
        navigationItem.title = "Direct Messages"
        view.backgroundColor = UIColor.white
        tableView.register(ConvoCell.self, forCellReuseIdentifier: "convo")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "convo") as! ConvoCell
        cell.accessoryType = .disclosureIndicator
        cell.setCell(user: convos[indexPath.row].recipient, preview: convos[indexPath.row].preview)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ConvoController(convos[indexPath.row].id), animated: true)
    }

    
    func fetchConvos(){
        Network.request(url: "https://api.tryflux.app:3000/convos", type: .get, paramters: nil, auth: true) { (result, err) in
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
        }
    }
}
struct Convo {
    let recipient:String
    let preview:String
    let id:String
    let time:String
}
