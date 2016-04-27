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
    dynamic var photoFolderID: NSString?
    dynamic var photoFolderName: NSString?
    dynamic var photoCategory: NSString?
    dynamic var folderCreationDate: NSString?
    dynamic var folderBackGroundColor: NSData?
    let photos = List<PhotosModel>()
    
    /**
     This func is for create Primary key for Perticular Model class Object
     
     - returns: return Primary Key in string format
     */
    
    override static func primaryKey() -> String? {
        return "photoFolderID"
    }
}
