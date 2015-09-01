//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/28/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Parse

class ParseHelper {
  
  // Following Relation
  static let ParseFollowClass       = "Follow"
  static let ParseFollowFromUser    = "fromUser"
  static let ParseFollowToUser      = "toUser"
  
  // Like Relation
  static let ParseLikeClass         = "Like"
  static let ParseLikeToPost        = "toPost"
  static let ParseLikeFromUser      = "fromUser"
  
  // Post Relation
  static let ParsePostUser          = "user"
  static let ParsePostCreatedAt     = "createdAt"
  
  // Flagged Content Relation
  static let ParseFlaggedContentClass    = "FlaggedContent"
  static let ParseFlaggedContentFromUser = "fromUser"
  static let ParseFlaggedContentToPost   = "toPost"
  
  // User Relation
  static let ParseUserUsername      = "username"
  
  static func timelineRequestForCurrentUser(completionBlock: PFArrayResultBlock) {
    let followingQuery = PFQuery(className: ParseFollowClass)
    followingQuery.whereKey(ParseLikeFromUser, equalTo:PFUser.currentUser()!)
    
    let postsFromFollowedUsers = Post.query()
    postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
    
    let postsFromThisUser = Post.query()
    postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
    
    let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
    query.includeKey(ParsePostUser)
    query.orderByDescending(ParsePostCreatedAt)
    
    query.findObjectsInBackgroundWithBlock(completionBlock)
  }
  
  // MARK: Likes
  static func likePost(user: PFUser, post: Post) {
    let likeObject = PFObject(className: ParseLikeClass)
    likeObject[ParseLikeFromUser] = user
    likeObject[ParseLikeToPost] = post
    
    likeObject.saveInBackgroundWithBlock(nil)
  }
  
  static func unlikePost(user: PFUser, post: Post) {
    let query = PFQuery(className: ParseLikeClass)
    query.whereKey(ParseLikeFromUser, equalTo: user)
    query.whereKey(ParseLikeToPost, equalTo: post)
    
    query.findObjectsInBackgroundWithBlock {
      (results: [AnyObject]?, error: NSError?) -> Void in
      if let error = error {
        ErrorHandling.defaultErrorHandler(error)
      }
      
      if let results = results as? [PFObject] {
        for likes in results {
          likes.deleteInBackgroundWithBlock(nil)
        }
      }
    }
  }
  
  static func likesForPost(post: Post, completionBlock: PFArrayResultBlock) {
    let query = PFQuery(className: ParseLikeClass)
    query.whereKey(ParseLikeToPost, equalTo: post)
    query.includeKey(ParseLikeFromUser)
    
    query.findObjectsInBackgroundWithBlock(completionBlock)
  }
}
