//
//  CreateOptionPostController.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class CreateOptionPostController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, OptionCallback {
    
    var collectionView:UICollectionView!
    var collectionBottom:NSLayoutConstraint!
    
    var options:[Option] = []
    let textView = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        title = "Create Option Post"
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(post))
        
        
        let questionLabel = UILabel()
        questionLabel.font = UIFont(name: "Amandita", size: 45)
        questionLabel.text = "Question"
        questionLabel.textColor = UIColor.appBlue
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        textView.placeholder = "Question"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textView.leftViewMode = .always
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let optionLabel = UILabel()
        optionLabel.font = UIFont(name: "Amandita", size: 45)
        optionLabel.text = "Options"
        optionLabel.textColor = UIColor.appBlue
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.adjustsFontSizeToFitWidth = true
        optionLabel.textAlignment = .center
        view.addSubview(optionLabel)
        optionLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30).isActive = true
        optionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        optionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        optionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewCell.self, forCellWithReuseIdentifier: "new")
        collectionView.register(OptionCell.self, forCellWithReuseIdentifier: "option")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: optionLabel.bottomAnchor, constant: 15).isActive = true
        collectionBottom = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom)
        collectionBottom.isActive = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionBottom.constant = -view.safeAreaInsets.bottom
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width * 0.9, height: indexPath.row == options.count ? 60 : 84)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        if indexPath.row == options.count {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "new", for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "option", for: indexPath)
            (cell as! OptionCell).optionIndex = indexPath.row
            (cell as! OptionCell).delegate = self
            (cell as! OptionCell).textView.text = options[indexPath.row].name
            (cell as! OptionCell).setColor(options[indexPath.row].color)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == options.count {
            let option = Option(name: "", color: UIColor.appGreen)
            options.append(option)
            collectionView.insertItems(at: [IndexPath(row: options.count - 1, section: 0)])
        }
    }
    
    
    
    func optionNameChanged(_ name: String, index:Int) {
        options[index].name = name
        print("change")
    }
    
    func optionColorChanged(_ color: UIColor, index:Int) {
        options[index].color = color
        print("change")
    }
    
    @objc
    func post(){
        if textView.text == "" || options.count == 0 {
            return
        }
        var params:[String:Any] = [:]
        params["question"] = textView.text!
        params["type"] = 0
        var options:[String:Any] = [:]
        var choices:[String] = []
        var colors:[String] = []
        for o in self.options {
            choices.append(o.name)
            var color = "r"
            switch(o.color){
            case UIColor.red:
                color = "r"
                break
            case UIColor.orange:
                color = "o"
                break
            case UIColor.appGreen:
                color = "g"
                break
            case UIColor.appBlue:
                color = "b"
                break
            case UIColor.purple:
                color = "p"
                break
            default:
                color = "g"
            }
            colors.append(color)
        }
        options["choices"] = choices
        options["colors"] = colors
        params["options"] = options
        print(params)
        let loading = LoadingController("Posting")
        present(loading, animated: true, completion: nil)
        Network.request(url: "https://api.tryflux.app:3000/post", type: .post, paramters: params, auth: true) { (response, error) in
            if let err = error {
                print(err)
                loading.dismiss(animated: true, completion: nil)
                return
            }
            loading.dismiss(animated: true, completion: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }
    }

}
struct Option {
    var name:String
    var color:UIColor
}
protocol OptionCallback {
    func optionNameChanged(_ name:String, index:Int)
    func optionColorChanged(_ color:UIColor, index:Int)
}
