//
//  SearchController.swift
//  Flux
//
//  Created by Johnny Waity on 5/9/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UserListControllerDelegate {
    
    let listController = UserListController(style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Amandita", size: 28)!]
        navigationController?.navigationBar.tintColor = UIColor.appBlue
        navigationController?.navigationBar.barTintColor = UIColor.appBlue
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search For User"
        searchController.searchBar.delegate = self
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        listController.delegate = self
        addChild(listController)
        view.addSubview(listController.view)
        listController.view.translatesAutoresizingMaskIntoConstraints = false
        listController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        listController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        listController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Network.request(url: "https://api.tryflux.app:3000/queryUsers?search=\(searchBar.text ?? "")", type: .get, paramters: nil) { (res, err) in
            if let results = res["result"] as? [String] {
                self.listController.setUsers(results)
            }
        }
    }
    
    func userClicked(_ user: String) {
        let profileController = ProfileController(user)
        profileController.title = user
        navigationController?.pushViewController(profileController, animated: true)
    }

}
