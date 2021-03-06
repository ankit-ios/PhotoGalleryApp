//
//  PhotoThumbnailViewController.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//


/// This class is for display all the Photos in Thumbnail view.

import UIKit
import RealmSwift

class PhotoThumbnailViewController: UIViewController {
    
    @IBOutlet weak var collectionViewInstance: UICollectionView!
    
    var photoFolderObject: PhotoFolder?
    var photosArray: List<PhotosModel>?
    let imagePicker = UIImagePickerController()
    let cellIdentifier = "thumbnailCell"
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        photosArray = photoFolderObject?.photos
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionViewInstance.reloadData()
        configureBarItemButton()
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
}

private extension PhotoThumbnailViewController {
    private func configureBarItemButton()  {
        let rightListViewButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "list"), style: .Plain, target: self, action: #selector(listView))
        let rightAddButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add , target: self, action: #selector(addPhoto))
        navigationItem.setRightBarButtonItems([rightListViewButtonItem, rightAddButtonItem], animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(goToMainViewController))
    }
    
    /**
     This is action method for goto Photos in List View
     */
    @objc func listView() {
        let photoListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoListViewController") as? PhotoListViewController
        if let photoListViewController = photoListViewController {
            photoListViewController.photoFolderObject = photoFolderObject
            navigationController?.showViewController(photoListViewController, sender: self)
        }
    }
    
    /**
     This func is used for goto PhotoFolderViewController for adding new photo in selected folder
     */
    @objc func addPhoto() {
        let photoFolderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoFolderViewController") as? PhotoFolderViewController
        if let photoFolderViewController = photoFolderViewController {
            photoFolderViewController.photoFolderObject = photoFolderObject
            photoFolderViewController.addPhotoType = .AddPhotoInFolder
            navigationController?.pushViewController(photoFolderViewController, animated: true)
        }
    }
    
    /**
     This func is used for goto HomeScreen.
     */
    @objc func goToMainViewController() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}

// MARK: - CollectionView DataSource
extension PhotoThumbnailViewController: UICollectionViewDataSource {
    //TODO: - getting number of cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray?.count ?? 0
    }
    
    /**
     This func is used for configuring cell in Thumbnail View
     - returns: ThumbnailCollectionViewCell
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as? ThumbnailCollectionViewCell {
            if let photosArray = photosArray {
                let photoName = photosArray[indexPath.row].photoPath as? String
                let state = photosArray[indexPath.row].photofavorite
                cell.configureThumbnailCell(photoName ?? "", index: indexPath.row, favouriteButtonState: state)
                cell.delegate = self
                cell.layer.borderColor = UIColor.grayColor().CGColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 8
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - CollectionView Delegate
extension PhotoThumbnailViewController: UICollectionViewDelegate {
    
    //TODO: - when Select any cell, this method will called
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photoPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoPageViewController") as? PhotoPageViewController
        if let photoPageViewController = photoPageViewController {
            photoPageViewController.photosArray = photosArray
            photoPageViewController.pageIndicatorIndex = indexPath.row
            navigationController?.pushViewController(photoPageViewController, animated: true)
        }
        collectionViewInstance.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    //TODO: - when we longpress any cell, then delete menu item button will popup
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let delete = UIMenuItem(title: "delete", action:#selector(ThumbnailCollectionViewCell.deletePhoto))
        UIMenuController.sharedMenuController().menuItems = [delete]
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return action == #selector(ThumbnailCollectionViewCell.deletePhoto)
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?)
    {
        if action == #selector(ThumbnailCollectionViewCell.deletePhoto) {
            print ("Delete Photo from Thumbnail View ")
        }
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension PhotoThumbnailViewController: UICollectionViewDelegateFlowLayout {
    
    /**
     This func is used for resizing cell size
     - returns: new Cell Size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 3 - 10.0, height: collectionView.bounds.size.width / 3 - 10.0)
    }
    
    /**
     This func is used for maintainng spaces from other view
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6.0 , left: 4.0, bottom: 0, right: 4.0)
    }
}

// MARK: - Image PickerController Delegate
extension PhotoThumbnailViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    //TODO: - ImagePicker delegates, when click cancel button
    func imagePickerController( picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - Conferm Protocol of ThumbnailCollectionViewCellDelegate
extension PhotoThumbnailViewController: ThumbnailCollectionViewCellDelegate {
    
    //TODO: - this protocol method called from cell class for configure faverate button
    func configurefavouriteButton(cell: ThumbnailCollectionViewCell, index: Int) -> Bool {
        if let photosArray = photosArray{
            let state: Bool = photosArray[index].photofavorite
            if state {
                try! uiRealm.write({ () -> Void in
                    photosArray[index].photofavorite = false
                    uiRealm.add(photosArray, update: true)
                })
                return false
            }
            else {
                try! uiRealm.write({ () -> Void in
                    photosArray[index].photofavorite = true
                    uiRealm.add(photosArray, update: true)
                })
                return true
            }
        }
        return false
    }
    
    //TODO: - This protocol method called from cell class for deleting cell
    func deletePhoto(cell: ThumbnailCollectionViewCell, index: Int)  {
        try! uiRealm.write({ () -> Void in
            if let photosArray = photosArray {
                // here, we delete the photo, which is saved locally in simulator in document folder
                let filename = GetDirectoryPath.getDocumentsDirectory().stringByAppendingPathComponent("\(photosArray[index].photoPath ?? "")")
                if NSFileManager.defaultManager().fileExistsAtPath(filename ) {
                    try! NSFileManager.defaultManager().removeItemAtPath(filename)
                }
                //here, we delete photo from Realm
                uiRealm.delete(photosArray[index])
            }
        })
        collectionViewInstance.reloadData()
    }
}



