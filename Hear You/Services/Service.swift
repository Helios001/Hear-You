//
//  HIService.swift
//  Hello
//
//  Created by 董亚珣 on 16/3/25.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

// MARK: - GetSongLyric

func getLyricWithSongName(songName: String, songID: Int, artist: String, failureHandler: ((Reason, String?) -> Void)?, completion: String -> Void) {
    
    let requestParameters: JSONDictionary = [
        "lrcid": "",
        "song_id": songID,
        "artist": artist,
        "title": songName,
        ]
    
    let parse: JSONDictionary -> String? = { data in
        
        if let jsonDict = data["data"] as? JSONDictionary {
            if let lycStr = jsonDict["lrc"] as? String {
                return lycStr
            }
            return nil
        }
        return nil
    }
    
    let resource = jsonResource(path: "lrc/down", method: .GET, requestParameters: requestParameters, parse: parse)
    
    if let failureHandler = failureHandler {
        apiRequest({_ in}, baseURL: lricdBaseURL, resource: resource, failure: failureHandler, completion: completion)
    } else {
        apiRequest({_ in}, baseURL: lricdBaseURL, resource: resource, failure: defaultFailureHandler, completion: completion)
    }
}


// MARK: - DownloadSong

func downloadSong(song: Song, showProgress: ((progress: Double) -> Void)?, finishedAction:(() -> Void)?) {
    
    guard !DefaultCategory.DOWNLOADED.category.songs.contains({ (containSong) -> Bool in
        return containSong.songID == song.songID
    }) else {
        return
    }
    
    guard let downloadInfo = song.downloadInfo else {
        return
    }
    
    guard let downloadURL = NSURL(string: downloadInfo.downloadURL) else {
        return
    }
    
    Downloader.downloadDataFromURL(downloadURL, reportProgress: { (progress, image) in
        
        println("audio progress: \(progress)")
        showProgress?(progress: progress)
        
        }, finishedAction: { data in
            
            song.localInfo = song.downloadInfo
            
            println("audio finish: \(data.length)")
            
            
            println("***************************** Ready To Download Lyric *****************************")
            println("Lyric Name:\(song.songName)")
            println("Artist:\(song.singerName)")
            
            if let finishedAction = finishedAction {
                finishedAction()
            }
            
            getLyricWithSongName(song.songName, songID: song.songID, artist: song.singerName, failureHandler: { (reason, _) in
                println("***************************** Download Faild *****************************")
                dispatch_async(realmQueue) {
                    if let realm = try? Realm() {

                        song.isDownloaded = true

                        addSongToCategoryWithSong(song, andCategoryName: DefaultCategory.DOWNLOADED.description, inRealm: realm)
                        
                        NSFileManager.saveSongData(data, withName: String(song.songID), andExtension: downloadInfo.suffix)
                    }
                }
                }, completion: { (lrc) in
                    println("***************************** Download Succeed *****************************")
                    dispatch_async(realmQueue) {
                        if let realm = try? Realm() {
                            song.lrc = lrc
                            song.isDownloaded = true
                            
                            addSongToCategoryWithSong(song, andCategoryName: DefaultCategory.DOWNLOADED.description, inRealm: realm)
                            
                            NSFileManager.saveSongData(data, withName: String(song.songID), andExtension: downloadInfo.suffix)
                        }
                    }
            })
    })
}

