//
//  HYTabBarController.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/1.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class HYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        // Do any additional setup after loading the view.
    }
    
    func showPlayerViewControllerWithSong(song: Song, inCategory category: SongCategory) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tmpVc = storyboard.instantiateViewControllerWithIdentifier("PlayerViewController") as! PlayerViewController
        tmpVc.song = song
        tmpVc.category = category
        tmpVc.songlist = category.currentSonglist
        
        let vc = UINavigationController(rootViewController: tmpVc)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
        if let sideMenuViewController = sideMenuViewController {
            sideMenuViewController.hideMenuViewController()
        }
    }
    
    private func showPlayerViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tmpVc = storyboard.instantiateViewControllerWithIdentifier("PlayerViewController") as! PlayerViewController
        
        if let song = AudioPlayer.sharedPlayer.currentSong,
            let category = AudioPlayer.sharedPlayer.currentCategory,
            let songlist = AudioPlayer.sharedPlayer.currentCategory?.currentSonglist {
            
            tmpVc.song = song
            tmpVc.category = category
            tmpVc.songlist = songlist
        } else if let song = gStorage.lastSong,
            let category = gStorage.lastSongCategory {
            
            tmpVc.song = song
            tmpVc.category = category
            tmpVc.songlist = category.currentSonglist
        } else {
            Alert.showMiddleHint("请先选择一首歌曲来播放")
            return
        }
        let vc = UINavigationController(rootViewController: tmpVc)
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
        if let sideMenuViewController = sideMenuViewController {
            sideMenuViewController.hideMenuViewController()
        }
    }
}

extension HYTabBarController: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if viewController.isKindOfClass(PlayerViewController) {
            self.showPlayerViewController()
            return false
        }
        return true
    }
    
}
