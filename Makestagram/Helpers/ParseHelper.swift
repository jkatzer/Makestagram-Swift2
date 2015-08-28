//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/28/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Parse

class ParseHelper {
  static func timelineRequestForCurrentUser(completionBlock: PFArrayResultBlock) {
    let followingQuery = PFQuery(className: "Follow")
    followingQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
    
    let postsFromFollowedUsers = Post.query()
    postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
   
    let postsFromCurrentUser = Post.query()
    postsFromCurrentUser?.whereKey("user", equalTo: PFUser.currentUser()!)
    
    let query = PFQuery.orQueryWithSubqueries([postsFromCurrentUser!, postsFromFollowedUsers!])
    query.includeKey("user")
    query.orderByDescending("createdAt")
    
    query.findObjectsInBackgroundWithBlock(completionBlock)
  }
}
