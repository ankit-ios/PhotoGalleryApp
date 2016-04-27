//
//  PhotoPageViewController.swift
//  PhotoGalleryApp
//
//  Created by Ankit Sharma on 23/04/16.
//  Copyright © 2016 Robosoft Technology. All rights reserved.
//

/// This class is for display all the Photos in PageView(Scrolling).

import UIKit
import RealmSwift

class PhotoPageViewController: UIPageViewController {
    
    var photosArray: List<PhotosModel>?
    var pageIndicatorIndex: Int = 0
    var photosCount: Int = 0
    
    override func viewDidLoad() {
        photosCount = photosArray?.count ?? 0
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        view.backgroundColor = UIColor.lightGrayColor()
        self.dataSource = self
        setViewControllers([getViewControllerAtIndex(pageIndicatorIndex)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
}

private extension PhotoPageViewController {
    /**
     This is default func, this is used for get new controller for displaying Photos in Page View Type.
     */
    private func getViewControllerAtIndex(index: NSInteger) -> PhotoPageContentViewController {
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoPageContentViewController") as? PhotoPageContentViewController
        if let pageContentViewController = pageContentViewController {
            if let photosArray = photosArray {
                pageContentViewController.photoPath = photosArray[index].photoPath as? String
            }
            return pageContentViewController
        }
        return PhotoPageContentViewController()
    }
}

// MARK: - PageViewController DataSource
extension PhotoPageViewController: UIPageViewControllerDataSource {
    /**
     This func is called, when we swiped image left side.
     - returns: Before Page
     */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if (pageIndicatorIndex == NSNotFound) {
            return nil
        }
        if (photosArray?.count <= 1) {
            return nil
        }
        pageIndicatorIndex -= 1
        if (pageIndicatorIndex == -1) {
            pageIndicatorIndex = photosCount - 1
        }
        return getViewControllerAtIndex(pageIndicatorIndex)
    }
    
    /**
     This func is called, when we swiped image right side.
     - returns: After Page
     */
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if (pageIndicatorIndex == NSNotFound) {
            return nil
        }
        if (photosArray?.count <= 1 ) {
            return nil
        }
        pageIndicatorIndex += 1
        if (pageIndicatorIndex == photosCount) {
            pageIndicatorIndex = 0
        }
        return getViewControllerAtIndex(pageIndicatorIndex)
    }
    
    /**
     This func is for count all the pages in page view controller
     - returns: Pages Count
     */
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return photosArray?.count ?? 0
    }
    
    /**
     This func is for indicator position
     */
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pageIndicatorIndex ?? 0
    }
}
