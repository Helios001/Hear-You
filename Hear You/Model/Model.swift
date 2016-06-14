//
//  Model.swift
//  Hear You
//
//  Created by 董亚珣 on 16/4/12.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation

// MARK: - Song

class Song: NSObject {
    
    dynamic var songID          : Int = 0
    dynamic var songName        : String = ""
    
    dynamic var singerID        : Int = 0
    dynamic var singerName      : String = ""
    
    dynamic var albumID         : Int = 0
    dynamic var albumName       : String = ""
    
    dynamic var picURL          : String = ""
    
    dynamic var lrc             : String?
    
    dynamic var isDownloaded    : Bool = false
    
    dynamic var isDownloading   : Bool = false
    
    dynamic var isFavourite     : Bool = false
    
    dynamic var downloadInfos   : [DownloadInfo]?
    
    dynamic var localInfo       : DownloadInfo?
    
    dynamic var downloadInfo    : DownloadInfo? {
        
        get {
            
            guard let downloadinfos = self.downloadInfos else {
                return nil
            }
            
            if downloadinfos.count > 2 {
                switch gStorage.qualityForDownload {
                case .FLUENT:

                    return downloadinfos.first
                case .STANDARD:

                    return downloadinfos[1]
                case .HIGH:

                    return downloadinfos[2]
                }
            }
            else if downloadinfos.count > 1 {
                switch gStorage.qualityForDownload {
                case .FLUENT:
                    
                    return downloadinfos.first
                case .STANDARD, .HIGH:
                    
                    return downloadinfos[1]
                }
            }
            else if downloadinfos.count > 0 {
                return downloadinfos.first
            }
            else {
                return nil
            }
        }
    }
    
    dynamic var listenInfo      : DownloadInfo? {
        
        get {
            guard let listenInfos = self.downloadInfos else {
                return nil
            }
            
            if listenInfos.count > 2 {
                switch gStorage.qualityForListen {
                case .FLUENT:
                    
                    return listenInfos.first
                case .STANDARD:
                    
                    return listenInfos[1]
                case .HIGH:
                    
                    return listenInfos[2]
                }
            }
            else if listenInfos.count > 1 {
                switch gStorage.qualityForListen {
                case .FLUENT:
                    
                    return listenInfos.first
                case .STANDARD, .HIGH:
                    
                    return listenInfos[1]
                }
            }
            else if listenInfos.count > 0 {
                return listenInfos.first
            }
            else {
                return nil
            }
        }
    }
    
    var dictionayrValue : JSONDictionary {
        get {
            var dict = JSONDictionary()
            
            dict["songID"] = songID
            dict["songName"] = songName
            dict["singerID"] = singerID
            dict["singerName"] = singerName
            dict["albumID"] = albumID
            dict["albumName"] = albumName
            dict["picURL"] = picURL
            dict["lrc"] = lrc
            dict["isDownloaded"] = isDownloaded
            dict["isDownloading"] = isDownloading
            dict["isFavourite"] = isFavourite
            var infos = [JSONDictionary]()
            if let downloadInfos = downloadInfos {
                for info in downloadInfos {
                    infos.append(info.dictionayrValue)
                }
            }
            dict["downloadInfos"] = infos
            dict["localInfo"] = localInfo?.dictionayrValue
            
            return dict
        }
    }
    
    class func fromLocalJSONDictionary(dict: JSONDictionary?) -> Song? {
        
        guard let dict = dict else {
            return nil
        }
        
        let song = Song()
        
        song.songID = dict["songID"] as! Int
        song.songName = dict["songName"] as! String
        song.singerID = dict["singerID"] as! Int
        song.singerName = dict["singerName"] as! String
        song.albumID = dict["albumID"] as! Int
        song.albumName = dict["albumName"] as! String
        song.picURL = dict["picURL"] as! String
        song.lrc = dict["lrc"] as? String
        song.isDownloaded = dict["isDownloaded"] as! Bool
        song.isDownloading = dict["isDownloading"] as! Bool
        song.isFavourite = dict["isFavourite"] as! Bool
        
        song.downloadInfos = [DownloadInfo]()
        
        if let downloadInfoDictArr = dict["downloadInfos"] as? [JSONDictionary] {
            for downloadInfoDict in downloadInfoDictArr {
                guard let downloadInfo = DownloadInfo.fromLocalJSONDictionary(downloadInfoDict) else {
                    break
                }
                song.downloadInfos?.append(downloadInfo)
            }
        }
        
        if let localInfoDict = dict["localInfo"] as? JSONDictionary {
            song.localInfo = DownloadInfo.fromLocalJSONDictionary(localInfoDict)
        }
        
