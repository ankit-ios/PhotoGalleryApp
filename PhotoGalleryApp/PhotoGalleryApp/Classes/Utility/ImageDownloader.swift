//
//  ImageDownloader.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 26/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is for download Photo by NSOperation Queue

import UIKit

/// This Protocol used for send back downloaded Photo

protocol ImageDownloaderDelegate: class {
    func downlodedImage(imageDownloader: ImageDownloader, image: UIImage)
}

/// This is userdefined NSOperation Queue, we add all the operation in it

class DownloadingOperationsQueue {
    var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}

/// This class is inherit from NSOperation and this is used for downloading images from local file.

class ImageDownloader: NSOperation {
    weak var delegate: ImageDownloaderDelegate?
    var imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            let imagePath = self.getDocumentsDirectory().stringByAppendingPathComponent(self.imageName)
            let image = UIImage (contentsOfFile: imagePath)
            if let image = image {
                self.delegate?.downlodedImage(self, image: image)
            }
        }
        if self.cancelled {
            return
        }
    }
}

private extension ImageDownloader {
    /*!
     * @discussion This is for finding local path of local directory
     * @return Given local path of Document in simulator where all Photos is stored
     */
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
