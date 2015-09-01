//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/25/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var posts: [Post] = []
  var photoTakingHelper: PhotoTakingHelper?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tabBarController?.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    ParseHelper.timelineRequestForCurrentUser { (results, error) -> Void in
      self.posts = results as? [Post] ?? []
      self.tableView.reloadData()
    }
  }
}

// MARK: UITabBarControllerDelegate
extension TimelineViewController: UITabBarControllerDelegate {
  
  func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
    if (viewController is PhotoViewController) {
      takePhoto()
      return false
    } else {
      return true
    }
  }
  
  func takePhoto() {
    photoTakingHelper =
      PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
        let post = Post()
        post.image.next(image!)
        post.uploadPost()
    }
  }
}

extension TimelineViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
    let post = posts[indexPath.row]
    post.downloadImage()
    cell.post = post
    return cell
  }
}


