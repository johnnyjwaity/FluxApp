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
