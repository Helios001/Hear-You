//
//  Request.swift
//  Hear You
//
//  Created by 董亚珣 on 16/5/12.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation
import Alamofire

/// api根路径
let baseURL = NSURL(string: "http://api.dongting.com/")!
let searchBaseURL = NSURL(string: "http://search.dongting.com/")!
let lricdBaseURL = NSURL(string: "http://lp.music.ttpod.com/")!

typealias NetworkSucceed = (result: JSONDictionary) -> ()
typealias NetworkFailed = (reason: NSError) -> ()

/**
 post请求
 
 - parameter URLString:  接口url
 - parameter parameters: 参数
 - parameter finished:   回调
 */
func apiRequest(apiName apiName: String, URLString: String, headers: [String : String]?, parameters: JSONDictionary?, encoding: ParameterEncoding, failed: NetworkFailed?, succeed: NetworkSucceed) {
    
    println("\n***************************** Networking Request *****************************")
    println("\nAPI: \(apiName)")
    println("\nURL: \(URLString)")
    println("\nParameters: \(parameters)")
    println("\n******************************************************************************")
    
    Alamofire.request(.GET, URLString, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
        
        println("\n***************************** Networking Response *****************************")
        println("\nAPI: \(apiName)")
        println("\nResponse:\n\(response.result.value)")
        println("\n*******************************************************************************")

        
        if let JSON = response.result.value {
            if let dict = JSON as? JSONDictionary {
                succeed(result: dict)
            } else {
                println("\nNetworking Failed: resopnse data is not a JSONDictionary")
            }
        } else {
            println("\nNetworking Failed: \(response.result.error)")
            
            if let failed = failed {
                failed(reason: response.result.error!)
            }
        }
    }
}

// MARK: - 搜索歌曲

func searchSongWithName(name: String, page: String, size: String, failed: NetworkFailed?, succeed: [Song] -> Void) {
    
    let parameters: JSONDictionary = [
        "q": name,
        "page": page,
        "size": size,
        ]
    
    apiRequest(apiName: "搜索歌曲", URLString: "http://search.dongting.com/song/search", headers: nil, parameters: parameters, encoding: .URL, failed: failed) { (result) in
        
        if let data = result["data"] as? [JSONDictionary] {
            
            var searchSongList = [Song]()
            
            for songInfo in data {
                guard let song = Song.fromJSONDictionary(songInfo) else {
                    continue
                }
                searchSongList.append(song)
            }
            
            succeed(searchSongList)
        }
    }
}

// MARK: - 歌曲列表

func searchSongList(albumID: String, failed: NetworkFailed?, succeed: SongList -> Void) {

    apiRequest(apiName: "搜索歌曲", URLString: "http://api.songlist.ttpod.com/songlists/" + albumID, headers: nil, parameters: nil, encoding: .URL, failed: failed) { (result) in
        
        let songlist = SongList.fromJSONDictionary(result)
        
        succeed(songlist)
    }
}

// MARK: - 首页展示

func getFrontpageInformation(failed: NetworkFailed?, succeed: [FrontpageElement] -> Void) {
    
    apiRequest(apiName: "首页展示", URLString: "http://api.dongting.com/frontpage/frontpage", headers: nil, parameters: nil, encoding: .URL, failed: failed) { (result) in
        
        if let data = result["data"] as? [JSONDictionary] {
            
            let frontpageElements = FrontpageElement.frmeJSONArray(data)
            
            println(frontpageElements)
            succeed(frontpageElements)
        }
    }
}
