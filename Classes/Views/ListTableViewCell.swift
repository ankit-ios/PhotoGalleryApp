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

protocol ListTableViewCellDelegate: class {
    func configurefavouriteButton(cell: ListTableViewCell, index: Int) -> Bool
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let downloadingOperationsQueue = DownloadingOperationsQueue()
    weak var delegate: ListTableViewCellDelegate?
    var index: Int = 0
    
    @IBAction func listPhotoImageView(sender: UIButton) {
        let favouriteButtonState: Bool = self.delegate?.configurefavouriteButton(self , index: index) ?? false
        let image: UIImage? = favouriteButtonState ? UIImage (named: "favourite") :  UIImage (named: "notfavourite")
        favouriteButtonOutlet.setImage(image, forState: .Normal)
    }
    
    /*!
     * @discussion This func is for configuring cell of
     * @param we pass PhotosModel(That have each photo information)
     */
    func configureListCell(photosObject: PhotosModel, index: Int, favouriteButtonState: Bool) {
        self.index = index
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        let image: UIImage? = (favouriteButtonState ? UIImage (named: "favourite") : UIImage (named: "notfavourite")) ?? nil
        self.favouriteButtonOutlet.setImage(image, forState: .Normal)
        
        photoNameLabel.text = photosObject.photoName as? String
        let imageName = photosObject.photoPath as? String ?? ""
        
        self.downloadingOperationsQueue.startDownloading(imageName,completion: {(image) -> Void in
            if let image = image {
                self.backgroundImageView.image = image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
            }
        })
    }
}
