//
//  RatingResultView.swift
//  Flux
//
//  Created by Johnny Waity on 5/5/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import UIKit

class RatingResultView: UIView {
    
    static let ratingCirclePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
    let ratingCircleLayer:CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = RatingResultView.ratingCirclePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.strokeColor = UIColor.appBlue.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0.6
        shapeLayer.lineCap = .round
        return shapeLayer
    }()
    let ratingCircleView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = RatingResultView.ratingCirclePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3).cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        v.layer.addSublayer(shapeLayer)
        return v
    }()
    
    let avgRatingLabel:UILabel = {
        let l = UILabel()
        l.text = "5.0"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.black
        l.font = UIFont.boldSystemFont(ofSize: 50)
        l.textAlignment = .center
        return l
    }()
    let avgRatingSubLabel:UILabel = {
        let l = UILabel()
        l.text = "Out of 10"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.lightGray
        l.font = UIFont.boldSystemFont(ofSize: 18)
        l.textAlignment = .center
        return l
    }()

    init(lowered:Bool=true) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        ratingCircleView.layer.addSublayer(ratingCircleLayer)
        self.addSubview(ratingCircleView)
        ratingCircleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ratingCircleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: lowered ? 20 : 0).isActive = true
        
        self.addSubview(avgRatingLabel)
        avgRatingLabel.centerXAnchor.constraint(equalTo: ratingCircleView.centerXAnchor).isActive = true
        avgRatingLabel.centerYAnchor.constraint(equalTo: ratingCircleView.centerYAnchor, constant: -10).isActive = true
        
        self.addSubview(avgRatingSubLabel)
        avgRatingSubLabel.topAnchor.constraint(equalTo: avgRatingLabel.bottomAnchor, constant: -4).isActive = true
        avgRatingSubLabel.centerXAnchor.constraint(equalTo: ratingCircleView.centerXAnchor).isActive = true
        avgRatingSubLabel.widthAnchor.constraint(equalTo: avgRatingLabel.widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValue(avg:Float){
        ratingCircleLayer.strokeEnd = CGFloat(avg / 10)
        avgRatingLabel.text = String(avg)
    }
    
}
