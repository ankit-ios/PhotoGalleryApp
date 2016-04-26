//
//  ImageDownloader.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 26/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

import UIKit

class DownloadingOperations {
    var downloadsInProgress = [NSIndexPath:NSOperation]()
    var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


class ImageDownloader: NSOperation {
    
   var imagePath: String
   
    override func main() {
        if self.cancelled {
            return
        }
       // let imageData = NSData(contentsOfURL:self.photoRecord.url)
        let image = UIImage (contentsOfFile: imagePath)
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            self.photoRecord.image = UIImage(data:imageData!)
            self.photoRecord.state = .Downloaded
        }
        else
        {
            self.photoRecord.state = .Failed
            self.photoRecord.image = UIImage(named: "Failed")
        }
    }
    
}
