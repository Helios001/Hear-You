//
//  PlayerViewController.swift
//  BaseKit
//
//  Created by 董亚珣 on 16/4/7.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation
import pop
import Ruler
import RealmSwift

class PlayerViewController: BaseViewController {
    
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let cornerAlbumRadius : CGFloat = 100
    
    let player = AudioPlayer.sharedPlayer
    
    let albumViewHeight = screenBounds.width * 0.7
    
    let albumTop : CGFloat = Ruler.iPhoneVertical(30, 40, 50, 60).value + 64
    
    var song : Song?
    var category : SongCategory?
    var songlist : [Song]?
    
    lazy var lrcTimer : CADisplayLink = {
        return CADisplayLink(target: self, selector: #selector(PlayerViewController.updateLrc))
    }()
    
    // 封面视图
    var albumView : UIImageView!
    
    // 歌词视图
    var lrcView : LrcView!
    
    // 左侧时间
    var leftTimeLabel: UILabel!
    
    // 右侧时间
    var rightTimeLabel: UILabel!
    
    // 播放控制视图
    var playControlView: UIView!
    
    // 音乐设置视图
    var setControlView: UIView!
    
    // 喜欢按钮
    var favouriteButton: UIButton!
    
    // 下载按钮
    var downloadButton: UIButton!
    
    // 播放模式按钮
    var cycleModeButton: UIButton!
    
    // 歌曲列表按钮
    var songlistButton: UIButton!
    
    // 播放按钮
    var playButton: UIButton!
    
    // 上一首按钮
    var previousButton: UIButton!
    
    // 下一首按钮
    var nextButton: UIButton!
    
    // 歌名标签
    var songNameLabel: UILabel!

    // 歌手标签
    var singerNameLabel: UILabel!
    
    // 专辑镖旗
    var albumNameLabel: UILabel!
    
    // 播放进度条
    var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        
        //导航栏背景透明
        navigationController?.navigationBar.subviews[0].alpha = 0
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.tintColor = UIColor.defaultRedColor()
        navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont.navigationBarTitleFont(),
            NSForegroundColorAttributeName : UIColor.defaultWhiteColor()
        ]
        
        let backItem = UIBarButtonItem.init(image: UIImage(named: "main_arrow_down"), style: .Plain, target: self, action: #selector(PlayerViewController.dismiss))
        navigationItem.leftBarButtonItem = backItem
        
        let shareItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PlayerViewController.dismiss))
        navigationItem.rightBarButtonItem = shareItem
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerViewController.songWillPlay), name: AudioPlayerWillPlay, object: nil)
        
        setupMainViews()
        
        lrcTimer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        
        // 下拉手势
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PlayerViewController.panAlbumView(_:)))
        view.addGestureRecognizer(panGesture)
        
        // 更新界面、播放歌曲
        
        guard let song = song, category = category, songlist = songlist else {
            return
        }
        
        player.playSong(song, inCategory: category)
        
        updatePlayViewWithSong(song, andSonglist: songlist)
    }
    
// MARK:
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @objc private func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - 歌曲开始播放通知
    @objc private func songWillPlay() {

        guard let song = player.currentSong else {
            return
        }
        
        updatePlayViewWithSong(song, andSonglist: player.currentList)
    }
    
