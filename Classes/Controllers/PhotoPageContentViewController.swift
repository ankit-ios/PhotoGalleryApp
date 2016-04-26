//
//  PhotoSwipeViewController.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is for take Photos from pageViewController and display in UIView.

import UIKit
import RealmSwift

class PhotoPageContentViewController: UIViewController {
    
    @IBOutlet weak var photosImageView: UIImageView!
    
    var photoPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        let filename = getDocumentsDirectory().stringByAppendingPathComponent((photoPath ?? ""))
        dispatch_async(dispatch_get_main_queue()){
            self.photosImageView.image = UIImage (contentsOfFile: filename )
        }
    }
    
    /*!
     * @discussion This is for finding local path of local directory
     * @return Given local path of Document in simulator where all images is stored
     */
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func configureImageView() {
        photosImageView.layer.cornerRadius = 5.0
        photosImageView.layer.shadowRadius = 5.0
        photosImageView.layer.shadowColor = UIColor.blackColor().CGColor
        photosImageView.clipsToBounds = true
    }
}