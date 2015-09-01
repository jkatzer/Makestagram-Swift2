//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/28/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import Bond

class PostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var postImageView: UIImageView!
 
  @IBOutlet weak var likesIconImageView: UIImageView!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var moreButton: UIButton!
  
  @IBAction func tappedLikeButton(sender: AnyObject) {
    likeButton.selected = !likeButton.selected
  }
  var post: Post? {
    didSet {
      if let post = post {
        post.image.bindTo(postImageView.bnd_image)
      }
    }
  }
  
}
