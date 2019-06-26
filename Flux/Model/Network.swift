//
//  Network.swift
//  Flux
//
//  Created by Johnny Waity on 4/21/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import JWTDecode

class Network{
    static var authToken:String? = nil
    
    
    static func request(url:String, type:HTTPMethod, paramters:[String:Any]?, auth:Bool = false, callback:@escaping (_ response:[String:Any], _ error:NSError?) -> Void = { _,_  in }){
        var headers:HTTPHeaders = [:]
        if auth {
            headers["Authorization"] = authToken
        }
        URLSessionConfiguration.default.timeoutIntervalForRequest = 3
        URLSessionConfiguration.default.timeoutIntervalForResource = 3
        Alamofire.request(url, method: type, parameters: paramters, encoding: JSONEncoding.default, headers: headers).validate(contentType: ["application/json"]).responseJSON { (response) in
            if let d = response.data {
                do{
                    let json = try JSON(data: d)
                    if let dict = json.dictionaryObject {
                        if let success = dict["success"] as? Bool {
                            if success {
                                callback(dict, nil)
                            }else{
                                if let reason = dict["reason"] as? String {
                                    callback(dict, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(reason, comment: reason), NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, comment: reason)]))
                                }else{
                                    callback(dict, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Unknown", comment: "Error Unkown"), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unkown", comment: "Unknown Error")]))
                                }
                            }
                        }else{
                            callback(["success": false], NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Unknown", comment: "Error Unkown"), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unkown", comment: "Unknown Error")]))
                        }
                    }else{
                        callback(["success": false], NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Unknown", comment: "Error Unkown"), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unkown", comment: "Unknown Error")]))
                    }
                }catch {
                    callback(["success": false], NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Unknown", comment: "Error Unkown"), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unkown", comment: "Unknown Error")]))
                    print(error)
                }
            }else{
                callback(["success": false], NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Unknown", comment: "Error Unkown"), NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unkown", comment: "Unknown Error")]))
            }
        }
    }
    
    static func uploadImage(image:UIImage) {
        var scaledImage = image
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        scaledImage.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        scaledImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        var username:String? = nil
        do{
            let jwt = try decode(jwt: Network.authToken!)
            username = (jwt.body["uID"] as! String)
        }catch{
            print(error)
        }
        if let u = username, let dat = scaledImage.pngData() {
            var headers:HTTPHeaders = [:]
            headers["Authorization"] = authToken
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(dat, withName: "picture", fileName: "\(u).png", mimeType: "image/png")
            }, to: "https://api.tryflux.app:3000/uploadProfile", method: .post, headers: headers, encodingCompletion: { (result) in
                print(result)
            })
        }
    }
    
    static func downloadImage(user:String, callback:@escaping (UIImage?)->Void){
        
        
//        let downloadDestination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory)
        
        Network.request(url: "https://api.tryflux.app:3000/hasProfilePicture?user=\(user)", type: .get, paramters: nil) { (response, err) in
            if let error = err {
                print(error)
                callback(nil)
                return
            }
            if let exists = response["exists"] as? Bool {
                if exists{
//                    Network.deleteCache()
//                    Alamofire.download("https://api.tryflux.app:3000/profilePicture?user=\(user)", method: .get, to: downloadDestination).response(completionHandler: { (response) in
//                        do{
//                            let image = UIImage(data: try Data(contentsOf: response.destinationURL!))
////                            Network.deleteCache()
//                            if let i = image {
//                                callback(i)
//                            }else{
//                                print("No Image")
//                                callback(nil)
//                            }
//
//                        }catch{
//                            print(error)
//                            callback(nil)
//                        }
//                    })
                    Alamofire.request("https://api.tryflux.app:3000/profilePicture?user=\(user)", method: .get).validate().responseData(completionHandler: { (responseData) in
                        if let dat = responseData.data {
                            let image = UIImage(data: dat)
                            callback(image)
                        }else{
                            callback(nil)
                        }
                    })
                }else{
                    callback(nil)
                }
            }else{
                callback(nil)
            }
        }
    }
    
    static func deleteCache(){
        let fileManager = FileManager.default
        var path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        path.appendPathComponent("profilePicture.png")
        //        print(path.relativeString)
        if fileManager.fileExists(atPath: path.absoluteString.components(separatedBy: "ile://")[1]){
            do {
                try fileManager.removeItem(at: path)
            }catch{
                print(error)
            }
            
        }
    }
}
