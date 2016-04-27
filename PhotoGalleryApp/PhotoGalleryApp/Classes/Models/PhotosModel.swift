//
//  PhotosModel.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is Realm Model class and we use this for add photos in folder.

import Foundation
import RealmSwift

class PhotosModel: Object {
    dynamic var photoID: NSString?
    dynamic var photoName: NSString?
    dynamic var photoPath: NSString?
    dynamic var photofavorite: Bool = false
 
    /**
     This func is for create Primary key for Perticular Model class Object
     
     - returns: return Primary Key in string format
     */
    
    override static func primaryKey() -> String? {
        return "photoID"
    }
}
