//
//  PhotoListViewController.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is for display all the Photos in List view.

import UIKit
import RealmSwift

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var tableViewInstance: UITableView!
    
    var photoFolderObject: PhotoFolder?
    var photosArray: List<PhotosModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableViewInstance.reloadData()
        configureBarItemButton()
    }
}

private extension PhotoListViewController {
    private func configureBarItemButton() {
        let rightAddButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add , target: self, action: #selector(PhotoListViewController.addPhoto))
        let rightThumbnailButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "thumbnail"), style: .Plain, target: self, action: #selector(PhotoListViewController.thumbnailView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(PhotoListViewController.goToMainViewController))
        navigationItem.setRightBarButtonItems([rightThumbnailButtonItem, rightAddButtonItem], animated: true)
    }
    
    @objc func thumbnailView()  {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @objc func goToMainViewController() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @objc func addPhoto() {
        let photoFolderViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoFolderViewController") as? PhotoFolderViewController
        if let photoFolderViewController = photoFolderViewController {
            photoFolderViewController.photoFolderObject = photoFolderObject
            photoFolderViewController.addPhotoType = .AddPhotoInFolder
            navigationController?.pushViewController(photoFolderViewController, animated: true)
        }
    }
}

// MARK: - TableView DataSource
extension PhotoListViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosArray?.count ?? 0
    }
    
    /**
     This func is used for configuring ListTableViewCell
     - returns: new ListTableView Cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("listViewCell", forIndexPath: indexPath) as? ListTableViewCell {
            if let photosArray = photosArray {
                cell.configureListCell(photosArray[indexPath.row], index: indexPath.row, favouriteButtonState: photosArray[indexPath.row].photofavorite)
                cell.delegate = self
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Table view delegates
extension PhotoListViewController: UITableViewDelegate {
    /**
     This func is used for when we select any cell then controll will goto PageViewController
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let photoPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoPageViewController") as? PhotoPageViewController
        if let photoPageViewController = photoPageViewController {
            photoPageViewController.photosArray = photosArray
            photoPageViewController.pageIndicatorIndex = indexPath.row
            navigationController?.pushViewController(photoPageViewController, animated: true)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /**
     This func is used for deleting Photo from List View
     */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let photosArray = photosArray {
                if photosArray.count > indexPath.row {
                    let deleteFolder = photosArray[indexPath.row]
                    try! uiRealm.write({ () -> Void in
                        uiRealm.delete(deleteFolder)
                        tableViewInstance.reloadData()
                    })
                }
            }
        }
    }
}

// MARK: - ListTableViewCell Delegates
extension PhotoListViewController: ListTableViewCellDelegate {
    
    func configurefavouriteButton(cell: ListTableViewCell, index: Int) -> Bool {
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
}




















