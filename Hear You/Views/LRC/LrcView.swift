//
//  LrcView.swift
//  Hear You
//
//  Created by 董亚珣 on 16/5/6.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class LrcView: UIView {
    
    var lyric : String! {
        
        didSet {
            lrcLines.removeAll()
            
            if lyric.characters.count > 0 {
                
                let lrcs = lyric.componentsSeparatedByString("\n")
                for line in lrcs {
                    let lrcLine = LrcLine()
                    lrcLines.append(lrcLine)
                    
                    if !line.hasPrefix("[") {
                        continue
                    }
                    
                    if line.hasPrefix("[ti") || line.hasPrefix("[ar") || line.hasPrefix("[al") {
                        let words = line.componentsSeparatedByString(":").last!
                        if words.characters.count > 2 {
                            lrcLine.words = words.substringToIndex(words.endIndex.advancedBy(-2))
                        }
                    } else {
                        let arr = line.componentsSeparatedByString("]")
                        lrcLine.time = arr.first!.substringFromIndex(line.startIndex.advancedBy(1))
                        lrcLine.words = arr.last!
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    var currentTime : NSTimeInterval! {
        
        set {
            let min = Int(floor(newValue / 60))
            let sec = Int(floor(newValue % 60))
            let msec = Int((newValue - floor(newValue)) * 100)
            
            let currentTimeStr = String(format: "%02d:%02d.%02d",min,sec,msec)
//            println(currentTimeStr)
            
            if lrcLines.count > 0 {
                
                for idx in 0..<lrcLines.count-1 {
                    
                    let lrcline = lrcLines[idx]
                    let nextLine = lrcLines[idx + 1]
                    
                    if let lineTime = lrcline.time, let nextLineTime = nextLine.time {
                        if currentTimeStr.compare(lineTime) != .OrderedAscending && currentTimeStr.compare(nextLineTime) == .OrderedAscending && currentIndex != idx{
                            
                            let p = NSIndexPath(forRow: idx, inSection: 0)
                            
                            
                            self.tableView.scrollToRowAtIndexPath(p, atScrollPosition: .Top, animated: true)
                            let cell = self.tableView.cellForRowAtIndexPath(p)
                            cell?.textLabel!.textColor = UIColor.defaultRedColor()
                            self.currentIndex = idx
                        }
                    }
                }
            }
        }
        
        get {
            return self.currentTime
        }
    }
    
    private var tableView : UITableView!
    private var lrcLines : [LrcLine]!
    private var currentIndex : Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lrcLines = [LrcLine]()
        tableView = UITableView(frame: frame, style: .Plain)
        tableView.rowHeight = frame.height / 6
        tableView.backgroundColor = UIColor.clearColor()
        tableView.userInteractionEnabled = false
        tableView.separatorStyle = .None
        tableView.dataSource = self
        addSubview(tableView)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "LrcCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        tableView.frame = bounds
        tableView.contentInset = UIEdgeInsetsMake(tableView.frame.height * 0.5, 0, tableView.frame.height * 0.5, 0)
    }
}

extension LrcView : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lrcLines.count == 0 ? 1 : lrcLines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LrcCell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        cell.textLabel?.textAlignment = .Center
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        
        if lrcLines.count == 0 {
            cell.textLabel?.text = "暂无歌词"
            return cell
        }
        
        let line = lrcLines[indexPath.row]
        cell.textLabel?.text = line.words
        
        return cell
    }
    
}
