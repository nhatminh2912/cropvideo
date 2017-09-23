//
//  CropVC.swift
//  CropVideoDemo
//
//  Created by inest-01 on 9/18/17.
//  Copyright © 2017 inest-01. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CropVC: UIViewController {
    
    var url: URL?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playerView: UIView?
    var btnPlayPause: UIButton?
    var isPlaying = false
    var sldDuration: UISlider?
    var controlView: UIView?
    
    var timer = Timer()
    var duration = Float()
    var currentTime = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Crop"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportBtnTapped))
        createPlayerView()
        createPlayPauseBtn()
        createDurationSld()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exportBtnTapped() {
        print("export")
    }
    
    // - Create views
    func createPlayerView() {
        let navHeight = (self.navigationController?.navigationBar.frame.size.height)!
        let screenHeight = self.view.bounds.size.height
        let screenWidth = self.view.bounds.size.width
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        playerView = UIView()
        playerView?.frame = CGRect(x: 0, y: navHeight + statusBarHeight, width: screenWidth, height: screenHeight/2 - (navHeight + statusBarHeight))
        
        player = AVPlayer(url: self.url!)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = CGRect(x: 0, y: 0, width: (self.playerView?.bounds.size.width)!, height: (self.playerView?.bounds.size.height)!)
        
        self.view.addSubview(playerView!)
        self.playerView?.layer.addSublayer(playerLayer!)
    }
    
    func createControlView() {
        controlView = UIView()
        controlView?.frame = CGRect(x: 0, y: (self.playerView?.frame.maxY)!, width: self.view.bounds.size.width, height: self.view.bounds.size.width/8)
        
        self.view.addSubview(controlView!)
    }
    
    func createPlayPauseBtn() {
        let screenWidth = self.view.bounds.size.width
        let btnWidth = screenWidth/16
        btnPlayPause = UIButton()
        btnPlayPause?.frame = CGRect(x: 0, y: self.playerView!.frame.maxY + btnWidth/2, width: btnWidth, height: btnWidth)
        btnPlayPause?.clipsToBounds = true
        btnPlayPause?.setImage(UIImage(named: "playBtn.png"), for: .normal)
        btnPlayPause?.layer.cornerRadius = (btnPlayPause?.frame.size.width)!/2
        btnPlayPause?.addTarget(self, action: #selector(playpause), for: .touchUpInside)
        btnPlayPause?.backgroundColor = UIColor.white
        
        self.view.addSubview(btnPlayPause!)
    }
    
    func createDurationSld() {
        sldDuration = UISlider()
        sldDuration?.frame = CGRect(x: (btnPlayPause?.frame.maxX)!, y: (self.playerView?.frame.maxY)!, width: self.view.bounds.size.width - 2*(btnPlayPause?.frame.maxX)!, height: self.view.bounds.size.width/8)
        sldDuration?.minimumValue = 0
        sldDuration?.maximumValue = 1
        sldDuration?.isContinuous = true
        sldDuration?.addTarget(self, action: #selector(sldDurationValueChanged), for: .valueChanged)
        
        self.view.addSubview(sldDuration!)
    }
    
    // - Selectors
    func playpause() {
        if isPlaying {
            player?.pause()
            timer.invalidate()
            btnPlayPause?.setImage(UIImage(named: "playBtn.png"), for: .normal)
        }
        else {
            player?.play()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            btnPlayPause?.setImage(UIImage(named: "pauseBtn.png"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    func sldDurationValueChanged(_ sender: UISlider) {
        timer.invalidate()
        
        let timeToSeek = sender.value * duration
        let time = CMTimeMake(Int64(timeToSeek), 1)
        
        let tolerance = CMTimeMake(0, 1)
        
        player?.seek(to: time, toleranceBefore: tolerance, toleranceAfter: tolerance)
    }
    
    func updateTime()
    {
        self.duration = Float((player?.currentItem?.duration.value)!)/Float((player?.currentItem?.duration.timescale)!)
        self.currentTime = Float((player?.currentTime().value)!)/Float((player?.currentTime().timescale)!)
//        let m = Int(floor(self.currentTime/60))
//        let s = Int(round(self.currentTime - Float(m)*60))
        
        if (self.duration > 0)
        {
            
//            let mduration = Int(floor(self.duration/60))
//            let sduration = Int(round(self.duration - Float(mduration)*60))
//            self.currentTime.text = String(format: "%02d", m) + ":" + String(format: "%02d", s)
//            self.lblTotalTime.text = String(format: "%02d", mduration) + ":" + String(format: "%02d", sduration)
            
            self.sldDuration?.setValue(Float(self.currentTime/self.duration), animated: true)
            
        }
        
        if (self.currentTime == self.duration){
            
            btnPlayPause?.setImage(UIImage(named: "playBtn.png"), for: .normal)
            isPlaying = false
            player?.seek(to: kCMTimeZero)
        }
    }
    
}
