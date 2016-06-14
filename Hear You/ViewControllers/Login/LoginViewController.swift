//
//  LoginViewController.swift
//  BaseKit
//
//  Created by 董亚珣 on 16/4/1.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    lazy var musicPlayer : AudioPlayer = {
        return AudioPlayer.sharedPlayer
    }()
    
//    var songListFromNet : [SearchSong] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchSongWithName("我", page: "1", size: "5", failureHandler: nil) { (songList) in
//            
//            self.songListFromNet = songList
//        }
    }
    
    @IBAction func play(sender: UIButton) {
        
//        musicPlayer.readyToPlayWithSongFromNet(self.songListFromNet)
//        if let realm = try? Realm() {
//            guard let song = songWithSongID(songListFromNet.last!.songID, inRealm: realm) else {
//                return
//            }
//            println(song.localPath)
//            musicPlayer.readyToPlayLocalSong([song])
//        }
        
        
        
//        musicPlayer.play()
    }
    
    @IBAction func pause(sender: UIButton) {
        
        print("duration:\(musicPlayer.duration)\nprogress:\(musicPlayer.progress)")
//        if let realm = try? Realm() {
//            let song = songWithSongID(songListFromNet.last!.songID, inRealm: realm)
//            println(song?.localPath)
//        }
        
        
    }
    
    @IBAction func download(sender: UIButton) {
        
//        downSongWithSongFromNet(songListFromNet.last!, showProgress: nil)
        
    }
    
    

}
