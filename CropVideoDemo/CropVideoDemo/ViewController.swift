//
//  ViewController.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/8/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
        self.navigationItem.title = "All Albums"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Create Tabs
        
        let tabAllAlbums = AllAlbumsVC()
        
        let tabMyVideo = MyVideoVC()
        
        let image = UIImage(named: "image.png")
        let selectedImage = UIImage(named: "selectedImage.png")
        
        let tabOneBarItem = UITabBarItem(title: "Crop Video", image: image, selectedImage: selectedImage)
        tabOneBarItem.titlePositionAdjustment = UIOffsetMake(0, 0)
        tabAllAlbums.tabBarItem = tabOneBarItem
        
        let tabTwoBarItem = UITabBarItem(title: "My Video", image: image, selectedImage: selectedImage)
        tabTwoBarItem.titlePositionAdjustment = UIOffsetMake(0, 0)
        tabMyVideo.tabBarItem = tabTwoBarItem
        
        self.viewControllers = [tabAllAlbums, tabMyVideo]
        
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.navigationItem.title = viewController.tabBarItem.title
    }
}
