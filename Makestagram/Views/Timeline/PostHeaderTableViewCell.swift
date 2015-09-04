//
//  PostHeaderTableViewCell.swift
//  Makestagram
//
//  Created by Orcudy on 9/4/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit

class PostHeaderTableViewCell: UITableViewCell {
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!

  var post: Post? {
    didSet {
      if let post = post {
        usernameLabel.text = post.user?.username
        timeLabel.text = post.createdAt?.shortTimeAgoSinceNow() ?? ""
      }
    }
  }
}
