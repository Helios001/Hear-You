//
//  MyMusicViewController.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/7.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import RealmSwift

class MyMusicViewController: UITableViewController {
    
    let titles = ["下载音乐","最近播放","iPod"]
    let images = ["cm2_list_icn_dld_new","cm2_list_icn_recent_new","cm2_list_icn_ipod_new"]
    
    var downloadCategory : SongCategory?
    var latestCategory : SongCategory?
    var favouriteCategory : SongCategory?
    
    var categoryType : DefaultCategory?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的音乐"
        
        
        
        navigationController?.tabBarItem.selectedImage = UIImage(named: "cm2_btm_icn_music_prs")!.imageWithRenderingMode(.AlwaysOriginal)
        
        
        // 从本地数据库中获取我的音乐信息
        dispatch_async(realmQueue) { 
            if let realm = try? Realm() {
                self.downloadCategory = getLocalCategoryWithCategoryName(DefaultCategory.DOWNLOADED.description, inRealm: realm)
                self.latestCategory = getLocalCategoryWithCategoryName(DefaultCategory.LATEST.description, inRealm: realm)
                self.favouriteCategory = getLocalCategoryWithCategoryName(DefaultCategory.FAVOURITE.description, inRealm: realm)
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.subviews[0].alpha = 1
        navigationController?.navigationBar.translucent = false
    }
    
    // MARK: - EventMethods
    
    @IBAction func configureSongList(sender: UIBarButtonItem) {
        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MyLocalMusic", forIndexPath: indexPath)
            
            cell.textLabel?.text = titles[indexPath.row]
            cell.imageView?.image = UIImage(named: images[indexPath.row])
            switch indexPath.row {
            case 0:
                cell.detailTextLabel?.text = downloadCategory != nil ? "\(downloadCategory!.songs.count)" : "0"
            case 1:
                cell.detailTextLabel?.text = latestCategory != nil ? "\(latestCategory!.songs.count)" : "0"
            default:
                cell.detailTextLabel?.text = downloadCategory != nil ? "\(downloadCategory!.songs.count)" : "0"
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("MyListItem", forIndexPath: indexPath) as! MyMusicListCell
            cell.selectionStyle = .None
            cell.albumName.text = "我喜欢的音乐"
            cell.albumDesc.text = "I like music"
            cell.albumImage.image = UIImage(named: "cm2_pop_icn_love")
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                categoryType = .DOWNLOADED
            case 1:
                categoryType = .LATEST
            default:
                categoryType = .DOWNLOADED
            }
        default:
            switch indexPath.row {
            case 0:
                categoryType = .FAVOURITE
            default:
                return
            }
        }
        
        performSegueWithIdentifier("showListViewController", sender: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 44
        default:
            return 110
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return 30
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.width, 30))
            let label = UILabel.init(frame: CGRectMake(15, 0, tableView.frame.width - 30, 30))
            label.textColor = UIColor.grayColor()
            label.text = "我的歌单"
            label.font = UIFont.systemFontOfSize(11)
            headerView.addSubview(label)
            
            return headerView
        }
        return nil
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showListViewController" {
            if let vc = segue.destinationViewController as? ListViewController, categoryType = categoryType {
                vc.categoryType = categoryType
            }
        }
    }
}
