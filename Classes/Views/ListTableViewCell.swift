//
//  PhotoListTableViewCell.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

///  This class is for List View of Photos and inherite from UITableViewCell.

import UIKit
import RealmSwift

protocol ListTableViewCellDelegate {
    func configurefavouriteButton(cell: ListTableViewCell, index: Int) -> Bool
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: ListTableViewCellDelegate?
    var index: Int = 0
    
    @IBAction func thumbnailPhotoImageView(sender: UIButton) {
        let favouriteButtonState: Bool = self.delegate?.configurefavouriteButton(self , index: index) ?? false
        let image: UIImage? = favouriteButtonState ? UIImage (named: "favourite") :  UIImage (named: "notfavourite")
        favouriteButtonOutlet.setImage(image, forState: .Normal)
    }
    
    /*!
     * @discussion This func is for configuring cell of
     * @param we pass PhotosModel(That have each photo information)
     */
    func configureListCell(photosObject: PhotosModel, index: Int, favouriteButtonState: Bool) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        self.index = index
        photoNameLabel.text = photosObject.photoName as? String
        let photoPath = photosObject.photoPath
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent((photoPath as? String) ?? "")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let image = UIImage (contentsOfFile: imagePath)
            dispatch_async(dispatch_get_main_queue()) {
                self.backgroundImageView.image = image
                let image: UIImage? = (favouriteButtonState ? UIImage (named: "favourite") : UIImage (named: "notfavourite")) ?? nil
                self.favouriteButtonOutlet.setImage(image, forState: .Normal)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
        })
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
}
