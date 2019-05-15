//
//  OptionCell.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell, UITextFieldDelegate {
    
    let colors = [UIColor.red, UIColor.orange, UIColor.appGreen, UIColor.appBlue, UIColor.purple]
    var currentColorIndex = 2
    var optionIndex = 0
    var delegate:OptionCallback!
    
    let colorPickerButton = UIButton(type: .system)
    let textView = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.appBlue.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        backgroundColor = UIColor(red: 68.0 / 255, green: 153.0 / 255, blue: 243.0 / 255, alpha: 0.05)
        
        
        textView.placeholder = "Option Name"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textView.leftViewMode = .always
        textView.backgroundColor = UIColor.white
        textView.delegate = self
        addSubview(textView)
        textView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        
        
        colorPickerButton.backgroundColor = UIColor.appGreen
        colorPickerButton.translatesAutoresizingMaskIntoConstraints = false
        colorPickerButton.layer.cornerRadius = 8
        colorPickerButton.layer.borderWidth = 1
        colorPickerButton.layer.borderColor = UIColor.lightGray.cgColor
        addSubview(colorPickerButton)
        colorPickerButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        colorPickerButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colorPickerButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        colorPickerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        colorPickerButton.addTarget(self, action: #selector(colorButtonClicked(_:)), for: .touchUpInside)
        
    }
    
    @objc
    func colorButtonClicked(_ sender:UIButton){
        currentColorIndex += 1
        if currentColorIndex >= colors.count {
            currentColorIndex = 0
        }
        sender.backgroundColor = colors[currentColorIndex]
        delegate.optionColorChanged(colors[currentColorIndex], index: optionIndex)
    }
    
    @objc
    func dismissKeyboard(){
        endEditing(true)
    }
    
    func setColor(_ color:UIColor){
        let index = colors.firstIndex(of: color)!
        currentColorIndex = index
        colorPickerButton.backgroundColor = colors[index]
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate.optionNameChanged(textField.text!, index: optionIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
