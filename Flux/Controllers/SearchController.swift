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
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.appBlue
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search For User"
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.backgroundImage = nil
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
        
        let findFreindsView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        findFreindsView.backgroundColor = UIColor.white
        
        let contactButton = UIButton(type: .roundedRect)
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        contactButton.layer.cornerRadius = 10
        contactButton.layer.borderColor = UIColor.appBlue.cgColor
        contactButton.layer.borderWidth = 2.5
        findFreindsView.addSubview(contactButton)
        contactButton.topAnchor.constraint(equalTo: findFreindsView.topAnchor, constant: 20).isActive = true
        contactButton.widthAnchor.constraint(equalTo: findFreindsView.widthAnchor, multiplier: 0.8).isActive = true
        contactButton.centerXAnchor.constraint(equalTo: findFreindsView.centerXAnchor).isActive = true
        contactButton.heightAnchor.constraint(equalToConstant: 85).isActive = true
        contactButton.addTarget(self, action: #selector(openContacts), for: .touchUpInside)
        let contactGlyph = UIImageView(image: #imageLiteral(resourceName: "contact").withRenderingMode(.alwaysTemplate))
        contactGlyph.translatesAutoresizingMaskIntoConstraints = false
        contactGlyph.tintColor = UIColor.appBlue
        contactGlyph.contentMode = .scaleAspectFit
        contactButton.addSubview(contactGlyph)
        contactGlyph.topAnchor.constraint(equalTo: contactButton.topAnchor, constant: 10).isActive = true
        contactGlyph.centerXAnchor.constraint(equalTo: contactButton.centerXAnchor).isActive = true
        contactGlyph.widthAnchor.constraint(equalToConstant: 40).isActive = true
        contactGlyph.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let fromContactsLabel = UILabel()
        fromContactsLabel.translatesAutoresizingMaskIntoConstraints = false
        fromContactsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        fromContactsLabel.text = "Find Friends in Contacts"
        fromContactsLabel.textColor = UIColor.appBlue
        fromContactsLabel.textAlignment = .center
        contactButton.addSubview(fromContactsLabel)
        fromContactsLabel.topAnchor.constraint(equalTo: contactGlyph.bottomAnchor, constant: 5).isActive = true
        fromContactsLabel.widthAnchor.constraint(equalTo: contactButton.widthAnchor).isActive = true
        fromContactsLabel.centerXAnchor.constraint(equalTo: contactButton.centerXAnchor).isActive = true
        listController.tableView.tableFooterView = findFreindsView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
//            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Network.request(url: "https://api.tryflux.app/queryUsers?search=\(searchBar.text ?? "")", type: .get, paramters: nil) { (res, err) in
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
    
    @objc
    func openContacts(){
        navigationController?.pushViewController(ContactsController(), animated: true)
    }

}
