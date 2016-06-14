//
//  AudioPlayer.swift
//  Hello
//
//  Created by 董亚珣 on 16/3/30.
//  Copyright © 2016年 snow. All rights reserved.
//

import AVFoundation
import RealmSwift

class AudioPlayer : NSObject {
    
// MARK: - Public Properties
    
    var currentCategory : SongCategory? {
        
        get {
            return tmpCurrentCategory
        }
    }
    
    var currentSong : Song? {
        
        get {
            
            guard let index = currentIndex else {
                return nil
            }
            
            return currentList[index]
        }
    }
    
    var nextSong : Song {
        
        get {
            
            return currentList[nextIndex]
        }
    }
    
    var preSong : Song {
        
        get {
            
            return currentList[preIndex]
        }
    }
    
    var currentList = [Song]()
    
    var isPlaying : Bool = false
    
    var progress : Double {
        
        get {
            guard let currentTime = currentItem?.currentTime() else {
                return 0
            }
            
            let time = CMTimeGetSeconds(currentTime) / duration
            
            if (time.isNaN || time.isInfinite) {
                return 0
            } else {
                return time
            }
        }
    }
    
    var duration : NSTimeInterval {
        
        get {
            guard let duration = currentItem?.duration else {
                return 0
            }
            
            let time = CMTimeGetSeconds(duration)
            if (time.isNaN || time.isInfinite) {
                return 0
            } else {
                return time
            }
        }
    }
    
    var currentTime : NSTimeInterval {
        
        get {
            guard let currentTime = currentItem?.currentTime() else {
                return 0
            }
            return CMTimeGetSeconds(currentTime)
        }
    }
    
    
// MARK: - Private Properties
    
    // swift中的单例
    static let sharedPlayer = AudioPlayer()

    private var player : AVPlayer?
    
    private var tmpCurrentCategory : SongCategory?
    
    private var currentIndex : Int?
    
    private var nextIndex: Int {
        get {
            var index = currentIndex! + 1
            if index >= currentList.count {
                index = 0
                currentIndex = index
            }
            return index
        }
    }
    
    private var preIndex: Int {
        get {
            var index = currentIndex! - 1
            if index < 0 {
                index = currentList.count-1
                currentIndex = index
            }
            return index
        }
    }
    
    private var currentSongID : Int? {
        get {
            guard let index = currentIndex else {
                return nil
            }
            return currentList[index].songID
        }
    }
    
    private var currentItem : AVPlayerItem? {
        get {
            return player?.currentItem
        }
    }

    private var nextItem: AVPlayerItem? {
        get {
            let index : Int = {
                switch gStorage.cycleMode {
                case .LISTLOOP, .RANDOM:
                    return nextIndex
                case .SINGLECYCLE:
                    return currentIndex!
                }
            }()
            
            let song = currentList[index]
            
            let songURL : NSURL? = {
                if song.isDownloaded {
                    guard let localInfo = song.localInfo else {
                        return nil
                    }
                    return NSFileManager.songURLWithName(String(song.songID), andExtension: localInfo.suffix)
                }else {
                    guard let listenInfo = song.listenInfo else {
                        return nil
                    }
                    return NSURL(string: listenInfo.downloadURL)
                }
            }()
            
            guard let url = songURL else {
                currentIndex = index
                return self.nextSongItem
            }
            
            currentIndex = index

            println("\n***************************** Ready To Play Music *****************************")
            println("SongName:\(song.songName)")
            println("SongFilePath:\(url)")

            return AVPlayerItem(URL: url)
        }
    }
    
    private var nextSongItem: AVPlayerItem? {
        
        get {
            let index = nextIndex
            
            let song = currentList[index]
            
            let songURL : NSURL? = {
                if song.isDownloaded {
                    
                    if let localInfo = song.localInfo {
                        return NSFileManager.songURLWithName(String(song.songID), andExtension: localInfo.suffix)
                    } else {
                        if let realm = try? Realm() {
                            if let song = getLocalSongWithSongID(song.songID, inRealm: realm), let localInfo = song.localInfo {
                                return NSFileManager.songURLWithName(String(song.songID), andExtension: localInfo.suffix)
                            }
                        }
                        return nil
                    }
                }else {
                    guard let listenInfo = song.listenInfo else {
                        return nil
                    }
                    return NSURL(string: listenInfo.downloadURL)
                }
            }()
            
            guard let url = songURL else {
                currentIndex = index
                return self.nextSongItem
            }
            
            currentIndex = index
            
            println("\n***************************** Ready To Play Music *****************************")
            println("SongName:\(song.songName)")
            println("SongFilePath:\(url)")
            
            return AVPlayerItem(URL: url)
        }
    }
    
