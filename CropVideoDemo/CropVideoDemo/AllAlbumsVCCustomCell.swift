//
//  AllAlbumsVCCustomCell.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/14/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import UIKit

class AllAlbumsVCCustomCell: UITableViewCell {

    var albumThumbnail = UIImageView()
    var nameLabel = UILabel()
    var phAssetId =  String()
    var thumbAlbum = UIImage() {
        didSet{
            albumThumbnail.image = thumbAlbum
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
