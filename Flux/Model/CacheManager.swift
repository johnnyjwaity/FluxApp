//
//  CacheManager.swift
//  Flux
//
//  Created by Johnny Waity on 6/26/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import UIKit

class CacheManager {
    static var profilePictures:[String:UIImage] = [:]
    
    static func clearCache(){
        profilePictures = [:]
    }
}
