//
//  Storge.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/8.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation

let gStorage = Storage.sharedStorage

class Storage: NSObject {
    
    static let sharedStorage = Storage()
    
    // 最后播放的歌曲
    var lastSong : Song? {
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue?.dictionayrValue, forKey: "LastSong")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        get {
            if let dict = NSUserDefaults.standardUserDefaults().valueForKey("LastSong") as? JSONDictionary {
                return Song.fromLocalJSONDictionary(dict)
            }
            return nil
        }
    }
    
    // 最后播放的歌曲分类
    var lastSongCategory : SongCategory? {
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue?.dictionayrValue, forKey: "lastSongCategory")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        get {
            if let dict = NSUserDefaults.standardUserDefaults().valueForKey("lastSongCategory") as? JSONDictionary {
                return SongCategory.fromLocalJSONDictionary(dict)
            }
            return nil
        }
    }
    
    // 最后播放的歌曲列表
//    var lastSonglist : [Song]? {
//        
//        set {
//            
//            guard let newValue = newValue else {
//                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "lastSonglist")
//                NSUserDefaults.standardUserDefaults().synchronize()
//                return
//            }
//            
//            var values = [JSONDictionary]()
//            
//            for song in newValue {
//                values.append(song.dictionayrValue)
//            }
//            NSUserDefaults.standardUserDefaults().setObject(values, forKey: "lastSonglist")
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
//        
//        get {
//            if let dict = NSUserDefaults.standardUserDefaults().valueForKey("lastSonglist") as? [JSONDictionary] {
//                var songlist = [Song]()
//                for songInfo in dict {
//                    if let song = Song.fromLocalJSONDictionary(songInfo) {
//                        songlist.append(song)
//                    }
//                }
//                return songlist
//            }
//            return nil
//        }
//    }
    
    // 循环模式
    var cycleMode : CycleMode {
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: "CycleMode")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        get {
            if let value = NSUserDefaults.standardUserDefaults().valueForKey("CycleMode") as? String {
                switch value {
                case CycleMode.RANDOM.rawValue:
                    return .RANDOM
                case CycleMode.SINGLECYCLE.rawValue:
                    return .SINGLECYCLE
                default:
                    return .LISTLOOP
                }
            } else {
                return .LISTLOOP
            }
        }
    }
    
    // 试听品质
    var qualityForListen : Quality {
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: "qualityForListen")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        get {
            if let value = NSUserDefaults.standardUserDefaults().valueForKey("qualityForListen") as? String {
                switch value {
                case Quality.HIGH.rawValue:
                    return .HIGH
                case Quality.STANDARD.rawValue:
                    return .STANDARD
                default:
                    return .FLUENT
                }
            } else {
                return .FLUENT
            }
        }
    }
    
    // 下载品质
    var qualityForDownload : Quality {
        
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue.rawValue, forKey: "qualityForDownload")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        get {
            if let value = NSUserDefaults.standardUserDefaults().valueForKey("qualityForDownload") as? String {
                switch value {
                case Quality.HIGH.rawValue:
                    return .HIGH
                case Quality.STANDARD.rawValue:
                    return .STANDARD
                default:
                    return .FLUENT
                }
            } else {
                return .FLUENT
            }
        }
    }
}