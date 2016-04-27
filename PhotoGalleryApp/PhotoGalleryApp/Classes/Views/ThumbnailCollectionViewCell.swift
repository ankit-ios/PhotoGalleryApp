//
//  ThumbnailCollectionViewCell.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/**
 *  This class is for ThumbnailView of Photos and inherite from UICollectionViewCell.
 */

import UIKit
import RealmSwift

protocol ThumbnailCollectionViewCellDelegate: class {
    func configurefavouriteButton(cell: ThumbnailCollectionViewCell, index: Int) -> Bool
    func deletePhoto(cell: ThumbnailCollectionViewCell, index: Int)
}

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var thumbnailPhotoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let downloadingOperationsQueue = DownloadingOperationsQueue()
    weak var delegate: ThumbnailCollectionViewCellDelegate?
    var index: Int = 0
    
    /*!
     * @discussion This is favourite Button action, when we tap on favourite button then delegate pass to PhotoThumbnailController and conferm protocol
     * @param we pass ThumbnailCollectionViewCell and currnet selected collection view cell index
     */
    
    @IBAction func favouriteButton(sender: UIButton) {
        let favouriteButtonState: Bool = self.delegate?.configurefavouriteButton(self , index: index) ?? false
        let image: UIImage? = favouriteButtonState ? UIImage (named: "favourite") :  UIImage (named: "notfavourite")
        favouriteButtonOutlet.setImage(image, forState: .Normal)
        
    }
    
    /*!
     * @discussion This func is for configuring cell of collection view (Thumbnail View of Photos)
     * @param imagePath for local path of image, index for add value into self.index for each cell, state
     */
    func configureThumbnailCell(imageName: String , index: Int, favouriteButtonState: Bool) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        thumbnailPhotoImageView.image = UIImage(named: "defaultImage")
        let image: UIImage? = (favouriteButtonState ? UIImage (named: "favourite") : UIImage (named: "notfavourite")) ?? nil
        self.favouriteButtonOutlet.setImage(image, forState: .Normal)
        self.index = index
        
        let imageDownloader = ImageDownloader(imageName: imageName)
        imageDownloader.delegate = self
        imageDownloader.queuePriority = .VeryLow
        imageDownloader.qualityOfService = .Background
        imageDownloader.completionBlock = {
            if imageDownloader.cancelled {
                return
            }
        }
        self.downloadingOperationsQueue.downloadQueue.addOperation(imageDownloader)
    }
    
    func deletePhoto()  {
        delegate?.deletePhoto(self, index: index)
    }
}

// MARK: - ImageDownloader Delegate
extension ThumbnailCollectionViewCell: ImageDownloaderDelegate {
    
    func downlodedImage(imageDownloader: ImageDownloader, image: UIImage) {
        self.thumbnailPhotoImageView.image = image
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
}

