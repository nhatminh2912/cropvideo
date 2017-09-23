//
//  ChosenAlbumVCCustomCell.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/15/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import UIKit

class ChosenAlbumVCCustomCell: UITableViewCell {

    var thumbImageView = UIImageView()
    var videoNameLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.layer.borderWidth = 0.0
        self.layer.borderColor = nil
        if selected {
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
