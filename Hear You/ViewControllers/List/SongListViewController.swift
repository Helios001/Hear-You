//
//  ListTableViewController.swift
//  Hear You
//
//  Created by 董亚珣 on 16/5/3.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import RealmSwift

class SongListViewController: UITableViewController {
    
    private var category = SongCategory()
    
    var categoryType : DefaultCategory?
    
    var popWindow : Pop?
    
    let tableHeaderHeight = screenBounds.width / 2
    
    lazy var tableHeaderView = UIImageView()

    @IBOutlet weak var headerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
        
        tableView.registerNib(UINib.init(nibName: "MusicCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "ListCell")
        
        tableHeaderView.frame = CGRectMake(0, 0, screenBounds.width, tableHeaderHeight)
        tableHeaderView.backgroundColor = UIColor.defaultRedColor()
        view.addSubview(tableHeaderView)
        
        dispatch_async(realmQueue) { 
            if let categoryType = self.categoryType {
                
                switch categoryType {
                case .DOWNLOADED:
                    self.category = DefaultCategory.DOWNLOADED.category
                case .LATEST:
                    self.category = DefaultCategory.LATEST.category
                case .FAVOURITE:
                    self.category = DefaultCategory.FAVOURITE.category
                case .SEARCH:
                    self.category = DefaultCategory.SEARCH.category
                default:
                    self.category = DefaultCategory.CURRENT.category
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.subviews[0].alpha = 0
        navigationController?.navigationBar.translucent = true
    }
    
    // MARK: - EventMethods
    
    // MARK: - 弹出操作视图
    @objc func showPopView(sender: UIButton) {
        
        let choices = ["下一首播放","收藏到歌单","删除","分享","歌手","专辑"]
        
        popWindow = Pop(choices: choices)
        
        popWindow?.tag = sender.tag
        
        popWindow?.delegate = self
        popWindow?.popFromBottomInViewController()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.songs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath) as! MusicCell
        
        let song = category.songs[indexPath.row]
        
        cell.songNameLabel.textColor = UIColor.defaultBlackColor()
        cell.singerNameLabel.textColor = UIColor.defaultBlackColor()
        cell.songNameLabel.text = song.songName
        cell.singerNameLabel.text = song.singerName
        
        // 记录歌曲的tag，以便后续的详情操作
        cell.detailButton.tag = indexPath.row
        
        cell.detailButton.addTarget(self, action: #selector(SongListViewController.showPopView(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        let song = category.songs[indexPath.row]
        
        category.currentSonglist = category.songs
        
        switch gStorage.cycleMode {
        
        case .RANDOM:
            category.currentSonglist = PlayerManager.getRandomListWithCategory(category)
        
        default:
            break
        }
        
        (self.tabBarController as! HYTabBarController).showPlayerViewControllerWithSong(song, inCategory: category)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let contentOffY = scrollView.contentOffset.y
        if contentOffY >= 0 {
            let alpha = contentOffY / tableView.tableHeaderView!.bounds.height
            navigationController?.navigationBar.subviews[0].alpha = alpha
        } else {
            tableView.tableHeaderView?.frame = CGRectMake(0, contentOffY, tableView.tableHeaderView!.bounds.width, tableHeaderHeight - contentOffY)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SongListViewController : PopViewDelegate {
    
    func popView(popView: Pop, didSelectItemAtIndex index: Int) {
        
        popView.dismiss()
        
        switch index {
        case 2:
            
            let song = category.songs[popView.tag]
            
            if let localInfo = song.localInfo {
                
                if let realm = try? Realm() {
                    
                    deleteSong(song, inRealm: realm)
                }
                
                NSFileManager.deleteSongFileWithName(String(song.songID), andExtension: localInfo.suffix)
                
                Alert.showMiddleHint("删除成功")
                
                category.songs.removeAtIndex(popView.tag)
                tableView.reloadData()
            }
            
        default:
            break
        }
    }
}
