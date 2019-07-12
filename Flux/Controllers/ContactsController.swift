//
//  ContactsController.swift
//  Flux
//
//  Created by Johnny Waity on 6/30/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class ContactsController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var users:[String] = []
    var inviteContacts:[Contact] = []
    
    let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        navigationItem.title = "Contacts"
        
        let store = CNContactStore()
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts) { (authorized, err) in
                if authorized {
                    self.retrieveContacts(store)
                }
            }
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            retrieveContacts(store)
        }
        // Do any additional setup after loading the view.
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func retrieveContacts(_ store:CNContactStore) {
        var contacts:[Contact] = []
        let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor])
        do {
            try store.enumerateContacts(with: request) { (contact, stopPointer) in
                var emails:[String] = []
                for email in contact.emailAddresses {
                    emails.append(email.value as String)
                }
                var phoneNumbers:[String] = []
                for phone in contact.phoneNumbers {
                    phoneNumbers.append(phone.value.stringValue)
                }
                
                var name = "\(contact.givenName) \(contact.familyName)"
                name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                contacts.append(Contact(name: name, emails: emails, phonenumbers: phoneNumbers, sortedname: "\(contact.familyName)\(contact.givenName)"))
            }
        }catch{
            print(error)
        }
        
        let fluxUsers:[[String:String]] = [["name":"virajsule12", "email":"virajsule12@gmail.com"]]
        for u in fluxUsers {
            users.append(u["name"] ?? "")
            var counter = 0
            for contact in contacts {
                if contact.emails.contains(u["email"] ?? "") {
                    break
                }
                counter += 1
            }
            contacts.remove(at: counter)
        }
        inviteContacts = contacts.sorted(by: { (c1, c2) -> Bool in
            if c1.sortedname < c2.sortedname {
                return true
            }
            return false
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = section == 0 ? users.count : inviteContacts.count
        return num == 0 ? 1 : num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && users.count == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No Friends With Flux :("
            cell.textLabel?.textColor = UIColor.lightGray
            return cell
        }
        if indexPath.section == 1 && inviteContacts.count == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No Friends To Invite :("
            cell.textLabel?.textColor = UIColor.lightGray
            return cell
        }
        
        if indexPath.section == 0 {
            let cell = UserCell(users[indexPath.row])
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = inviteContacts[indexPath.row].name
            let button = UIButton(type: .roundedRect)
            button.tintColor = UIColor.appBlue
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitle("Invite", for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 75, height: 25)
            button.layer.borderWidth = 1
            button.layer.borderColor = button.tintColor.cgColor
            button.layer.cornerRadius = 8
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(invite(_:)), for: .touchUpInside)
            cell.accessoryView = button
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Friends With Flux" : "Invite Friends"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if users.count == 0{
                return 44
            }else{
                return 80
            }
        }else{
            return 44
        }
    }
    
    @objc
    func invite(_ sender:UIButton) {
        enum ContactMethods {
            case email
            case phone
        }
        let contact = inviteContacts[sender.tag]
        var allowedContactMethods:[ContactMethods] = []
        if contact.phonenumbers.count != 0 {
            allowedContactMethods.append(.phone)
        }
        if contact.emails.count != 0 {
            allowedContactMethods.append(.email)
        }
        if allowedContactMethods.count == 0 {
            return
        }else if allowedContactMethods.count == 1 {
            if allowedContactMethods[0] == .email {
                inviteByEmail(inviteContacts[sender.tag])
            }else{
                inviteByPhone(inviteContacts[sender.tag])
            }
        }else{
            let alert = UIAlertController(title: "Inivte \(inviteContacts[sender.tag].name) By", message: nil, preferredStyle: .actionSheet)
            for method in allowedContactMethods {
                let action = UIAlertAction(title: method == ContactMethods.email ? "Email" : "Text", style: .default) { (action) in
                    if method == .email {
                        self.inviteByEmail(self.inviteContacts[sender.tag])
                    }else{
                        self.inviteByPhone(self.inviteContacts[sender.tag])
                    }
                }
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func inviteByEmail(_ contact:Contact) {
        if contact.emails.count > 1 {
            let alert = UIAlertController(title: "Which Email?", message: nil, preferredStyle: .actionSheet)
            for email in contact.emails {
                let action = UIAlertAction(title: email, style: .default) { (action) in
                    self.sendMail(name: contact.name, email: email)
                }
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            sendMail(name: contact.name, email: contact.emails[0])
        }
    }
    func sendMail(name:String, email:String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject("Your Friend Invited You To Join Flux!")
            mail.setMessageBody("Hello \(name),\n\nYour firend invited you to join Flux! Check it out at https://tryflux.app", isHTML: false)
            present(mail, animated: true, completion: nil)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func inviteByPhone(_ contact:Contact){
        if contact.phonenumbers.count > 1 {
            let alert = UIAlertController(title: "Which Phone Number?", message: nil, preferredStyle: .actionSheet)
            for phone in contact.phonenumbers {
                let action = UIAlertAction(title: phone, style: .default) { (action) in
                    self.sendText(name: contact.name, number: phone)
                }
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }else{
            sendText(name: contact.name, number: contact.phonenumbers[0])
        }
    }
    func sendText(name:String, number:String){
        if MFMessageComposeViewController.canSendText() {
            let text = MFMessageComposeViewController()
            text.recipients = [number]
            text.body = "Try out Flux! https://tryflux.app"
            text.messageComposeDelegate = self
            present(text, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

struct Contact {
    let name:String
    let emails:[String]
    let phonenumbers:[String]
    let sortedname:String
}