// MARK: - Event Methods
    
    // MARK: - 创建视图
    
    private func setupMainViews() {
        
        // 设置约束后，下滑动画会受到影响，所以采用设置frame方式来控制视图
        
        // 创建LrcView
        lrcView = LrcView(frame: CGRectMake((screenBounds.width - albumViewHeight) / 2, albumTop, albumViewHeight, albumViewHeight))
        lrcView.alpha = 0
        lrcView.hidden = true
        blurView.addSubview(lrcView)
        
        // 创建AlbumView
        albumView = UIImageView()
        albumView.frame = CGRectMake((screenBounds.width - albumViewHeight) / 2, albumTop, albumViewHeight, albumViewHeight)
        albumView.contentMode = .ScaleAspectFill
        albumView.layer.masksToBounds = true;
        blurView.insertSubview(albumView, aboveSubview: lrcView)
        
        // 创建歌曲信息Label
        songNameLabel = UILabel()
        songNameLabel.frame = CGRectMake((screenBounds.width - albumViewHeight) / 2, albumView.frame.y + albumViewHeight + 10, albumViewHeight, 25)
        songNameLabel.textColor = UIColor.defaultWhiteColor()
        songNameLabel.textAlignment = .Center
        songNameLabel.font = UIFont.systemFontOfSize(14)
        blurView.addSubview(songNameLabel)
        
        singerNameLabel = UILabel()
        singerNameLabel.frame = CGRectMake((screenBounds.width - albumViewHeight) / 2, albumView.frame.y + albumViewHeight + 35, albumViewHeight, 25)
        singerNameLabel.textColor = UIColor(red: 200.0 / 255.0, green: 200.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
        singerNameLabel.textAlignment = .Left
        singerNameLabel.font = UIFont.systemFontOfSize(12)
        blurView.addSubview(singerNameLabel)
        
        albumNameLabel = UILabel()
        albumNameLabel.frame = CGRectMake((screenBounds.width - albumViewHeight) / 2, albumView.frame.y + albumViewHeight + 60, albumViewHeight, 25)
        albumNameLabel.textColor = UIColor.lightGrayColor()
        albumNameLabel.textAlignment = .Left
        albumNameLabel.font = UIFont.systemFontOfSize(11)
        blurView.addSubview(albumNameLabel)
        
        // 创建控制视图
        
        let progressHeight : CGFloat = 40
        let controlHeight : CGFloat = 60
        
        playControlView = UIView()
        playControlView.frame = CGRectMake(0, (view.frame.height - 20 - 40 + albumNameLabel.frame.bottom) / 2, screenBounds.width, progressHeight + controlHeight)
        playControlView.backgroundColor = UIColor.clearColor()
        blurView.addSubview(playControlView)
        
        // 创建进度条
        progressView = UIProgressView()
        progressView.progressTintColor = UIColor.defaultRedColor()
        progressView.frame = CGRectMake(60, (progressHeight - 2) / 2, screenBounds.width - 120, 2)
        playControlView.addSubview(progressView)
        
        // 创建控制按钮
        let gap : CGFloat = (playControlView.frame.width - 20 - controlHeight * 5) / 4
        
        playButton = UIButton()
        playButton.frame = CGRectMake(10 + controlHeight * 2 + gap * 2, progressHeight, controlHeight, controlHeight)
        playButton.setImage(UIImage(named: "cm2_fm_btn_play"), forState: .Normal)
        playButton.setImage(UIImage(named: "cm2_fm_btn_pause"), forState: .Selected)
        playButton.backgroundColor = UIColor.clearColor()
        playButton.setTitleColor(UIColor.defaultBlackColor(), forState: .Normal)
        playButton.setTitleColor(UIColor.defaultBlackColor(), forState: .Selected)
        playButton.addTarget(self, action: #selector(PlayerViewController.play(_:)), forControlEvents: .TouchUpInside)
        playControlView.addSubview(playButton)
        
        previousButton = UIButton()
        previousButton.frame = CGRectMake(10 + controlHeight + gap, progressHeight + (controlHeight - 44) / 2, controlHeight, 44)
        previousButton.setImage(UIImage(named: "cm2_play_btn_prev"), forState: .Normal)
        previousButton.contentMode = .Center
        previousButton.backgroundColor = UIColor.clearColor()
        previousButton.setTitleColor(UIColor.defaultBlackColor(), forState: .Normal)
        previousButton.addTarget(self, action: #selector(PlayerViewController.playPreviousSong(_:)), forControlEvents: .TouchUpInside)
        playControlView.addSubview(previousButton)
        
        nextButton = UIButton()
        nextButton.frame = CGRectMake(10 + controlHeight * 3 + gap * 3, progressHeight + (controlHeight - 44) / 2, controlHeight, 44)
        nextButton.setImage(UIImage(named: "cm2_fm_btn_next"), forState: .Normal)
        nextButton.setImage(UIImage(named: "cm2_fm_btn_next_dis"), forState: .Disabled)
        nextButton.contentMode = .Center
        nextButton.backgroundColor = UIColor.clearColor()
        nextButton.setTitleColor(UIColor.defaultBlackColor(), forState: .Normal)
        nextButton.addTarget(self, action: #selector(PlayerViewController.playNextSong(_:)), forControlEvents: .TouchUpInside)
        playControlView.addSubview(nextButton)
        
        // 创建时间进度label
        leftTimeLabel = UILabel()
        leftTimeLabel.frame = CGRectMake(10, 0, progressHeight, progressHeight)
        leftTimeLabel.text = "00:00"
        leftTimeLabel.textAlignment = .Center
        leftTimeLabel.font = UIFont.systemFontOfSize(10)
        leftTimeLabel.backgroundColor = UIColor.clearColor()
        leftTimeLabel.textColor = UIColor.defaultWhiteColor()
        playControlView.addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel()
        rightTimeLabel.frame = CGRectMake(playControlView.frame.width - 10 - progressHeight, 0, progressHeight, progressHeight)
        rightTimeLabel.text = "00:00"
        rightTimeLabel.textAlignment = .Center
        rightTimeLabel.font = UIFont.systemFontOfSize(10)
        rightTimeLabel.backgroundColor = UIColor.clearColor()
        rightTimeLabel.textColor = UIColor.defaultWhiteColor()
        playControlView.addSubview(rightTimeLabel)
        
        // 创建设置视图
        let setControlGap = screenBounds.width / 9
        let setControlHeight : CGFloat = 40
        
        setControlView = UIView()
        setControlView.frame = CGRectMake(0, playControlView.frame.top - setControlHeight, screenBounds.width, setControlHeight)
        setControlView.backgroundColor = UIColor.clearColor()
        blurView.addSubview(setControlView)
        
        // like按钮
        favouriteButton = UIButton()
        favouriteButton.frame = CGRectMake(setControlGap, 0, setControlGap, setControlHeight)
        favouriteButton.contentMode = .Center
        favouriteButton.setImage(UIImage(named: "cm2_fm_btn_love"), forState: .Normal)
        favouriteButton.setImage(UIImage(named: "cm2_fm_btn_loved_dis"), forState: .Highlighted)
        favouriteButton.setImage(UIImage(named: "cm2_fm_btn_loved"), forState: .Selected)
        favouriteButton.addTarget(self, action: #selector(PlayerViewController.setFavourite(_:)), forControlEvents: .TouchUpInside)
        setControlView.addSubview(favouriteButton)
        
        // 循环模式按钮
        cycleModeButton = UIButton()
        cycleModeButton.frame = CGRectMake(setControlGap * 3, 0, setControlGap, setControlHeight)
        cycleModeButton.contentMode = .Center
        switch gStorage.cycleMode {
        case .LISTLOOP:
            cycleModeButton.setImage(UIImage(named: "cm2_icn_loop"), forState: .Normal)
        case .SINGLECYCLE:
            cycleModeButton.setImage(UIImage(named: "cm2_icn_one"), forState: .Normal)
        case .RANDOM:
            cycleModeButton.setImage(UIImage(named: "cm2_icn_shuffle"), forState: .Normal)
        }
        cycleModeButton.addTarget(self, action: #selector(PlayerViewController.changeCycleMode(_:)), forControlEvents: .TouchUpInside)
        setControlView.addSubview(cycleModeButton)
        
        // 下载按钮
        downloadButton = UIButton()
        downloadButton.frame = CGRectMake(setControlGap * 5, 0, setControlGap, setControlHeight)
        downloadButton.contentMode = .Center
        downloadButton.setImage(UIImage(named: "cm2_play_icn_dld"), forState: .Normal)
        downloadButton.setImage(UIImage(named: "cm2_play_icn_dld_ok"), forState: .Selected)
        downloadButton.setImage(UIImage(named: "cm2_play_icn_dld_dis"), forState: .Disabled)
        downloadButton.addTarget(self, action: #selector(PlayerViewController.downloadCurrentSong(_:)), forControlEvents: .TouchUpInside)
        setControlView.addSubview(downloadButton)
        
        // 音乐列表按钮
        songlistButton = UIButton()
        songlistButton.frame = CGRectMake(setControlGap * 7, 0, setControlGap, setControlHeight)
        songlistButton.contentMode = .Center
        songlistButton.setImage(UIImage(named: "cm2_icn_list"), forState: .Normal)
//        downloadButton.addTarget(self, action: #selector(PlayerViewController.downloadCurrentSong(_:)), forControlEvents: .TouchUpInside)
        setControlView.addSubview(songlistButton)
        
    }
    
    // MARK: - 播放进程更新
    @objc private func update() {
        guard player.isPlaying else {
            return
        }

        progressView.progress = Float(player.progress)
        
        let leftTimeStr = String(format: "%02d:%02d", Int(player.duration * player.progress / 60),Int((player.duration * player.progress) % 60))
        
        let rightTimeStr = String(format: "%02d:%02d", Int(player.duration / 60),Int(player.duration % 60))
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.leftTimeLabel.text = leftTimeStr
            self.rightTimeLabel.text = rightTimeStr
        }
    }
    
    // MARK: - 播放/暂停
    @objc private func play(sender: UIButton) {
        
        if player.isPlaying {
            player.pause()
            sender.selected = false
        } else {
            player.play()
            sender.selected = true
        }
    }
    
    // MARK: - 上一首
    @objc private func playPreviousSong(sender: UIButton) {
        
        player.playPreviousSong()
    }
    
    // MARK: - 下一首
    @IBAction func playNextSong(sender: UIButton) {
        
        player.playNextSong()
    }
    
    // MARK: - 更新播放界面
    private func updatePlayViewWithSong(song: Song, andSonglist songlist: [Song]) {
        
        title = song.songName
        songNameLabel.text = song.songName
        singerNameLabel.text = song.singerName
        albumNameLabel.text = song.albumName
        
        playButton.selected = player.isPlaying
        favouriteButton.selected = song.isFavourite
        downloadButton.selected = song.isDownloaded
        
        startPlayingTimer()
        
        var rectOfText = CGRectMake(0, 0, albumViewHeight, 25)
        rectOfText = songNameLabel.textRectForBounds(rectOfText, limitedToNumberOfLines: 1)
        
        var songNameFrame = songNameLabel.frame
        songNameFrame.width = rectOfText.size.width
        songNameLabel.frame = songNameFrame
        
        guard let url = NSURL(string: song.picURL) else {
            albumView.image = UIImage()
            return
        }
        backgroundImage.af_setImageWithURL(url)
        albumView.af_setImageWithURL(url)
        
        if let lrc = song.lrc {
            
            lrcView.lyric = lrc
        } else {
            
        // MARK: - 歌词搜索
            println("***************************** Ready To Download Lyric *****************************")
            println("Lyric Name:\(song.songName)")
            println("Artist:\(song.singerName)")
            getLyricWithSongName(song.songName, songID: song.songID, artist: song.singerName, failureHandler: { (reason, _) in
                println("***************************** Download Faild *****************************")
                self.lrcView.lyric = ""
                }, completion: { (lyric) in
                    println("***************************** Download Succeed *****************************")
                    self.lrcView.lyric = lyric
                    song.lrc = lyric
            })
        }
    }
    
    // MARK: - 设置like
    @objc private func setFavourite(sender: UIButton) {
        
        guard let song = player.currentSong else {
            return
        }
        
        dispatch_async(realmQueue) { 
            if let realm = try? Realm() {
                
                if song.isFavourite {
                    deleteSong(song, fromSongCategory: DefaultCategory.FAVOURITE.description, inRealm: realm)
                    song.isFavourite = false
                    dispatch_async(dispatch_get_main_queue(), { 
                        sender.selected = false
                    })
                } else {
                    song.isFavourite = true
                    addSongToCategoryWithSong(song, andCategoryName: DefaultCategory.FAVOURITE.description, inRealm: realm)
                    dispatch_async(dispatch_get_main_queue(), {
                        sender.selected = true
                    })
                }
            }
        }
    }
    
    // MARK: - 设置播放循环模式
    @objc private func changeCycleMode(sender: UIButton) {
        
        switch gStorage.cycleMode {
        case .LISTLOOP:
            gStorage.cycleMode = .SINGLECYCLE
            cycleModeButton.setImage(UIImage(named: "cm2_icn_one"), forState: .Normal)
        case .SINGLECYCLE:
            gStorage.cycleMode = .RANDOM
            cycleModeButton.setImage(UIImage(named: "cm2_icn_shuffle"), forState: .Normal)
        case .RANDOM:
            gStorage.cycleMode = .LISTLOOP
            cycleModeButton.setImage(UIImage(named: "cm2_icn_loop"), forState: .Normal)
        }
    }
    
    // MARK: - 下载歌曲
    @objc private func downloadCurrentSong(sender: UIButton) {
        
        guard let song = player.currentSong else {
            return
        }
        
        guard !song.isDownloaded else {
            Alert.showMiddleHint("该歌曲已在我的下载中")
            return
        }
        
        guard song.downloadInfos?.count > 0 else {
            Alert.showMiddleHint("因版权原因，暂时无法提供此资源")
            return
        }
        
        guard !song.isDownloading else {
            Alert.showMiddleHint("已在下载队列中...")
            return
        }
        
        Alert.showMiddleHint("已加入下载队列")
        
        song.isDownloading = true
        downloadSong(song, showProgress: nil, finishedAction: {
            song.isDownloading = false
            song.isDownloaded = true
            dispatch_async(dispatch_get_main_queue(), {
                sender.selected = true
            })
        })
    }
    
    // MARK: - 下拉动画
    
    @objc private func panAlbumView(pan: UIPanGestureRecognizer) {
        
        let playControlCenter = playControlView.center
        
        let albumStartCenter = CGPointMake(screenBounds.width / 2, albumTop + albumViewHeight / 2)
        
        let albumEndCenter = CGPoint(x: playControlCenter.x, y: playControlCenter.y - 44 - 25 - 10 - cornerAlbumRadius / 2)
        
        let albumEndSizeX : CGFloat = cornerAlbumRadius
        let albumEndSizeY : CGFloat = cornerAlbumRadius
        
        let songNameStartCenter = CGPointMake((screenBounds.width - albumViewHeight) / 2 + songNameLabel.bounds.width / 2, albumTop + albumViewHeight + 10 + 25 / 2)
        let songNameEndCenter = CGPointMake(playControlCenter.x, playControlCenter.y - 44 - 10 - 25 / 2)
        
        switch pan.state {
            
        case .Changed:
            
            self.albumView.layer.pop_removeAllAnimations()
            
            var albumCurrentCenter = albumView.center
            var albumCurrentBounds = albumView.bounds
            
            let translation = pan.translationInView(view)
            
            albumCurrentCenter.y += translation.y
            
            let ratio = (albumCurrentCenter.y - albumStartCenter.y) / (albumEndCenter.y - albumStartCenter.y)
            
            // 封面图动画
            if albumCurrentCenter.y < albumStartCenter.y || albumCurrentCenter.y > albumEndCenter.y {
                return
            }
            
            let albumStartSizeX = albumViewHeight
            let albumStartSizeY = albumViewHeight
            
            albumCurrentBounds.size.width = albumStartSizeX - (albumStartSizeX - albumEndSizeX) * ratio
            albumCurrentBounds.size.height = albumStartSizeY - (albumStartSizeY - albumEndSizeY) * ratio
            
            albumView.bounds = albumCurrentBounds
            albumView.center = albumCurrentCenter
            
            albumView.layer.cornerRadius = albumCurrentBounds.size.height * ratio / 2
            
            // 歌曲信息视图动画
            singerNameLabel.alpha = 1 - ratio
            albumNameLabel.alpha = 1 - ratio
            
            // 歌词视图
            lrcView.alpha = ratio
            setControlView.alpha = 1 - ratio
            
            songNameLabel.center = CGPointMake(songNameStartCenter.x + (songNameEndCenter.x - songNameStartCenter.x) * ratio, songNameStartCenter.y + (songNameEndCenter.y - songNameStartCenter.y) * ratio)
            
            pan.setTranslation(CGPoint.zero, inView: view)
            
        case .Ended, .Cancelled:
            
            let albumCurrentCenter = albumView.center
            
            let ratio = (albumCurrentCenter.y - albumStartCenter.y) / (albumEndCenter.y - albumStartCenter.y)
            
            // 封面图动画
            let animPositionForAlbum = POPBasicAnimation(propertyNamed: kPOPViewCenter)
            let animSizeForAlbum = POPBasicAnimation(propertyNamed: kPOPLayerSize)
            let animCornerAlbum = POPBasicAnimation(propertyNamed: kPOPLayerCornerRadius)
            
            if ratio > 0.5 {
                animPositionForAlbum.toValue = NSValue(CGPoint:albumEndCenter)
                animSizeForAlbum.toValue = NSValue(CGSize: CGSizeMake(albumEndSizeX, albumEndSizeY))
                animCornerAlbum.toValue = cornerAlbumRadius / 2
            } else {
                animPositionForAlbum.toValue = NSValue(CGPoint:albumStartCenter)
                animSizeForAlbum.toValue = NSValue(CGSize: CGSizeMake(albumViewHeight, albumViewHeight))
                animCornerAlbum.toValue = 0
            }
            
            albumView.pop_addAnimation(animPositionForAlbum, forKey: "PositionForAlbum")
            albumView.pop_addAnimation(animSizeForAlbum, forKey: "SizeForAlbum")
            albumView.layer.pop_addAnimation(animCornerAlbum, forKey: "CornerForAlbum")
            
            // 歌曲信息视图动画
            let animPositionForSongInfo = POPBasicAnimation(propertyNamed: kPOPViewCenter)
            let animAlphaForSongInfo = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            // 歌词视图动画
            let animAlphaForLrcView = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            
            if ratio > 0.5 {
                animPositionForSongInfo.toValue = NSValue(CGPoint:songNameEndCenter)
                animAlphaForSongInfo.toValue = 0
                animAlphaForLrcView.toValue = 1
                animAlphaForSongInfo.completionBlock = { _ in
                    self.setControlView.hidden = true
                }
            } else {
                animPositionForSongInfo.toValue = NSValue(CGPoint:songNameStartCenter)
                animAlphaForSongInfo.toValue = 1
                animAlphaForLrcView.toValue = 0
                animAlphaForLrcView.completionBlock = { _ in
                    self.lrcView.hidden = true
                }
            }
            
            songNameLabel.pop_addAnimation(animPositionForSongInfo, forKey: "PositionForSongName")
            singerNameLabel.pop_addAnimation(animAlphaForSongInfo, forKey: "AlphaForSingerName")
            albumNameLabel.pop_addAnimation(animAlphaForSongInfo, forKey: "AlphaForAlbumName")
            setControlView.pop_addAnimation(animAlphaForSongInfo, forKey: "AlphaForSetControlView")
            lrcView.pop_addAnimation(animAlphaForLrcView, forKey: "AlphaForLrcView")
            
        case .Began:
            lrcView.hidden = false
            setControlView.hidden = false
            break
        case .Possible:
            break
        case .Failed:
            break
        }
    }
    
    private func startPlayingTimer() {
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(PlayerViewController.update), userInfo: nil, repeats: true)
    }
    
    // MARK: - 更新歌词视图
    @objc private func updateLrc() {

        if player.isPlaying && lrcView.alpha == 1 {
            
            lrcView.currentTime = player.currentTime
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
