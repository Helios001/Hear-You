//
//  HotMusicCell.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/2.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import AlamofireImage

class HotMusicCell: UICollectionViewCell {
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var element : Album? {
        
        didSet {
            
            if let element = element {
                
                titleLabel.text = element.name
                
                if let picURL = NSURL(string: element.picUrl) {
                    let filter = AspectScaledToFillSizeFilter(size: pic.frame.size)
                    pic.af_setImageWithURL(picURL, filter: filter)
                }
            }
        }
    }
}
