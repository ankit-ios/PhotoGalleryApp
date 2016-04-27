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
    @IBOutlet var pageContentView: UIView!
    
    var photoPath: String?
    
    override func viewDidLoad() {
        configureImageView()
        initializeGestureRecognizer()
        setImageInImageView()
        super.viewDidLoad()
    }
}

private extension PhotoPageContentViewController {
    
    private func initializeGestureRecognizer() {
        //For RotateGesture Recoginzation
        let rotateGesture: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(PhotoPageContentViewController.recognizeRotateGesture))
        pageContentView.addGestureRecognizer(rotateGesture)
        
        //For PinchGesture Recoginzation
        let pinchGesture: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(PhotoPageContentViewController.recognizePinchGesture))
        pageContentView.addGestureRecognizer(pinchGesture)
    }
    @objc func recognizeRotateGesture(sender: UIRotationGestureRecognizer) {
        sender.view!.transform = CGAffineTransformRotate(sender.view!.transform, sender.rotation)
        sender.rotation = 0
    }
    
    @objc func recognizePinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1
    }
    
    /**
     This func is used for configure ImageView, ImageView Border, ImageView shadow
     */
    private func configureImageView() {
        photosImageView.layer.cornerRadius = 5.0
        photosImageView.layer.shadowRadius = 5.0
        photosImageView.layer.borderWidth = 2.0
        photosImageView.clipsToBounds = true
        let color = UIColor.blackColor().CGColor
        photosImageView.layer.shadowColor = color
        photosImageView.layer.borderColor = color
    }
    
    /**
     This func is used for setting the image in imageview which is fetched from localfile
     */
    private func setImageInImageView() {
        let filename = getDocumentsDirectory().stringByAppendingPathComponent((photoPath ?? ""))
        dispatch_async(dispatch_get_main_queue()){
            self.photosImageView.image = UIImage (contentsOfFile: filename )
        }
    }
    
    /*!
     * @discussion This is for finding local path of local directory
     * @return Given local path of Document in simulator where all images is stored
     */
    private func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}