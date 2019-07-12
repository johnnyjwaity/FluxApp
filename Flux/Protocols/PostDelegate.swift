//
//  PostDelegate.swift
//  Flux
//
//  Created by Johnny Waity on 7/4/19.
//  Copyright © 2019 Johnny Waity. All rights reserved.
//

import Foundation

protocol PostDelegate {
    func openProfile(for postID:String)
    func openComments(for postID:String)
    func postState(for postID:String) -> PostState
    func setPostState(for postID:String, with state:PostState)
    func answerPost(for postID:String, with answer:Int)
    func getAnswers(for postID:String) -> [Int]
    func getCommentCount(for postID:String) -> Int
    func getPostChoices(for postID:String) -> [String]
    func getPostColors(for postID:String) -> [String]
    func refreshPost(for postID:String)
}
