//
//  Post.swift
//  Makestagram
//
//  Created by Chris Orcutt on 8/27/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond

class Post : PFObject, PFSubclassing {
  
  @NSManaged var imageFile: PFFile?
  @NSManaged var user: PFUser?
  
  var image: Observable<UIImage?> = Observable(nil)
  var photoUploadTask: UIBackgroundTaskIdentifier?
  
  //MARK: PFSubclassing Protocol
  static func parseClassName() -> String {
    return "Post"
  }
  
  override init() {
    super.init()
  }
  
  override class func initialize() {
    var onceToken: dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      self.registerSubclass()
    }
  }
  
  func uploadPost() {
    if let image = image.value {
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
          () -> Void in
          UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
      
      let imageData = UIImageJPEGRepresentation(image, 0.8)
      let imageFile = PFFile(data: imageData!)
      imageFile.saveInBackgroundWithBlock(nil)
      
      user = PFUser.currentUser()
      self.imageFile = imageFile
      saveInBackgroundWithBlock { (success, error) -> Void in
        UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
      }
    }
  }
  
  func downloadImage() {
    if (image.value == nil) {
      imageFile?.getDataInBackgroundWithBlock { (data, error) -> Void in
        if let data = data {
          let image = UIImage(data: data, scale:1.0)!
          self.image.next(image)
        }
      }
    }
  }
  
}