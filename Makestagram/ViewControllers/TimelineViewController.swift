//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/25/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class TimelineViewController: UIViewController, TimelineComponentTarget {

  var timelineComponent: TimelineComponent<Post, TimelineViewController>!
  
  let defaultRange = 0...4
  let additionalRangeSize = 5
  
  @IBOutlet weak var tableView: UITableView!
  
  var photoTakingHelper: PhotoTakingHelper?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timelineComponent = TimelineComponent(target: self)
    self.tabBarController?.delegate = self
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    timelineComponent.loadInitialIfRequired()
  }
  
  func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
    // 1
    ParseHelper.timelineRequestForCurrentUser(range) {
      (result: [AnyObject]?, error: NSError?) -> Void in
      // 2
      let posts = result as? [Post] ?? []
      // 3
      completionBlock(posts)
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
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return timelineComponent.content.count
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeader") as! PostHeaderTableViewCell
    
    let post = self.timelineComponent.content[section]
    headerCell.post = post
    
    return headerCell
  }

  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
    
    let post = timelineComponent.content[indexPath.section]
    post.downloadImage()
    post.fetchLikes()
    cell.post = post
    
    return cell
  }
}

extension TimelineViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
      timelineComponent.targetWillDisplayEntry(indexPath.section)
  }
}

