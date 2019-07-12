//
//  PostDelegate.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import Foundation

protocol PostDelegate {
    func openProfile(_ user:String)
    func openComments(_ post:Post)
}
