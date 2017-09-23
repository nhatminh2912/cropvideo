//
//  VideoThumbnail.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/15/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import UIKit
import Photos

class Video: NSObject {
    var phAsset : PHAsset?
    var thumb : UIImage?
    
    init(phAsset: PHAsset?, thumb: UIImage?) {
        self.phAsset = phAsset
        self.thumb = thumb
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(phAsset, forKey: "phAsset")
        aCoder.encode(thumb, forKey: "thumb")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.phAsset = aDecoder.decodeObject(forKey: "phAsset") as? PHAsset
        self.thumb = aDecoder.decodeObject(forKey: "thumb") as? UIImage
    }
    
    
}
