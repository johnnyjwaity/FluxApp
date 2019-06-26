//
//  OptionPostCell.swift
//  Flux
//
//  Created by Johnny Waity on 3/31/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class OptionPostCell: PostCell {
    
    let optionScreen = UIView()
    var optionRightAnchor:NSLayoutConstraint!
    let resultScreen = UIView()
    var resultLeftAnchor:NSLayoutConstraint!
    
    override func setup() {
        super.setup()
        content.clipsToBounds = true
        
        optionScreen.backgroundColor = UIColor.white
        optionScreen.layer.cornerRadius = 8
        optionScreen.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(optionScreen)
        optionRightAnchor = optionScreen.rightAnchor.constraint(equalTo: content.rightAnchor)
        optionRightAnchor.isActive = true
        optionScreen.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        optionScreen.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        optionScreen.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        
        
        resultScreen.backgroundColor = UIColor.white
        resultScreen.layer.cornerRadius = 8
        resultScreen.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(resultScreen)
        resultLeftAnchor = resultScreen.leftAnchor.constraint(equalTo: content.rightAnchor)
        resultLeftAnchor.isActive = true
        resultScreen.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        resultScreen.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        resultScreen.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        
    }
    override func update(_ post:Post){
        super.update(post)
        for view in optionScreen.subviews {
            view.removeFromSuperview()
        }
        for view in resultScreen.subviews {
            view.removeFromSuperview()
        }
        resultLeftAnchor.constant = 0
        optionRightAnchor.constant = 0
        content.layoutIfNeeded()
        
        var counter = 0
        var prevButton:UIButton!
        for option in post.choices! {
            let optionButton = UIButton(type: .system)
            optionButton.setTitle(option, for: .normal)
            optionButton.backgroundColor = UIColor.appGreen
            if let colors = post.colors {
                optionButton.backgroundColor = UIColor.postColors[colors[counter]]
            }
            optionButton.tag = counter
            optionButton.setTitleColor(UIColor.white, for: .normal)
            optionButton.translatesAutoresizingMaskIntoConstraints = false
            optionButton.layer.cornerRadius = 25
            optionButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            optionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            optionButton.titleLabel?.adjustsFontSizeToFitWidth = true
            optionButton.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
            optionScreen.addSubview(optionButton)
            if post.choices!.count % 2 != 0 && counter == post.choices!.count - 1 {
                optionButton.leftAnchor.constraint(equalTo: optionScreen.leftAnchor, constant: 10).isActive = true
                optionButton.rightAnchor.constraint(equalTo: optionScreen.rightAnchor, constant: -5).isActive = true
                optionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                optionButton.topAnchor.constraint(equalTo: counter == 0 ? optionScreen.topAnchor : prevButton.bottomAnchor, constant: 10).isActive = true
            }else if counter % 2 == 0{
                optionButton.leftAnchor.constraint(equalTo: optionScreen.leftAnchor, constant: 10).isActive = true
                optionButton.rightAnchor.constraint(equalTo: optionScreen.centerXAnchor, constant: -5).isActive = true
                optionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                optionButton.topAnchor.constraint(equalTo: counter == 0 ? optionScreen.topAnchor : prevButton.bottomAnchor, constant: 10).isActive = true
            }else{
                optionButton.leftAnchor.constraint(equalTo: optionScreen.centerXAnchor, constant: 5).isActive = true
                optionButton.rightAnchor.constraint(equalTo: optionScreen.rightAnchor, constant: -5).isActive = true
                optionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                optionButton.topAnchor.constraint(equalTo: prevButton.topAnchor, constant: 0).isActive = true
            }
            prevButton = optionButton
            counter += 1
        }
        if post.didAnswer() && post.showingResults {
            showAnswers(post.getAnswers(), animated: false)
        }else if post.didAnswer() {
            showAnswers(post.getAnswers())
        }
    }
    
    @objc
    func click(_ sender:UIButton){
        post.answerOption(sender.tag)
        showAnswers(post.getAnswers())
    }
    
    
    func showAnswers(_ results:[Int], animated:Bool = true){
        self.post.showingResults = true
        
        
        optionRightAnchor.constant = -content.bounds.width
        resultLeftAnchor.constant = -content.bounds.width
        
        for view in resultScreen.subviews {
            view.removeFromSuperview()
        }
        
        let returnButton = UIButton()
        returnButton.setTitle("Change Answer", for: .normal)
        returnButton.setTitleColor(UIColor.white, for: .normal)
        returnButton.backgroundColor = UIColor.appBlue
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        returnButton.layer.cornerRadius = 17.5
        resultScreen.addSubview(returnButton)
        returnButton.bottomAnchor.constraint(equalTo: resultScreen.bottomAnchor, constant: -10).isActive = true
        returnButton.centerXAnchor.constraint(equalTo: resultScreen.centerXAnchor).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        returnButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        returnButton.addTarget(self, action: #selector(switchToButtonScreen), for: .touchUpInside)
        
        var counter = 0
        var bars:[UIView] = []
        var info:[(bar:UIView, constraint:NSLayoutConstraint, percent:UILabel, percentLeftConstraint:NSLayoutConstraint)] = []
        for choice in post.choices ?? [] {
            let choiceLabel = UILabel()
            choiceLabel.text = choice
            choiceLabel.textColor = UIColor.appBlue//UIColor.postColors[post.colors?[counter] ?? "b"]
            choiceLabel.font = UIFont.boldSystemFont(ofSize: 20)
            choiceLabel.translatesAutoresizingMaskIntoConstraints = false
            choiceLabel.textAlignment = .center
            resultScreen.addSubview(choiceLabel)
            if bars.count == 0 {
                choiceLabel.topAnchor.constraint(equalTo: resultScreen.topAnchor).isActive = true
            }else{
                choiceLabel.topAnchor.constraint(equalTo: bars.last!.bottomAnchor, constant: 10).isActive = true
            }
            choiceLabel.leftAnchor.constraint(equalTo: resultScreen.leftAnchor).isActive = true
            choiceLabel.rightAnchor.constraint(equalTo: resultScreen.rightAnchor).isActive = true
            choiceLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            let bar = UIView()
            bar.backgroundColor = UIColor.postColors[post.colors?[counter] ?? "b"]
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.layer.cornerRadius = 11
            bars.append(bar)
            resultScreen.addSubview(bar)
            bar.topAnchor.constraint(equalTo: choiceLabel.bottomAnchor, constant: 5).isActive = true
            bar.leftAnchor.constraint(equalTo: resultScreen.leftAnchor, constant: 10).isActive = true
            let widthAnchor = bar.widthAnchor.constraint(equalToConstant: 0)
            widthAnchor.isActive = true
            bar.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            let percentLabel = UILabel()
            percentLabel.text = "0%"
            percentLabel.textColor = UIColor.postColors[post.colors?[counter] ?? "b"]
            percentLabel.font = UIFont.boldSystemFont(ofSize: 18)
            percentLabel.translatesAutoresizingMaskIntoConstraints = false
            resultScreen.addSubview(percentLabel)
            let leftPercent = percentLabel.leftAnchor.constraint(equalTo: bar.rightAnchor, constant: 5)
            leftPercent.isActive = true
            percentLabel.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
            percentLabel.rightAnchor.constraint(equalTo: resultScreen.rightAnchor).isActive = true
            info.append((bar: bar, constraint: widthAnchor, percent: percentLabel, percentLeftConstraint: leftPercent))
            counter += 1
        }
        
        let originalID = post.postID
        UIView.animate(withDuration: animated ? 0.3 : 0, delay: 0, options: .curveEaseIn, animations: {
            self.content.layoutIfNeeded()
        }) { (completed) in
            (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).invalidateLayout()
            UIView.animate(withDuration: animated ? 0.2 : 0, delay: 0, options: .curveLinear, animations: {
                self.collectionView.layoutIfNeeded()
                
            }, completion: { (completed) in
                if self.post.postID != originalID {
                    return
                }
                let totalResponses = results.reduce(0, +)
                var counter = 0
                for result in results {
                    let percent:Double = Double(result) / Double(totalResponses)
                    info[counter].constraint.constant = CGFloat((Double(self.content.frame.width) - 75.0) * percent)
                    info[counter].percent.text = "\(Int(round(percent * 100)))%"
                    if percent == 0 {
                        let size = info[counter].percent.intrinsicContentSize.width
                        let constant = (self.content.bounds.width / 2) - 10 - (size / 2)
                        info[counter].percentLeftConstraint.constant = constant
                    }
                    counter += 1
                }
                UIView.animate(withDuration: animated ? 0.2 : 0, animations: {
                    self.resultScreen.layoutIfNeeded()
                    
                }, completion: nil)
            })
        }
    }
    
    @objc
    func switchToButtonScreen(){
        post.showingResults = false
        optionRightAnchor.constant = 0
        resultLeftAnchor.constant = 0
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).invalidateLayout()
        UIView.animate(withDuration: 0.3) {
            self.content.layoutIfNeeded()
            self.collectionView.layoutIfNeeded()
        }
    }
}
//print("Result \(post.question) \(results)")
//for b in bars.values {
//    b.removeFromSuperview()
//}
//for b in bars.keys {
//    bars[b] = nil
//}
//for key in xCon.keys {
//    xCon[key]?.isActive = false
//    leftCon[key]?.isActive = true
//    widthCon[key]?.constant = 100
//}
//let currentQuestion = post.question
//UIView.animate(withDuration: 0.3, animations: {
//    self.layoutIfNeeded()
//}) { (completed) in
//    if currentQuestion != self.post.question {
//        return
//    }
//    var widthAnchors:[UIView:NSLayoutConstraint] = [:]
//    var widths:[UIView:CGFloat] = [:]
//    for key in self.xCon.keys {
//        if self.bars[key] == nil {
//            let barLeft = key.bounds.maxX + 10
//            let barRight = self.bounds.maxX - 20
//            let maxWidth = barRight - barLeft
//            //                    print("Before \(results)")
//            let totalVotes = results.reduce(0, +)
//            //                    print("After \(results)")
//            let bar = UIView()
//            bar.translatesAutoresizingMaskIntoConstraints = false
//            //                    bar.backgroundColor = UIColor.red
//            bar.clipsToBounds = true
//            bar.layer.cornerRadius = 35.0 / 2
//            bar.alpha = 0
//            self.content.addSubview(bar)
//            bar.leftAnchor.constraint(equalTo: key.rightAnchor, constant: 10).isActive = true
//            bar.centerYAnchor.constraint(equalTo: key.centerYAnchor).isActive = true
//            bar.heightAnchor.constraint(equalToConstant: 35).isActive = true
//            widthAnchors[bar] = bar.widthAnchor.constraint(equalToConstant: 0)
//            widthAnchors[bar]?.isActive = true
//            //                    print(self.post.question)
//            //                    print(results)
//            //                    print(key.tag)
//            widths[bar] = CGFloat(results[key.tag] / totalVotes) * maxWidth
//            if widths[bar]! < 35.0 && widths[bar]! != 0{
//                widths[bar] = 35
//            }
//            self.bars[key] = bar
//            if let colors = self.post.colors {
//                bar.backgroundColor = UIColor.postColors[colors[key.tag]]
//            }else{
//                let gradientLayer = CAGradientLayer()
//                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//                gradientLayer.colors = [UIColor.appBlue.cgColor, UIColor.appGreen.cgColor]
//                gradientLayer.frame = CGRect(x: 0, y: 0, width: widths[bar]!, height: 35)
//                gradientLayer.masksToBounds = true
//                bar.layer.addSublayer(gradientLayer)
//            }
//        }
//    }
//    self.layoutIfNeeded()
//    UIView.animate(withDuration: 0.3, animations: {
//        for bar in widthAnchors.keys {
//            bar.alpha = 1
//        }
//    }, completion: { (completed) in
//        for key in widthAnchors.keys {
//            widthAnchors[key]?.constant = widths[key]!
//        }
//        UIView.animate(withDuration: 0.3, animations: {
//            self.layoutIfNeeded()
//        })
//    })
//
//}
