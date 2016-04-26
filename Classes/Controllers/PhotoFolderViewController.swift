//
//  PhotoFolderViewController.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 22/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//


/**
 This class uesd for add Photo folder and Photos.
 */

import UIKit
import RealmSwift

enum AddPhotoType {
    case AddFolderWithPhoto
    case AddPhotoInFolder
}

class PhotoFolderViewController: UIViewController {
    
    @IBOutlet weak var folderNameTextField: UITextField!
    @IBOutlet weak var folderCategoryTextField: UITextField!
    @IBOutlet weak var folderCreationDate: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var photoFolderObject: PhotoFolder?
    var photosObject: PhotosModel?
    var addPhotoType = AddPhotoType.AddFolderWithPhoto
    
    class MyImageStorage {
        var imagePath: NSString?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        configureBarItemButton()
        configureTimeAndDate()
        configureSelectedImageView()
        activityIndicatorView.hidden = true
        folderCreationDate.userInteractionEnabled = false
        navigationItem.title = "Create Folder"
        if addPhotoType == .AddPhotoInFolder {
            navigationItem.title = "Add Photo"
            folderNameTextField.placeholder = "Enter Photo Name"
            folderCategoryTextField.text = photoFolderObject?.photoFolderName as? String
            folderCategoryTextField.userInteractionEnabled = false
        }
    }
   
    override func viewDidDisappear(animated: Bool) {
        activityIndicator.stopAnimating()
    }
    
        /**
     This func is used for accessing all the default photots from library
     */
    @IBAction func selectLibraryButton(sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /**
     This func is used for taking photo by camera.
     */
    @IBAction func cameraButton(sender: UIButton) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.modalPresentationStyle = .FullScreen
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            let alertVC = UIAlertController( title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
            let okAction = UIAlertAction( title: "OK", style:.Default, handler: nil)
            alertVC.addAction(okAction)
            presentViewController( alertVC, animated: true, completion: nil)
        }
    }
}

private extension PhotoFolderViewController {
  
    @objc func configureBarItemButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self,action: #selector(PhotoFolderViewController.configureSaveButton))
    }
    
    func configureSelectedImageView() {
        selectedImageView.layer.borderWidth = 4
        selectedImageView.layer.cornerRadius = 5.0
        selectedImageView.clipsToBounds = true
        selectedImageView.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    /**
     This func is used for get current date at folder creation time.
     */
    func configureTimeAndDate() {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let date = dateFormatter.stringFromDate(currentDate)
        folderCreationDate.text = ("\(date)")
    }
    
    /**
     This Func is used by two condition, first one when i come here from HOme screen for adding folder or come from Thumbnail View Controller to add new photo. so this func is used by two diff condition and all the text format data stored in Realm and photo in local file.
     */
    @objc func configureSaveButton() {
        activityIndicatorView.hidden = false
        activityIndicator.startAnimating()
        photosObject = PhotosModel()
        if addPhotoType == .AddFolderWithPhoto {
            photoFolderObject = PhotoFolder()
            photoFolderObject?.photoFolderID = NSUUID().UUIDString ?? ""
            photoFolderObject?.photoFolderName = folderNameTextField.text ?? ""
            photoFolderObject?.photoCategory = folderCategoryTextField.text ?? ""
            photoFolderObject?.folderCreationDate = folderCreationDate.text ?? ""
            let backgroundColorInData = NSKeyedArchiver.archivedDataWithRootObject(UIColor.randomColor())
            photoFolderObject?.folderBackGroundColor = backgroundColorInData
            photosObject?.photoID = NSUUID().UUIDString
            photosObject?.photoName = folderNameTextField.text ?? ""
            if let selectedImage = selectedImage {
                let imageData = UIImagePNGRepresentation(selectedImage)
                let imageName = photosObject?.photoID
                if let imageName = imageName {
                    let filename = getDocumentsDirectory().stringByAppendingPathComponent("\(imageName).png")
                    photosObject?.photoPath = "\(imageName).png"
                    dispatch_async(dispatch_get_main_queue()) {
                        if let imageData = imageData {
                            imageData.writeToFile(filename, atomically: true)
                        }
                    }
                }
            }
            try! uiRealm.write({ () -> Void in
                if let photosObject = photosObject {
                    photoFolderObject?.photos.append(photosObject)
                    if let photoFolderObject = photoFolderObject {
                        uiRealm.add(photoFolderObject)
                    }
                }
            })
        }
            
        else if addPhotoType == .AddPhotoInFolder {
            photosObject?.photoID = NSUUID().UUIDString
            photosObject?.photoName = folderNameTextField.text ?? ""
            if let selectedImage = selectedImage {
                let imageData = UIImagePNGRepresentation(selectedImage)
                let imageName = photosObject?.photoID
                if let imageName = imageName {
                    let filename = getDocumentsDirectory().stringByAppendingPathComponent("\(imageName).png")
                    photosObject?.photoPath = "\(imageName).png"
                    dispatch_async(dispatch_get_main_queue()) {
                        if let imageData = imageData {
                            imageData.writeToFile(filename, atomically: true)
                        }
                    }
                }
            }
            try! uiRealm.write({ () -> Void in
                if let photosObject = photosObject {
                    photoFolderObject?.photos.append(photosObject)
                    uiRealm.add(photosObject)
                }
            })
        }
        navigationController?.popViewControllerAnimated(true)
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

// MARK: - Image PickerController Delegate
extension PhotoFolderViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    /**
     This func is used for accesing the image from system library and set on selectedImageView.
     */
    func imagePickerController( picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        selectedImageView.contentMode = .ScaleAspectFit
        selectedImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     This func is used when imagePicker is canceled
     */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

/*!
 * @discussion extension used for adding extra definition or extra func in controller. here we add extra definition of CGFloat and UIColor
 */
// CGFolat give random value of r,g,b
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// here we set rendom color of each cell background
extension UIColor {
    static func randomColor() -> UIColor {
        let r = CGFloat.random()
        let g = CGFloat.random()
        let b = CGFloat.random()
        return UIColor(red: r, green: g, blue: b, alpha: 0.2)
}
}
