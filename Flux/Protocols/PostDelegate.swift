//
//  PostDelegate.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import Foundation

protocol PostDelegate {
    func openProfile(for user:String)
    func openComments(for postID:String)
    func refreshPost(for postID:String)
    func sharePost(for postID:String)
}
