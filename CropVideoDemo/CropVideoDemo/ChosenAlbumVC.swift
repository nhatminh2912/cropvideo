//
//  ChosenAlbumVC.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/15/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ChosenAlbumVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var tableView: UITableView!
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var url: URL?
    var playerView: UIView!
    var fetchResult: PHFetchResult<PHAsset>!
    var videos = [Video]()
    var albumName = String()
    var btnPlayPause: UIButton?
    var isPlaying = false
    var isHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataToGetVideoThumbnails()
        createPlayerView()
        createTableView()
        
        navigationItem.title = albumName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Crop", style: .plain, target: self, action: #selector(cropBtnTapped))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // - Create subviews
    func createPlayerView() {
        let navHeight = (self.navigationController?.navigationBar.frame.size.height)!
        let screenHeight = self.view.bounds.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        playerView = UIView()
        playerView.frame = CGRect(x: 0, y: navHeight + statusBarHeight, width: self.view.bounds.size.width, height: (screenHeight - (navHeight + statusBarHeight))/2)
        
        self.view.addSubview(playerView)
        
    }
    
    func createTableView() {
        let navHeight = (self.navigationController?.navigationBar.frame.size.height)!
        let screenHeight = self.view.bounds.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: self.playerView.frame.maxY, width: self.view.bounds.size.width, height: (screenHeight - (navHeight + statusBarHeight))/2)
        tableView.register(ChosenAlbumVCCustomCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(tableView)
    }
    
    func createPlayPauseBtn() {
        let playerViewWidth = self.playerView.frame.size.width
        let playerViewHeight = self.playerView.frame.size.height
        let btnHeight = playerViewHeight/3
        
        btnPlayPause = UIButton()
        
        btnPlayPause?.frame = CGRect(x: playerViewWidth/2 - btnHeight/2, y: playerViewHeight/2 - btnHeight/2, width: btnHeight, height: btnHeight)
        btnPlayPause?.clipsToBounds = true
        btnPlayPause?.setImage(UIImage(named: "playBtn.png"), for: .normal)
        btnPlayPause?.layer.cornerRadius = btnHeight/2
        btnPlayPause?.addTarget(self, action: #selector(btnPlayPauseTapped), for: .touchUpInside)
        
        self.playerView.addSubview(btnPlayPause!)
    }
    
    // - Selectors
    
    func cropBtnTapped() {
        
        if self.url != nil {
            let cropVC = CropVC()
            
            cropVC.url = self.url
            
            self.navigationController?.pushViewController(cropVC, animated: true)
            
            print("crop")
            
        }
    }
    
    func btnPlayPauseTapped() {
        if isPlaying {
            player?.pause()
            btnPlayPause?.setImage(UIImage(named: "playBtn.png"), for: .normal)
        }
        else {
            player?.play()
            btnPlayPause?.setImage(UIImage(named: "pauseBtn.png"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    // - Check if player/playerLayer is nil
    func setNilVideo() throws -> (AVPlayer?, AVPlayerLayer?, UIButton?) {
        if player != nil {
            player?.pause()
            player = nil
        }
        if playerLayer != nil {
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
        }
        if btnPlayPause != nil {
            btnPlayPause?.removeFromSuperview()
            btnPlayPause = nil
        }
        return (player, playerLayer, btnPlayPause)
    }
    
    // - Get videos then put it into videos array
    func fetchDataToGetVideoThumbnails() {
        if fetchResult != nil {
            if fetchResult.count > 0 {
                for index in 0..<fetchResult.count {
                    let phAsset = fetchResult[index]
                    if phAsset.mediaType == .video {
                        let video = Video.init(phAsset: phAsset, thumb: nil)
                        videos.append(video)
                    }
                }
            }
        }
    }
    
    // - Create cell
    
    func cell(index: Int) -> UITableViewCell {
        let cellHeight = self.tableView.frame.size.height/5
        let screenWidth = self.view.bounds.size.width
        
        let cell = ChosenAlbumVCCustomCell()
        
        //setup
        
        cell.thumbImageView = UIImageView()
        cell.thumbImageView.frame = CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight)
        
        cell.videoNameLabel = UILabel()
        cell.videoNameLabel.frame = CGRect(x: cellHeight + 10, y: 0, width: screenWidth - (cellHeight + 10), height: cellHeight/2)
        cell.videoNameLabel.adjustsFontSizeToFitWidth = true
        
        //get video thumbnail to add to cell's imageview
        let video : Video = videos[index]
        
        if video.thumb != nil {
            cell.thumbImageView.image = video.thumb
        }
        else{
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            PHImageManager.default().requestImage(for: video.phAsset!,
                                                  targetSize: CGSize.init(width: cellHeight,
                                                                          height: cellHeight),
                                                  contentMode: .default,
                                                  options: options) { (image, nil) in
                                                    
                                                    video.thumb = image
                                                    cell.thumbImageView.image = video.thumb
            }
        }
        
        cell.videoNameLabel.text = video.phAsset!.value(forKey: "filename") as! String?
        
        cell.addSubview(cell.thumbImageView)
        cell.addSubview(cell.videoNameLabel)
        
        return cell
    }
    
    // - Setup player
    
    func setUpPlayer(index: Int) {
        let asset = videos[index].phAsset
        
        do {
            let _ = try setNilVideo()
        } catch {
            
        }
        
        
        PHCachingImageManager().requestAVAsset(forVideo: asset!, options: nil, resultHandler: {(asset, audioMix, info) in
            let asset = asset as? AVURLAsset
            
            self.url = asset?.url
            
            DispatchQueue.main.async {
                self.player = AVPlayer(url: self.url!)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.playerView.frame.size.height)
                self.playerView.layer.addSublayer(self.playerLayer!)
                self.createPlayPauseBtn()
            }
        })
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isPlaying = false
        setUpPlayer(index: indexPath.row)
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(index: indexPath.row)
    }
    
}
