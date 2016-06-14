//
//  Models.swift
//  Hello
//
//  Created by 董亚珣 on 16/3/30.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation
import RealmSwift

// 总是在这个队列里使用 Realm
let realmQueue = dispatch_queue_create("com.YourApp.YourQueue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0))

// MARK: - Song

class RealmSong: Object {
    
    dynamic var songID          : Int = 0
    dynamic var songName        : String = ""
    
    dynamic var singerID        : Int = 0
    dynamic var singerName      : String = ""
    
    dynamic var albumID         : Int = 0
    dynamic var albumName       : String = ""
    
    dynamic var picURL          : String = ""
    
    dynamic var lrc             : String?
    
    dynamic var isDownloaded    : Bool = false
    
    dynamic var isFavourite     : Bool = false
    
    var downloadInfos = List<RealmDownloadInfo>()
    
    dynamic var localInfo : RealmDownloadInfo?
    
    class func createRealmSongWithSong(song: Song, inRealm realm: Realm) -> RealmSong {
        
        let realmSong = RealmSong()
        realmSong.songID = song.songID
        realmSong.songName = song.songName
        realmSong.singerID = song.singerID
        realmSong.singerName = song.singerName
        realmSong.albumID = song.albumID
        realmSong.albumName = song.albumName
        realmSong.picURL = song.picURL
        realmSong.isDownloaded = song.isDownloaded
        realmSong.isFavourite = song.isFavourite
        realmSong.lrc = song.lrc
        
        guard let downloadInfo = song.downloadInfo, let downloadInfos = song.downloadInfos else {
            
            return realmSong
        }
        
        let tmpDownloadInfo = RealmDownloadInfo()
        
        tmpDownloadInfo.bitRate = downloadInfo.bitRate
        tmpDownloadInfo.duration = downloadInfo.duration
        tmpDownloadInfo.size = downloadInfo.size
        tmpDownloadInfo.suffix = downloadInfo.suffix
        tmpDownloadInfo.downloadURL = downloadInfo.downloadURL
        tmpDownloadInfo.typeDescription = downloadInfo.typeDescription
        
        realmSong.localInfo = tmpDownloadInfo
        
        for info in downloadInfos {
            
            let tmpInfo = RealmDownloadInfo()
            
            tmpInfo.bitRate = info.bitRate
            tmpInfo.duration = info.duration
            tmpInfo.size = info.size
            tmpInfo.suffix = info.suffix
            tmpInfo.downloadURL = info.downloadURL
            tmpInfo.typeDescription = info.typeDescription
            let _ = try? realm.write {
                realmSong.downloadInfos.append(tmpInfo)
            }
        }
        
        return realmSong
    }
}

// MARK: - DownloadInfo

class RealmDownloadInfo: Object {
    dynamic var bitRate         : Int = 0
    dynamic var duration        : Int = 0
    dynamic var size            : Int = 0
    dynamic var suffix          : String = ""
    dynamic var downloadURL     : String = ""
    dynamic var typeDescription : String = ""
}

// MARK: - SongCategory

class RealmSongCategory: Object {
    
    dynamic var name: String = ""
    
    dynamic var count: Int {
        
        get {
            return songs.count
        }
    }
    
    var songs = List<RealmSong>()
}

// MARK: - Helpers

//
func getRealmSongWithSongID(songID:Int, inRealm realm: Realm) -> RealmSong? {
    let predicate = NSPredicate(format: "songID = %d", songID)
    return realm.objects(RealmSong).filter(predicate).first
}

//
func getLocalSongWithSongID(songID:Int, inRealm realm: Realm) -> Song? {
    let predicate = NSPredicate(format: "songID = %d", songID)
    let realmSong = realm.objects(RealmSong).filter(predicate).first
    
    guard let tmpSong = realmSong else {
        return nil
    }
    
    let song = Song()
    
    song.songID = tmpSong.songID
    song.songName = tmpSong.songName
    song.singerID = tmpSong.singerID
    song.singerName = tmpSong.singerName
    song.albumID = tmpSong.albumID
    song.albumName = tmpSong.albumName
    song.picURL = tmpSong.picURL
    song.lrc = tmpSong.lrc
    song.isDownloaded = tmpSong.isDownloaded
    song.isFavourite = tmpSong.isFavourite
    
    var tmpInfos = [DownloadInfo]()
    for info in tmpSong.downloadInfos {
        let tmpInfo = DownloadInfo.createDownloadInfoWithDownloadInfo(bitRate: info.bitRate, duration: info.duration, size: info.size, suffix: info.suffix, downloadURL: info.downloadURL, typeDescription: info.typeDescription)
        tmpInfos.append(tmpInfo)
    }
    song.downloadInfos = tmpInfos
    
    guard let tmpLocalInfo = tmpSong.localInfo else {
        return song
    }
    
    song.localInfo = DownloadInfo.createDownloadInfoWithDownloadInfo(bitRate: tmpLocalInfo.bitRate, duration: tmpLocalInfo.duration, size: tmpLocalInfo.size, suffix: tmpLocalInfo.suffix, downloadURL: tmpLocalInfo.downloadURL, typeDescription: tmpLocalInfo.typeDescription)
    
    return song
}

// 更新本地数据库中的歌曲信息
func updateRealmSong(realmSong: RealmSong, withSong song: Song, inRealm realm: Realm) {
    
    let _ = try? realm.write {
        realmSong.songID = song.songID
        realmSong.songName = song.songName
        realmSong.singerID = song.singerID
        realmSong.singerName = song.singerName
        realmSong.albumID = song.albumID
        realmSong.albumName = song.albumName
        realmSong.picURL = song.picURL
        realmSong.isDownloaded = song.isDownloaded
        realmSong.isFavourite = song.isFavourite
        realmSong.lrc = song.lrc
    }
    
    guard let downloadInfo = song.downloadInfo, let downloadInfos = song.downloadInfos else {
        return
    }
    
    let tmpDownloadInfo = RealmDownloadInfo()
    
    tmpDownloadInfo.bitRate = downloadInfo.bitRate
    tmpDownloadInfo.duration = downloadInfo.duration
    tmpDownloadInfo.size = downloadInfo.size
    tmpDownloadInfo.suffix = downloadInfo.suffix
    tmpDownloadInfo.downloadURL = downloadInfo.downloadURL
    tmpDownloadInfo.typeDescription = downloadInfo.typeDescription
    
    let _ = try? realm.write {
        realmSong.localInfo = tmpDownloadInfo
    }
    
    for info in downloadInfos {
        
        let tmpInfo = RealmDownloadInfo()
        
        tmpInfo.bitRate = info.bitRate
        tmpInfo.duration = info.duration
        tmpInfo.size = info.size
        tmpInfo.suffix = info.suffix
        tmpInfo.downloadURL = info.downloadURL
        tmpInfo.typeDescription = info.typeDescription
        let _ = try? realm.write {
            realmSong.downloadInfos.append(tmpInfo)
        }
    }
}

//
func getRealmCategoryWithCategoryName(categoryName: String, inRealm realm: Realm) -> RealmSongCategory? {
    
    let predicate = NSPredicate(format: "name = %@", categoryName)
    return realm.objects(RealmSongCategory).filter(predicate).first
}

// 获取数据库中存储的歌曲分类信息
func getLocalCategoryWithCategoryName(categoryName: String, inRealm realm: Realm) -> SongCategory? {
    
    let predicate = NSPredicate(format: "name = %@", categoryName)
    let realmCategory = realm.objects(RealmSongCategory).filter(predicate).first
    
    guard let tmpCategory = realmCategory else {
        return nil
    }
    
    let category = SongCategory()
    
    category.name = tmpCategory.name
    
    for realmSong in tmpCategory.songs {
        
        let song = getLocalSongWithSongID(realmSong.songID, inRealm: realm)
        guard let tmpSong = song else {
            break
        }
        category.songs.append(tmpSong)
        category.currentSonglist.append(tmpSong)
    }
    
    return category
}


// 向歌曲分类中添加歌曲
func addSongToCategoryWithSong(song: Song, andCategoryName categoryName: String, inRealm realm: Realm) {
    
    let predicate = NSPredicate(format: "songID = %d", song.songID)
    
    var realmSong = realm.objects(RealmSong).filter(predicate).first
    
    if realmSong == nil {
        realmSong = RealmSong.createRealmSongWithSong(song, inRealm: realm)
    } else {
        updateRealmSong(realmSong!, withSong: song, inRealm: realm)
    }
    
    if let category = getRealmCategoryWithCategoryName(categoryName, inRealm: realm) {
        
        let tmparr = category.songs.filter(predicate)
        
        if tmparr.count > 0 {
            return
        }else {
            let _ = try? realm.write {
                category.songs.insert(realmSong!, atIndex: 0)
            }
        }
        
    } else {
        
        let category = RealmSongCategory()
        
        category.name = categoryName
        let _ = try? realm.write {
            category.songs.insert(realmSong!, atIndex: 0)
            realm.add(category)
        }
    }
}

// 从歌曲分类中删除歌曲信息
func deleteSong(song: Song, fromSongCategory categoryName: String, inRealm realm: Realm) {
    
    if let category = getRealmCategoryWithCategoryName(categoryName, inRealm: realm) {
        let predicate = NSPredicate(format: "songID = %d", song.songID)
        let tmparr = category.songs.filter(predicate)
        
        if tmparr.count > 0 {
            
            let index = category.songs.indexOf(tmparr[0])
            let _ = try? realm.write {
                tmparr[0].isFavourite = false
                category.songs.removeAtIndex(index!)
            }
        }
    }
}

// 删除歌曲信息
func deleteSong(song: Song, inRealm realm: Realm) {
    
    let predicate = NSPredicate(format: "songID = %d", song.songID)
    
    let realmSongArr = realm.objects(RealmSong).filter(predicate)
    
    for realmSong in realmSongArr {
        let _ = try? realm.write({ 
            realm.delete(realmSong)
        })
    }
}

