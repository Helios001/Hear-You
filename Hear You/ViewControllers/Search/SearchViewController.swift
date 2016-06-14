//
//  SearchViewController.swift
//  Hear You
//
//  Created by 董亚珣 on 16/5/27.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import RealmSwift
import DGElasticPullToRefresh

class SearchViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage = 1
    
    lazy var searchResultList = [Song]()
    lazy var currentCategory = SongCategory()
    
    var popWindow : Pop?
    
    // 上拉加载视图
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.frame = CGRectMake(0, 0, 20, 20)
        indicator.color = UIColor.defaultRedColor()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableFooterView = pullUpView
        
        searchView.layer.cornerRadius = 3.0
        searchView.layer.masksToBounds = true
        
        tableView.registerNib(UINib.init(nibName: "MusicCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SearchResultCell")
        
        searchTextField.addTarget(self, action: #selector(SearchViewController.searchSong), forControlEvents: .EditingDidEndOnExit)
        searchTextField.returnKeyType = .Search
        
        title = "Search"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - EventMethod
    
    
    // MARK: - 上拉加载更多
    private func pullUpLoadMore() -> Void {
        
        guard let searchStr = searchTextField.text else {
            return
        }
        
        currentPage += 1
        
        searchSongWithName(searchStr, page: String(currentPage), size: "20", failed: nil) { (songlist) in
            
            self.pullUpView.stopAnimating()
            
            self.searchResultList.appendContentsOf(songlist)
            
            // 判断每首的歌曲是否已下载，如已下载，则标记为已下载
            dispatch_async(realmQueue) { () -> Void in
                
                for song in self.searchResultList {
                    
                    if DefaultCategory.DOWNLOADED.category.songs.contains({ (containSong) -> Bool in
                        return containSong.songID == song.songID
                    }) {
                        song.isDownloaded = true
                    } else {
                        song.isDownloaded = false
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // MARK: - 弹出操作视图
    @objc func showPopView(sender: UIButton) {
        
        let choices = ["下一首播放","收藏到歌单","下载","分享","歌手","专辑"]
        
        popWindow = Pop(choices: choices)
        
        popWindow?.tag = sender.tag
        
        popWindow?.delegate = self
        popWindow?.popFromBottomInViewController()
    }
    
    // MARK: - 搜索歌曲
    
    @objc func searchSong() {
        view.endEditing(true)
        
        guard let searchStr = searchTextField.text else {
            return
        }
        
        searchSongWithName(searchStr, page: "0", size: "20", failed: nil) { (songlist) in
            self.searchResultList = songlist
            
            // 判断每首的歌曲是否已下载，如已下载，则标记为已下载
            dispatch_async(realmQueue) { () -> Void in
                
                for song in self.searchResultList {
                    
                    if DefaultCategory.DOWNLOADED.category.songs.contains({ (containSong) -> Bool in
                        return containSong.songID == song.songID
                    }) {
                        song.isDownloaded = true
                    } else {
                        song.isDownloaded = false
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }
}

extension SearchViewController : PopViewDelegate {
    
    func popView(popView: Pop, didSelectItemAtIndex index: Int) {
        
        popView.dismiss()
        
        switch index {
        case 2:
            
            let song = searchResultList[popView.tag]
            
            // 若无歌曲信息，则提示
            guard song.downloadInfos?.count > 0 else {
                Alert.showMiddleHint("因版权原因，暂时无法提供此资源")
                return
            }
            
            guard !song.isDownloading else {
                Alert.showMiddleHint("已在下载队列中...")
                return
            }
            
            Alert.showMiddleHint("已加入下载队列")
            
            guard !song.isDownloaded else {
                Alert.showMiddleHint("该歌曲已在我的下载中")
                return
            }
            
            song.isDownloading = true
            downloadSong(song, showProgress: nil, finishedAction: {
                song.isDownloading = false
                song.isDownloaded = true
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let indexPath = NSIndexPath.init(forRow: popView.tag, inSection: 0)
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! MusicCell
                    cell.textLabel?.textColor = UIColor.defaultRedColor()
                })
            })
        default:
            break
        }
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell", forIndexPath: indexPath) as! MusicCell
        
        let song = searchResultList[indexPath.row]
        
        if song.isDownloaded {
            cell.songNameLabel.textColor = UIColor.defaultRedColor()
            cell.singerNameLabel.textColor = UIColor.defaultRedColor()
        } else {
            cell.songNameLabel.textColor = UIColor.defaultBlackColor()
            cell.singerNameLabel.textColor = UIColor.darkGrayColor()
        }

        cell.songNameLabel.text = song.songName
        cell.singerNameLabel.text = song.singerName
        
        // 记录歌曲的tag，以便后续的详情操作
        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(self, action: #selector(SearchViewController.showPopView(_:)), forControlEvents: .TouchUpInside)
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        // 获取选中的歌曲
        let song = searchResultList[indexPath.row]
        
        // 若无歌曲信息，则提示
        guard song.downloadInfos?.count > 0 else {
            Alert.showMiddleHint("因版权原因，暂时无法提供此资源")
            return
        }
        
        if let realm = try? Realm() {
            
            // 获取当前播放歌曲分类
            self.currentCategory = getLocalCategoryWithCategoryName(DefaultCategory.CURRENT.description, inRealm: realm)!
            
            
            self.currentCategory.name = DefaultCategory.SEARCH.description
            
            // 获取当前歌曲列表
            self.currentCategory.currentSonglist = self.currentCategory.songs
            
            // 若为随机模式，则打乱歌曲列表
            switch gStorage.cycleMode {
            case .RANDOM:
                self.currentCategory.currentSonglist = PlayerManager.getRandomListWithCategory(self.currentCategory)
            default:
                break
            }
            
            self.currentCategory.songs.insert(song, atIndex: 0)
            self.currentCategory.currentSonglist.insert(song, atIndex: 0)
        }
        
        (self.tabBarController as! HYTabBarController).showPlayerViewControllerWithSong(song, inCategory: self.currentCategory)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //只有在table有可见cell时上拉才会刷新数据
        if (self.tableView.visibleCells.count > 0) {
            //控制上拉范围
            if (self.tableView.contentOffset.y >= max(0, self.tableView.contentSize.height - self.tableView.frame.size.height) + 60){
                //再次发送网络请求
                
                // 正在加载数据 就不加载数据
                if !pullUpView.isAnimating() && searchResultList.count >= 20 {
                    // 菊花转起来
                    pullUpView.startAnimating()
                    
                    // 上拉加载更多数据
                    pullUpLoadMore()
                }
            }
        }
    }
}
