//
//  PlayerManager.swift
//  Hear You
//
//  Created by 董亚珣 on 16/4/15.
//  Copyright © 2016年 snow. All rights reserved.
//

import AVFoundation

class PlayerManager : NSObject {
    
    static let sharedManager = PlayerManager()
    
    class func getRandomListWithCategory(category: SongCategory!) -> [Song] {
        
        return category.songs.sort{ (_, _) -> Bool in
            arc4random() < arc4random()
        }
    }
    
}
