//
//  ImageDownloader.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 26/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is for download Photo by NSOperation Queue

import UIKit
import Foundation

/*!
 * @discussion This Structure is used for getting the current local directory in simulator, where all the images are stored
 * @return local path(document folder in simulator, there all images are stored)
 */
struct GetDirectoryPath {
    static func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

/*!
 * @discussion This extension override for create sharedInstance for cache. because of this , images fetches only one time but after all images stored in cache like NSMutable Dictionary form. so i access again, that time it is not fetch, automatically set from cache.
 * @return static instance for cache (means only one time saved images in cache, and we can access in whole controller until application is not finished)
 */
extension NSCache {
    class var sharedInstance : NSCache {
        struct Static {
            static let instance : NSCache = NSCache()
        }
        return Static.instance
    }
}

/*!
 * @discussion This class is for create NSOperation Queue and use Cache, here we add all NSOperation into this Queue and execute one by one.
 */
class DownloadingOperationsQueue {
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    init() {
        // Max. cache size is 10% of available physical memory (in MB's)
        NSCache.sharedInstance.totalCostLimit = 200 * 1024 * 1024 // TODO: change to 10%
    }
    
    /*!
     * @discussion This func is for fetching images from local file. first it search into cache, if present then back and set image on cell, otherwise fetch and then save into cache.
     */
    func startDownloading(imageName: String, completion: (image: UIImage?) -> Void) {
        if let image = NSCache.sharedInstance.objectForKey(imageName) as? UIImage {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                completion(image: image)
            }
            return
        }
        
        let imageDownloader = ImageDownloader(imageName: imageName)
        imageDownloader.queuePriority = .VeryLow
        imageDownloader.qualityOfService = .Background
        
        self.downloadQueue.addOperation(imageDownloader)
        imageDownloader.completionBlock = {
            if imageDownloader.cancelled {
                return
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                let imageData = imageDownloader.image
                if imageData != nil {
                    NSCache.sharedInstance.setObject(imageData!, forKey: imageName)
                }
                completion(image: imageData)
                imageDownloader.cancel()
            }
        }
    }
}

/// This class is inherit from NSOperation and this is used for fetching images from local file.
class ImageDownloader: NSOperation {
    var imageName: String
    var image: UIImage?
    
    init(imageName: String) {
        self.imageName = imageName
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            [unowned self] in
            // TODO: get localPath, there all images are saving
            let imagePath = GetDirectoryPath.getDocumentsDirectory().stringByAppendingPathComponent(self.imageName)
            self.image = UIImage (contentsOfFile: imagePath) ?? UIImage()
        }
        
        if self.cancelled {
            return
        }
    }
}