        return song
    }
    
    class func fromJSONDictionary(songInfo: JSONDictionary) -> Song? {
        
        let song = Song()
        
        if let songID = songInfo["songId"] as? Int {
            song.songID = songID
        }
        if let songName = songInfo["name"] as? String {
            song.songName = songName
        }
        if let singerID = songInfo["singerId"] as? Int {
            song.singerID = singerID
        }
        if let singerName = songInfo["singerName"] as? String {
            song.singerName = singerName
        }
        if let albumID = songInfo["albumId"] as? Int {
            song.albumID = albumID
        }
        if let albumName = songInfo["albumName"] as? String {
            song.albumName = albumName
        }
        if let picURL = songInfo["picUrl"] as? String {
            song.picURL = picURL
        }
        
        if let urlList = songInfo["urlList"] as? [JSONDictionary] {
            var downloadInfos = [DownloadInfo]()
            
            for urlInfo in urlList {
                
                if let url = DownloadInfo.fromJSONDictionary(urlInfo) {
                    downloadInfos.append(url)
                }
            }
            
            song.downloadInfos = downloadInfos
        }
        
        return song
    }
}

// MARK: - DownloadInfo

class DownloadInfo: NSObject {
    dynamic var bitRate         : Int = 0
    dynamic var duration        : Int = 0
    dynamic var size            : Int = 0
    dynamic var suffix          : String = ""
    dynamic var downloadURL     : String = ""
    dynamic var typeDescription : String = ""
    
    var dictionayrValue : JSONDictionary {
        get {
            var dict = JSONDictionary()
            
            dict["bitRate"] = bitRate
            dict["duration"] = duration
            dict["size"] = size
            dict["suffix"] = suffix
            dict["downloadURL"] = downloadURL
            dict["typeDescription"] = typeDescription
            
            return dict
        }
    }
    
    class func fromLocalJSONDictionary(dict: JSONDictionary?) -> DownloadInfo? {
        
        guard let dict = dict else {
            return nil
        }
        
        let downloadInfo = DownloadInfo()
        
        downloadInfo.bitRate = dict["bitRate"] as! Int
        downloadInfo.duration = dict["duration"] as! Int
        downloadInfo.size = dict["size"] as! Int
        downloadInfo.suffix = dict["suffix"] as! String
        downloadInfo.downloadURL = dict["downloadURL"] as! String
        downloadInfo.typeDescription = dict["typeDescription"] as! String
        
        return downloadInfo
    }
    
    class func fromJSONDictionary(downloadInfo: JSONDictionary) -> DownloadInfo? {
        let bitRate = downloadInfo["bitRate"] as! Int
        let duration = downloadInfo["duration"] as! Int
        let size = downloadInfo["size"] as! Int
        let suffix = downloadInfo["suffix"] as! String
        let downloadURL = downloadInfo["url"] as! String
        let typeDescription = downloadInfo["typeDescription"] as! String
        
        return createDownloadInfoWithDownloadInfo(bitRate: bitRate, duration: duration, size: size, suffix: suffix, downloadURL: downloadURL, typeDescription: typeDescription)
    }
    
    class func createDownloadInfoWithDownloadInfo(bitRate bitRate: Int, duration: Int, size: Int, suffix: String, downloadURL: String, typeDescription: String) -> DownloadInfo {
        
        let downloadInfo = DownloadInfo()
        downloadInfo.bitRate = bitRate
        downloadInfo.duration = duration
        downloadInfo.size = size
        downloadInfo.suffix = suffix
        downloadInfo.downloadURL = downloadURL
        downloadInfo.typeDescription = typeDescription
        
        return downloadInfo
    }
}

// MARK: - SongCategory

class SongCategory: NSObject {
    
    dynamic var name: String = ""
    
    dynamic var count: Int {
        
        get {
            return songs.count
        }
    }
    
    dynamic var songs = [Song]()
    
    dynamic var currentSonglist = [Song]()
    
    var dictionayrValue : JSONDictionary {
        
        get {
            var dict = JSONDictionary()
            
            dict["name"] = name
            
            var songsInfo = [JSONDictionary]()
            for song in songs {
                songsInfo.append(song.dictionayrValue)
            }
            dict["songs"] = songsInfo
            
            var currentSonglistInfo = [JSONDictionary]()
            for song in currentSonglist {
                currentSonglistInfo.append(song.dictionayrValue)
            }
            dict["currentSonglist"] = currentSonglistInfo

            return dict
        }
    }
    
    class func fromLocalJSONDictionary(dict: JSONDictionary?) -> SongCategory? {
        
