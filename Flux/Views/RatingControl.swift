//
//  RatingControl.swift
//  Flux
//
//  Created by Johnny Waity on 5/4/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit
import AVKit

class RatingControl: UIControl {
    
    let minValue:CGFloat = 0
    let maxValue:CGFloat = 10
    var value:CGFloat = 5
    var textLabels:[UILabel] = []
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    let track = CALayer()
    
    let sliderLayer:CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 60))
        path.addLine(to: CGPoint(x: 0, y: 20))
        path.addLine(to: CGPoint(x: 25, y: 0))
        path.addLine(to: CGPoint(x: 50, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 60))
        path.addLine(to: CGPoint(x: 0, y: 60))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeEnd = 1
        shapeLayer.strokeStart = 0
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 5, height: 5)
        shapeLayer.shadowOpacity = 0
        shapeLayer.shadowRadius = 10
        return shapeLayer
    }()
    
    func createTextLabel(position:CGPoint, num:Int) -> UILabel {
        let textLayer = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        textLayer.text = "\(num)"
        textLayer.textColor = UIColor.lightGray
        textLayer.font = UIFont.boldSystemFont(ofSize: 18)
        textLayer.textAlignment = .center
        textLayer.lineBreakMode = .byClipping
        return textLayer
    }
    
    
    let slider:UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 60))
        v.isUserInteractionEnabled = false
        return v
    }()

    override init(frame:CGRect) {
        super.init(frame: frame)
        generator.prepare()
//        backgroundColor = UIColor.lightGray
        layer.addSublayer(track)
        track.backgroundColor = UIColor.appBlue.cgColor
        track.cornerRadius = 5
        
        slider.layer.addSublayer(sliderLayer)
        addSubview(slider)
        
        
        for i in Int(minValue)...Int(maxValue) {
            let l = createTextLabel(position: CGPoint(x: 20 * i, y: 10), num: i)
            textLabels.append(l)
            addSubview(l)
        }
        
        updateLayers()
    }
    
    func updateLayers(){
        track.frame = CGRect(x: 0, y: bounds.height - 30, width: bounds.width, height: 10)
        let sliderXPos:CGFloat = ((value / (maxValue - minValue)) * bounds.width) - (slider.frame.width / 2)
        slider.frame = CGRect(x: sliderXPos, y: bounds.height - slider.frame.height, width: slider.frame.width, height: slider.frame.height)
        
        let spacingContstant = (bounds.width - (textLabels[0].frame.width * (maxValue - minValue + 1))) / (maxValue - minValue)
        let baseHeightConstant:CGFloat = 90
        var counter = 0
        for text in textLabels {
            let xPos:CGFloat = (CGFloat(counter) * text.frame.width) + (spacingContstant * CGFloat(counter))
            let b = bellValue(x: xPos + (text.frame.width / 2))
            let yPos = bounds.height - baseHeightConstant - b
            text.frame = CGRect(x: xPos, y: yPos, width: text.frame.width, height: text.frame.height)
            text.font = UIFont.boldSystemFont(ofSize: 18 + (0.5 * b))
            if Int(round(Float(value))) == counter {
                text.textColor = UIColor.appBlue
            }else{
                text.textColor = UIColor.lightGray
            }
            counter += 1
        }
    }
    
    func bellValue(x:CGFloat) -> CGFloat{
        let xVal = Float(x)
        let center = Float(bounds.width * (value / (maxValue - minValue)))
        let exponent = -powf(xVal - center, 2) / Float(bounds.width * 10)
        var height = 40 * powf(Float(M_E), exponent)
        if height.isNaN {
            height = 0
        }
        return CGFloat(height)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if slider.frame.contains(touch.location(in: self)) {
            sliderLayer.shadowOpacity = 0.5
            return true
        }
        return false
    }
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let xPos = touch.location(in: self).x
        var newValue = ((xPos / bounds.width) * (maxValue - minValue)) + minValue
        if newValue > maxValue {
            newValue = maxValue
        }else if newValue < minValue {
            newValue = minValue
        }
        if round(newValue) != round(value) {
            generator.impactOccurred()
            AudioServicesPlaySystemSound(1104)
        }
        value = newValue
//        print(value)
        updateLayers()
        return true
    }
    
    func setRatingValue(val:Int){
        value = CGFloat(val)
        updateLayers()
    }
    func getValue() -> Int {
        return Int(round(Float(value)))
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        sliderLayer.shadowOpacity = 0
    }
    
    
    override var bounds: CGRect {
        didSet {
            updateLayers()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
