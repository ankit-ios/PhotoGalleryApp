//
//  HomeViewController.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class used for display Home screen (Main Screen).

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    var photoFolderObject: Results<PhotoFolder>?
    var photosObject: PhotosModel?
    @IBOutlet weak var tableViewInstance: UITableView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoFolderObject = uiRealm.objects(PhotoFolder)
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicatorView.hidden = true
        tableViewInstance.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        activityIndicator.stopAnimating()
    }
    
    /*!
     * @discussion prepareForSegue used for sending data from one controller to another Controller
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let photoThumbnailViewControllerInstance = segue.destinationViewController as? PhotoThumbnailViewController
        {
            if let  indexPath = tableViewInstance.indexPathForSelectedRow
            {
                if let photoFolderObject = photoFolderObject {
                    photoThumbnailViewControllerInstance.photoFolderObject = photoFolderObject[indexPath.row]
                    photoThumbnailViewControllerInstance.photosArray = photoFolderObject[indexPath.row].photos
                }
            }
        }
    }
}

// MARK: - Table view data source
/*!
 * @discussion Extension used for adding extra func. here we define UITableViewDataSource func.
 */
extension HomeViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoFolderObject?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("PhotoFolderCell", forIndexPath: indexPath) as? HomeTableViewCell {
            if let photoFolderObject = photoFolderObject {
                cell.configureFolderCell(forPhotoFolderObject: photoFolderObject[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Table view delegates
/*!
 * @discussion Here we define UITableViewDelegate func
 */
extension HomeViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activityIndicatorView.hidden = false
        activityIndicator.startAnimating()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            if let photoFolderObject = photoFolderObject {
                if photoFolderObject.count > indexPath.row {
                    
                    let deleteFolder = photoFolderObject[indexPath.row]
                    try! uiRealm.write({ () -> Void in
                        uiRealm.delete(deleteFolder)
                        tableViewInstance.reloadData()
                    })
                }
            }
        }
    }
}



