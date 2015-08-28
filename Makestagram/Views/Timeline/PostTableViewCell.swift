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
  
  var post: Post? {
    didSet {
      if let post = post {
        post.image ->> postImageView
      }
    }
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
