//
//  NSFileManager+Hello.swift
//  Hello
//
//  Created by 董亚珣 on 16/3/29.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

extension NSFileManager {
    
    class func cachesURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
    
    class func documentURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    }
    
    //MARK: SingerIcon
    
    class func singerIconDocumentURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let iconURL = documentURL().URLByAppendingPathComponent("singerIcon_document",isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(iconURL, withIntermediateDirectories: true, attributes: nil)
            return iconURL
        } catch _ {}
        
        return nil
    }
    
    class func singerIconURLWithName(name: String) -> NSURL? {
        
        if let iconURL = singerIconDocumentURL() {
//            return iconURL.URLByAppendingPathComponent("\(name).\(FileExtension.JPEG.rawValue)")
            return iconURL.URLByAppendingPathComponent("\(name).jpg")
        }
        
        return nil
    }
    
    class func saveSingerIcon(singerIcon: UIImage, withName name: String) -> NSURL? {
        
        if let iconURL = singerIconURLWithName(name) {
            let imageData = UIImageJPEGRepresentation(singerIcon, 0.8)
            if NSFileManager.defaultManager().createFileAtPath(iconURL.path!, contents: imageData, attributes: nil) {
                return iconURL
            }
        }
        
        return nil
    }
    
    class func removeSingerIconWithName(name: String) {
        
        if name.isEmpty {
            return
        }
        
        if let iconURL = singerIconURLWithName(name) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(iconURL)
            } catch _ {}
        }
    }
    
    //MARK: Song
    
    class func songDocumentURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let songDocumentURL = documentURL().URLByAppendingPathComponent("song_document", isDirectory: true)
        
        do {
            try fileManager.createDirectoryAtURL(songDocumentURL, withIntermediateDirectories: true, attributes: nil)
            return songDocumentURL
        } catch _ {
        }
        
        return nil
    }
    
    class func songURLWithName(name: String, andExtension fileExtension: String) -> NSURL? {
        
        if let songDocumentURL = songDocumentURL() {
            return songDocumentURL.URLByAppendingPathComponent("\(name).\(fileExtension)")
        }
        
        return nil
    }
    
    class func saveSongData(songData: NSData, withName name: String, andExtension fileExtension: String) -> NSURL? {
        
        if let songURL = songURLWithName(name, andExtension: fileExtension) {
            if NSFileManager.defaultManager().createFileAtPath(songURL.path!, contents: songData, attributes: nil) {
                println(songURL)
                return songURL
            }
        }
        
        return nil
    }
    
    class func deleteSongFileWithName(name: String, andExtension fileExtension: String) {
        
        if name.isEmpty {
            return
        }
        
        if let songURL = songURLWithName(name, andExtension: fileExtension) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(songURL)
            } catch _ {}
        }
    }
}
