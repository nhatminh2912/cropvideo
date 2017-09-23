//
//  AllAlbumsVC.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/14/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import Foundation
import UIKit
import Photos

class AllAlbumsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var tableView : UITableView!
    var smartAlbums : PHFetchResult<PHAssetCollection>!
    var userAlbums : PHFetchResult<PHCollection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let phOptions = PHFetchOptions.init()
        phOptions.sortDescriptors = [NSSortDescriptor.init(key: "localizedTitle", ascending: true)]
        self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: phOptions)
        self.userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: phOptions)
        
        let screenHeight = self.view.bounds.size.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: statusBarHeight, width: self.view.bounds.size.width, height: screenHeight  - tabBarHeight!)
        tableView.register(AllAlbumsVCCustomCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.tableView.reloadData()
    }
    
    func cell(index: Int) -> UITableViewCell {
        let cellHeight = self.tableView.frame.size.height/7
        
        let cell = AllAlbumsVCCustomCell()
        
        cell.albumThumbnail.frame = CGRect(x: 0,
                                           y: 0,
                                           width: cellHeight,
                                           height: cellHeight)
        
        cell.nameLabel.frame = CGRect(x: cellHeight + 10,
                                      y: 0,
                                      width: cell.frame.size.width - cellHeight,
                                      height: cellHeight/2)
        
        let fetchOptions = PHFetchOptions()
        let descriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchOptions.sortDescriptors = [descriptor]
        
        let collection = smartAlbums[index]
        cell.phAssetId = collection.localIdentifier
        
        let fetchResult = PHAsset.fetchKeyAssets(in: collection, options: fetchOptions)
        if fetchResult != nil {
            if (fetchResult?.count)! > 0 {
                let phAsset = fetchResult?[0]
                let targetSize = CGSize(width: cellHeight,
                                        height: cellHeight)
                
                let option = PHImageRequestOptions()
                option.resizeMode = .exact
                
                // get album thumbnail
                PHImageManager.default().requestImage(for: phAsset!, targetSize: targetSize, contentMode: .aspectFill, options:nil) { (image, info) in
                    if cell.phAssetId == collection.localIdentifier && image != nil{
                        cell.thumbAlbum = image!
                    }
                }
            }
            else{
                cell.thumbAlbum = UIImage.init()
            }
            
        }else{
            cell.thumbAlbum = UIImage.init()
        }
        
        cell.nameLabel.text = smartAlbums[index].localizedTitle
        
        cell.addSubview(cell.albumThumbnail)
        cell.addSubview(cell.nameLabel)
        
        return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height/7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController = ChosenAlbumVC()
        
        let fetchOptions = PHFetchOptions()
        let descriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchOptions.sortDescriptors = [descriptor]
        let collection = smartAlbums[indexPath.row]
        let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)
        
        newViewController.fetchResult = assets
        
        let albumName = smartAlbums[indexPath.row].localizedTitle
        
        newViewController.albumName = albumName!
        
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smartAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(index: indexPath.row)
    }
    
}
