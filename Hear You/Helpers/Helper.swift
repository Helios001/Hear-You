//
//  Helper.swift
//  Hear You
//
//  Created by 董亚珣 on 16/4/12.
//  Copyright © 2016年 snow. All rights reserved.
//

import Foundation
import UIKit
import DMMaterialTransition
import RealmSwift

// MARK: - ENUM

// 循环模式
enum CycleMode : String, CustomStringConvertible {
    case LISTLOOP = "LISTLOOP"
    case SINGLECYCLE = "SINGLECYCLE"
    case RANDOM = "RANDOM"
    
    var description : String {
        return self.rawValue
    }
}

// 歌曲品质
enum Quality : String, CustomStringConvertible {
    case FLUENT = "流畅品质"
    case STANDARD = "标准品质"
    case HIGH = "超高品质"
    
    var description : String {
        return self.rawValue
    }
}

// 默认分类
enum DefaultCategory : String, CustomStringConvertible {
    case DOWNLOADED = "已下载"
    case FAVOURITE = "我喜欢的音乐"
    case LATEST = "最近播放"
    case SEARCH = "试听列表"
    case CURRENT = "当前列表"
    
    var description : String {
        return self.rawValue
    }
    
    var category : SongCategory {
        get {
            let realm = try! Realm()
            return getLocalCategoryWithCategoryName(self.rawValue, inRealm: realm)!
        }
    }
}

// MARK: - 全局属性

let AudioPlayerWillPlay = "AudioPlayerWillPlay"

let screenBounds = UIScreen.mainScreen().bounds







