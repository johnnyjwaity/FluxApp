//
//  LinkedAccounts.swift
//  Flux
//
//  Created by Johnny Waity on 7/1/20.
//  Copyright © 2020 Johnny Waity. All rights reserved.
//

import Foundation
import SCSDKBitmojiKit
import SCSDKLoginKit


class LinkedAccounts {
    
    static var shared:LinkedAccounts!
    
    init() {
        LinkedAccounts.shared = self
        print("Snapchat Linked \(SCSDKLoginClient.isUserLoggedIn)")
    }
    
    func isLinked(_ type:LinkedAccountType) -> Bool{
        if type == .Snapchat {
            return SCSDKLoginClient.isUserLoggedIn
        }
        return false
    }
    
    func linkAccount(_ type:LinkedAccountType, completion: @escaping (Bool) -> Void){
        if type == .Snapchat {
            linkSnapchat(completion)
            return
        }
        completion(false)
    }
    
    func unlinkAccount(_ type:LinkedAccountType, completion: @escaping (Bool) -> Void) {
        if type == .Snapchat {
            SCSDKLoginClient.unlinkAllSessions(completion: completion)
        }else {
            completion(false)
        }
    }
    
    func linkSnapchat(_ completion: @escaping (Bool) -> Void){
        if SCSDKLoginClient.isUserLoggedIn {
            completion(true)
            return
        }
        SCSDKLoginClient.login(from: FluxTabBarController.shared) { (loggedIn, error) in
            if let e = error {
                print(e.localizedDescription)
                completion(false)
                return
            }
            completion(loggedIn)
        }
    }
}
enum LinkedAccountType {
    case Snapchat
    case Twitter
}
