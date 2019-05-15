//
//  ColorPicker.swift
//  Flux
//
//  Created by Johnny Waity on 4/22/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class ColorPicker: UIView {

    let callback:(_ color:UIColor) -> Void
    
    let colors = [UIColor.red, UIColor.orange, UIColor.appGreen, UIColor.appBlue, UIColor.purple]
    var buttons:[UIButton] = []
    
    init(callback:@escaping (_ color:UIColor) -> Void) {
        self.callback = callback
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        translatesAutoresizingMaskIntoConstraints = false
        for c in colors {
            let colorPickerButton = UIButton(type: .system)
            colorPickerButton.backgroundColor = c
//            colorPickerButton.translatesAutoresizingMaskIntoConstraints = false
            colorPickerButton.layer.cornerRadius = 8
            colorPickerButton.layer.borderWidth = 1
            colorPickerButton.layer.borderColor = UIColor.lightGray.cgColor
            buttons.append(colorPickerButton)
        }
        let linear = UIStackView(arrangedSubviews: buttons)
        linear.alignment = .center
        linear.axis = .horizontal
        linear.distribution = .equalSpacing
        linear.translatesAutoresizingMaskIntoConstraints = false
        addSubview(linear)
        linear.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        linear.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        linear.topAnchor.constraint(equalTo: topAnchor).isActive = true
        linear.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
