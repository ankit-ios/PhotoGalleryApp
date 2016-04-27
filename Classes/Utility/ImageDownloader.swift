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
 * @discussion This class is for create NSOperation Queue and use Cache, here we add all NSOperation into this Queue and execute one by one.
 */
class DownloadingOperationsQueue {
    let cache = NSCache()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
    
    init() {
        // Max. cache size is 10% of available physical memory (in MB's)
        cache.totalCostLimit = 200 * 1024 * 1024 // TODO: change to 10%
    }
    
    /*!
     * @discussion This func is for fetching images from local file. first it search into cache, if present then back and set image on cell, otherwise fetch and then save into cache.
     */
    func startDownloading(imageName: String, completion: (image: UIImage?) -> Void) {
        
        if let image = self.cache.objectForKey(imageName) as? UIImage {
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                completion(image: image)
            }
            return
        }
        
        let imageDownloader = ImageDownloader(imageName: imageName)
        imageDownloader.queuePriority = .VeryLow
        imageDownloader.qualityOfService = .Background
        imageDownloader.completionBlock = {
            if imageDownloader.cancelled {
                return
            }
        }
        
        self.downloadQueue.addOperation(imageDownloader)
        
        imageDownloader.completionBlock = {
            [unowned self] in
            if imageDownloader.cancelled {
                return
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                [unowned self] in
                if imageDownloader.image != nil {
                    self.cache.setObject(imageDownloader.image!, forKey: imageName)
                }
                completion(image: imageDownloader.image)
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
            let imagePath = self.getDocumentsDirectory().stringByAppendingPathComponent(self.imageName)
            self.image = UIImage (contentsOfFile: imagePath) ?? UIImage()
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
    private func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