        guard let dict = dict else {
            return nil
        }
        
        let category = SongCategory()
        
        category.name = dict["name"] as! String

        category.songs = [Song]()
        
        if let songsInfo = dict["songs"] as? [JSONDictionary] {
            for songInfo in songsInfo {
                guard let song = Song.fromLocalJSONDictionary(songInfo) else {
                    break
                }
                category.songs.append(song)
            }
        }
        
        if let currentSonglistInfo = dict["currentSonglist"] as? [JSONDictionary] {
            for songlistInfo in currentSonglistInfo {
                guard let song = Song.fromLocalJSONDictionary(songlistInfo) else {
                    break
                }
                category.currentSonglist.append(song)
            }
        }
        
        return category
    }
    
    class func createSongCategoryWithName(name: String, andSongs songs: [Song]) -> SongCategory{
        
        let category = SongCategory()
        category.name = name
        category.songs = songs
        category.currentSonglist = songs
        return category
    }
}

// MARK: - LrcLine

class LrcLine: CustomStringConvertible {
    dynamic var words: String!
    dynamic var time: String!
    
    var description: String {
        return "LrcLine(words: \(words), time: \(time))"
    }
}

// MARK: - 首页展示元素

struct FrontpageElement: CustomStringConvertible {
    let id: Int
    let name: String
    let desc: String?
    let isNameDisplay: Int
    let data: [Album]
    
    static func fromJSONDictionary(dict: JSONDictionary) -> FrontpageElement? {
        if
            let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let albumsData = dict["data"] as? [JSONDictionary]{
            
            let albums = Album.fromJSONArray(albumsData)
            let desc = dict["desc"] as? String
            let isNameDisplay = dict["isNameDisplay"] as! Int
            
            let frontpage = FrontpageElement(id: id, name: name, desc: desc, isNameDisplay: isNameDisplay, data: albums)
            
            return frontpage
        }
        
        return nil
    }
    
    static func frmeJSONArray(arr: [JSONDictionary]) -> [FrontpageElement] {
        
        var list = [FrontpageElement]()
        
        for element in arr {
            
            if let one = FrontpageElement.fromJSONDictionary(element) {
                list.append(one)
            }
        }
        
        return list
    }
    
    var description: String {
        return "FrontpageElement\n id: \(id)\n name: \(name)\n data: \(data))"
    }
}

// MARK: - 首页专辑

struct Album: CustomStringConvertible {
    let id: Int
    let name: String
    let desc: String?
    let picUrl: String
    let actionType : Int
    let actionValue : String
    
    static func fromJSONDictionary(dict: JSONDictionary) -> Album? {
        if
            let id = dict["id"] as? Int,
            let name = dict["name"] as? String,
            let picUrl = dict["picUrl"] as? String,
            let action = dict["action"] as? JSONDictionary,
            let actionType = action["type"] as? Int,
            let actionValue = action["value"] as? String
        {
        
            let desc = dict["desc"] as? String
            let album = Album(id: id, name: name, desc: desc, picUrl: picUrl, actionType: actionType, actionValue: actionValue)
            
            return album
        }
        
        return nil
    }
    
    static func fromJSONArray(arr: [JSONDictionary]) -> [Album] {
        
        var list = [Album]()
        
        for element in arr {
            
            if let one = Album.fromJSONDictionary(element) {
                list.append(one)
            }
        }
        
        return list
    }
    
    var description: String {
        return "\nAlbum(id: \(id), name: \(name))"
    }
}

// MARK: - 歌单

class SongList: NSObject {
    var id: Int = 0
    var title: String = ""
    var desc: String?
    var picUrl: String = ""
    var song_count : Int = 0
    var favorite_count : Int = 0
    var comment_count : Int = 0
    var share_count : Int = 0
    var listen_count : Int = 0
    var songs = [Song]()
    
    class func fromJSONDictionary(dict: JSONDictionary) -> SongList {
        let list = SongList()
        
        let image = dict["image"] as! JSONDictionary
        list.picUrl = image["pic"] as! String
        list.id = dict["songlist_id"] as! Int
        list.title = dict["title"] as! String
        list.desc = dict["desc"] as? String
        list.song_count = dict["song_count"] as! Int
        list.favorite_count = dict["song_count"] as! Int
        list.comment_count = dict["song_count"] as! Int
        list.share_count = dict["song_count"] as! Int
        list.listen_count = dict["song_count"] as! Int
        
        let songsData = dict["songs"] as![JSONDictionary]
        
        for songDict in songsData {
            if let song = Song.fromJSONDictionary(songDict) {
                list.songs.append(song)
            }
        }

        return list
    }
}

