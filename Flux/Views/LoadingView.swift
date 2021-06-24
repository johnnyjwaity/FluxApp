//
//  LoadingView.swift
//  Flux
//
//  Created by Johnny Waity on 3/17/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    let shapeLayer = CAShapeLayer()
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "BG")
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.strokeColor = UIColor.appGreen.cgColor
        backgroundLayer.lineWidth = 6
        backgroundLayer.strokeEnd = 1
        backgroundLayer.fillColor = UIColor.clear.cgColor
        containerView.layer.addSublayer(backgroundLayer)
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.appBlue.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0.33
        shapeLayer.strokeStart = 0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        containerView.layer.addSublayer(shapeLayer)
        
        self.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func startAnimation(){
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = 2 * CGFloat.pi
        animation.repeatCount = Float.infinity
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "rotate")
    }
    
    func endAnimation(){
        shapeLayer.removeAnimation(forKey: "rotate")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