    private var previousSongItem: AVPlayerItem? {
        
        get {
            let index = preIndex
            
            let song = currentList[index]
            
            let songURL : NSURL? = {
                if song.isDownloaded {
                    guard let localInfo = song.localInfo else {
                        return nil
                    }
                    return NSFileManager.songURLWithName(String(song.songID), andExtension: localInfo.suffix)
                }else {
                    guard let listenInfo = song.listenInfo else {
                        return nil
                    }
                    return NSURL(string: listenInfo.downloadURL)
                }
            }()
            
            guard let url = songURL else {
                currentIndex = index
                return self.previousSongItem
            }
            
            currentIndex = index
            
            println("\n***************************** Ready To Play Music *****************************")
            println("SongName:\(song.songName)")
            println("SongFilePath:\(url)")
            
            return AVPlayerItem(URL: url)
        }
    }
    

// MARK: - Public Methods
    
    // MARK: - 播放歌曲
    
    func playSong(song: Song!, inCategory category: SongCategory!) {
        
        guard !isCurrentSong(song, inCategory: category) else {
            return
        }
        
        tmpCurrentCategory = category
        
        currentList = category.currentSonglist
        
        var index = currentList.indexOf(song)
        
        if index == nil {
            for tmpSong in currentList {
                if song.songID == tmpSong.songID {
                    index = currentList.indexOf(tmpSong)
                    break
                }
            }
        }
        
        currentIndex = index
        
        stop()
        
        let songURL : NSURL? = {
            
            if song.isDownloaded {
                
                guard let localInfo = song.localInfo else {
                    return nil
                }
                
                return NSFileManager.songURLWithName(String(song.songID), andExtension: localInfo.suffix)
            }else {
                
                guard let listenInfo = song.listenInfo else {
                    return nil
                }
                
                return NSURL(string: listenInfo.downloadURL)
            }
        }()
        
        if let url = songURL {
            
            let playerItem = AVPlayerItem(URL: url)
            
            player = AVPlayer(playerItem: playerItem)
            
            saveCurrentSongToLastCategory()
            play()
            
            
        } else {
            
            println("\n***************************** Play Failed *****************************")
            
            guard let playerItem = nextSongItem else {
                return
            }
            
            player = AVPlayer(playerItem: playerItem)
            
            saveCurrentSongToLastCategory()
            play()
        }
    }
    
    // MARK: - 播放下一首
    
    func playNextSong() {
        player?.replaceCurrentItemWithPlayerItem(nextSongItem)
        saveCurrentSongToLastCategory()
        play()
    }
    
    // MARK: - 播放上一首
    
    func playPreviousSong() {
        player?.replaceCurrentItemWithPlayerItem(previousSongItem)
        saveCurrentSongToLastCategory()
        play()
    }
    
    // MARK: - 播放
    
    func play() {
        
        println("\n***************************** Play Succeed *****************************")
        
        NSNotificationCenter.defaultCenter().postNotificationName(AudioPlayerWillPlay, object: nil)
    
        player?.play()
        isPlaying = true
    }
    
    // MARK: - 暂停
    
    func pause() {
        guard isPlaying else {
            return
        }
        player?.pause()
        isPlaying = false
    }
    
    // MARK: - 跳转
    
    func seekToProgress(progress: Double) {
        
        let time = CMTime(seconds: (duration * progress), preferredTimescale: Int32(1))
        player?.seekToTime(time, completionHandler: { (finished) -> Void in
            if finished {
                self.play()
            }
        })
    }
    
    
    
// MARK: - Private Methods
    
    private override init() {
        super.init()
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        try! AVAudioSession.sharedInstance().setActive(true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.didPlayToEndTime), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioPlayer.failedToPlayToEndTime), name: AVPlayerItemFailedToPlayToEndTimeNotification, object: nil)
        
    }
    
    private func isCurrentSong(song: Song!, inCategory category: SongCategory!) -> Bool {
        
        guard let id = currentSong?.songID, tmpCategory = tmpCurrentCategory else{
            return false
        }
        
        return id == song.songID && category.name == tmpCategory.name
    }
    
    
    private func stop() {
        pause()
    }
    
    // MARK: - 将播放的歌曲保存到最近播放列表中
    private func saveCurrentSongToLastCategory() {
        
        dispatch_async(realmQueue) { _ in
            
            gStorage.lastSong = self.currentSong
            gStorage.lastSongCategory = self.currentCategory
            
            if let realm = try? Realm() {
                
                let category = getRealmCategoryWithCategoryName(DefaultCategory.LATEST.description, inRealm: realm)
                
                if category?.songs.count >= 100 {
                    category?.songs.removeAtIndex(99)
                }
                
                addSongToCategoryWithSong(self.currentSong!, andCategoryName: DefaultCategory.LATEST.description, inRealm: realm)
            }
        }
    }
    
    @objc private func didPlayToEndTime() {
        player?.replaceCurrentItemWithPlayerItem(nextItem)
        saveCurrentSongToLastCategory()
        play()
    }
    
    @objc private func failedToPlayToEndTime() {
        

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
