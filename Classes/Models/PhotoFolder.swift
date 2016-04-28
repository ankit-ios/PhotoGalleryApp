//
//  PhotoFolder.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is Realm Model class and we use this for create folder.

import Foundation
import RealmSwift

class PhotoFolder: Object {
    dynamic var photoFolderName: NSString?
    dynamic var photoCategory: NSString?
    dynamic var folderCreationDate: NSString?
    dynamic var folderBackGroundColor: NSData?
    let photos = List<PhotosModel>()
}
