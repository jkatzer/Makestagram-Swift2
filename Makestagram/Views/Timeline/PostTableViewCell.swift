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
      // 1
      if let post = post {
        //2
        // bind the image of the post to the 'postImage' view
        post.image.bindTo(postImageView.bnd_image)
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
