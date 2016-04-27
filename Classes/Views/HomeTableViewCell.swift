//
//  PhotoFolderTableViewCell.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This is tableViewCell Class. this is handle Home screen ()

import UIKit
import RealmSwift

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var folderCreationDate: UILabel!
    
    /*!
     * @discussion This method is for configure cell with content
     * @param PhotoFolder Object, this contain all the information related to folder
     */
    
    func configureFolderCell(forPhotoFolderObject photoFolderObject: PhotoFolder)  {
        configurePhotoCountLabel()
        folderName.text = photoFolderObject.photoFolderName as? String
        category.text = photoFolderObject.photoCategory as? String
        photoCount.text = "\(photoFolderObject.photos.count)"
        folderCreationDate.text = photoFolderObject.folderCreationDate as? String
        if let colorData = photoFolderObject.folderBackGroundColor {
            let cellBackgroundColor = NSKeyedUnarchiver.unarchiveObjectWithData(colorData)
            backgroundColor = cellBackgroundColor as? UIColor
        }
    }
}

private extension HomeTableViewCell {
    /**
     This func is for draw a circle around Photo Count Label
     */
  private func configurePhotoCountLabel()  {
        let size:CGFloat = 30.0
        photoCount.textColor = .blackColor()
        photoCount.textAlignment = .Center
        photoCount.font = UIFont.systemFontOfSize(12.0)
        photoCount.bounds = CGRectMake(0.0, 0.0, size, size)
        photoCount.layer.cornerRadius = size / 2
        photoCount.layer.borderWidth = 2.0
        photoCount.clipsToBounds = true
        photoCount.layer.backgroundColor = UIColor.clearColor().CGColor
        photoCount.layer.borderColor = UIColor.blackColor().CGColor
    }
}