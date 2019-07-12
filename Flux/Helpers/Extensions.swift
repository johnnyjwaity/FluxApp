import UIKit

extension UIColor {
    static let appGreen:UIColor = UIColor(red: 112.0 / 255, green: 241.0 / 255, blue: 135.0 / 255, alpha: 1)
    static let appBlue:UIColor = UIColor(red: 68.0 / 255, green: 153.0 / 255, blue: 243.0 / 255, alpha: 1)
    static let postColors:[String:UIColor] = ["r":UIColor.red, "o": UIColor.orange, "g": UIColor.appGreen, "b": UIColor.appBlue, "p":UIColor.purple]
}

extension Date {
    static func fromStamp(_ stamp:String) -> Date {
        var components = DateComponents()
        let c = stamp.components(separatedBy: ":")
        let dc = c[0].components(separatedBy: "-")
        let tc = c[1].components(separatedBy: "-")
        components.month = Int(dc[0])
        components.day = Int(dc[1])
        components.year = Int(dc[2])
        components.hour = Int(tc[0])
        components.minute = Int(tc[1])
        components.second = Int(tc[2])
        let date = NSCalendar.current.date(from: components)
        return date!
    }
    
    static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy:HH-mm-ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "M/dd/YY h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func getUserRanges() -> [NSRange] {
        let str = NSMutableAttributedString(string: self)
        var ranges:[NSRange] = []
        var foundAt:Bool = false
        var startIndex:Int = -1
        var counter = 0
        for char in str.string {
            if !foundAt {
                if char == "@" {
                    foundAt = true
                    startIndex = counter
                }
            }else{
                if char == " " || char == "\n" {
                    foundAt = false
                    ranges.append(NSRange(location: startIndex, length: counter - startIndex))
                }
            }
            counter += 1
        }
        if foundAt {
            ranges.append(NSRange(location: startIndex, length: counter - startIndex))
        }
        return ranges
    }
    
    func highlightUsers(underline:Bool = false) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(string: self)
        let ranges = getUserRanges()
        for range in ranges {
            if !underline {
                str.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.appBlue], range: range)
            }else{
                str.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
            }
        }
        return str
    }
    
    subscript(_ range: NSRange) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let subString = self[start..<end]
        return String(subString)
    }
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
