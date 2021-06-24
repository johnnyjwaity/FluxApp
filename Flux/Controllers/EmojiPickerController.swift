//
//  EmojiPickerController.swift
//  Flux
//
//  Created by Johnny Waity on 4/9/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class EmojiPickerController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var sortedEmojis:[Emoji] = []
    var delegate:EmojiPickerDelegate? = nil
    
    let searchIcon:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate))
        iv.tintColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let searchBar:UITextField = {
        let searhBar = UITextField()
        searhBar.translatesAutoresizingMaskIntoConstraints = false
        searhBar.placeholder = "Search..."
        searhBar.font = UIFont.systemFont(ofSize: 30)
        return searhBar
    }()
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "BG")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        return collectionView
    }()
    
    let emojiBackgroundView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    var topConstraintVisible:NSLayoutConstraint!
    var topConstraintHidden:NSLayoutConstraint!
    
    let emojiView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(named: "BG")
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()
    
    let closeButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("x", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    let emojiLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70)
        return label
    }()
    
    let sliderBackground:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Emoji.emojiColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.masksToBounds = true
        v.clipsToBounds = true
        v.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 240, height: 50)
        v.layer.cornerRadius = 12.5
        return v
    }()
    
    let slider:UISlider = {
        let s = UISlider()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.minimumTrackTintColor = UIColor.clear
        s.maximumTrackTintColor = UIColor.clear
        return s
    }()
    
    let selectButton:UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Select", for: .normal)
        b.setTitleColor(UIColor.white, for: .normal)
        b.backgroundColor = UIColor.appBlue
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 20
        return b
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(named: "BG")
        
        view.addSubview(searchIcon)
        searchIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 13).isActive = true
        searchIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 13).isActive = true
        searchIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchBar.addTarget(self, action: #selector(search), for: .editingChanged)
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.leftAnchor.constraint(equalTo: searchIcon.rightAnchor, constant: 8).isActive = true
        searchBar.centerYAnchor.constraint(equalTo: searchIcon.centerYAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(emojiBackgroundView)
        topConstraintVisible = emojiBackgroundView.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraintHidden = emojiBackgroundView.topAnchor.constraint(equalTo: view.bottomAnchor)
        topConstraintHidden.isActive = true
        emojiBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emojiBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emojiBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        emojiBackgroundView.addSubview(emojiView)
        emojiView.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor).isActive = true
        emojiView.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor).isActive = true
        emojiView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        emojiView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        emojiView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: emojiView.topAnchor, constant: 4).isActive = true
        closeButton.rightAnchor.constraint(equalTo: emojiView.rightAnchor, constant: -4).isActive = true
        
        emojiView.addSubview(emojiLabel)
        emojiLabel.topAnchor.constraint(equalTo: emojiView.topAnchor).isActive = true
        emojiLabel.bottomAnchor.constraint(equalTo: emojiView.centerYAnchor).isActive = true
        emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor).isActive = true
        
        emojiView.addSubview(sliderBackground)
        sliderBackground.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor).isActive = true
        sliderBackground.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8).isActive = true
        sliderBackground.widthAnchor.constraint(equalToConstant: 240).isActive = true
        sliderBackground.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        emojiView.addSubview(slider)
        slider.centerYAnchor.constraint(equalTo: sliderBackground.centerYAnchor).isActive = true
        slider.centerXAnchor.constraint(equalTo: sliderBackground.centerXAnchor).isActive = true
        slider.widthAnchor.constraint(equalTo: emojiView.widthAnchor, multiplier: 0.8).isActive = true
        
        selectButton.addTarget(self, action: #selector(selectButtonClicked), for: .touchUpInside)
        emojiView.addSubview(selectButton)
        selectButton.bottomAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: -8).isActive = true
        selectButton.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        selectButton.widthAnchor.constraint(equalTo: emojiView.widthAnchor, multiplier: 0.5).isActive = true
        
        sortedEmojis = Emoji.emojis
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func search(){
        let query = searchBar.text ?? ""
        sortedEmojis = []
        if query.count == 0 {
            sortedEmojis = Emoji.emojis
        }else{
            for e in Emoji.emojis {
                if e.name.lowercased().contains(query.lowercased()) {
                    sortedEmojis.append(e)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
        cell.setEmoji(sortedEmojis[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sortedEmojis[indexPath.row].hasSkinVarients {
            emojiLabel.text = sortedEmojis[indexPath.row].generateEmoji()
            emojiLabel.tag = indexPath.row
            slider.setValue(0, animated: false)
            toggleEmojiView(true)
        }else{
            delegate?.selectedEmoji(sortedEmojis[indexPath.row].generateEmoji())
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc
    func closeButtonClicked(){
        toggleEmojiView(false)
    }
    
    @objc
    func selectButtonClicked(){
        delegate?.selectedEmoji(emojiLabel.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    func toggleEmojiView(_ show:Bool){
        if show {
            topConstraintHidden.isActive = false
            topConstraintVisible.isActive = true
        }else{
            topConstraintVisible.isActive = false
            topConstraintHidden.isActive = true
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc
    func sliderChanged(){
        var skinIndex = 0
        let value = slider.value
        if value < 0.166 {
            skinIndex = 0
        }else if value < 0.333 {
            skinIndex = 1
        }else if value < 0.5 {
            skinIndex = 2
        }else if value < 0.666 {
            skinIndex = 3
        }else if value < 0.833 {
            skinIndex = 4
        }else{
            skinIndex = 5
        }
        emojiLabel.text = sortedEmojis[emojiLabel.tag].generateEmoji(skinColor: skinIndex)
    }
    
}
protocol EmojiPickerDelegate {
    func selectedEmoji(_ emoji:String)
}
