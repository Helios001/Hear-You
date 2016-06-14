//
//  NewMusicCell.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/2.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import AlamofireImage

class NewMusicCell: UICollectionViewCell {
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    var element : Album? {
        
        didSet {
            
            if let element = element {
                
                songNameLabel.text = element.name
                singerNameLabel.text = element.desc
                
                if let picURL = NSURL(string: element.picUrl) {
                    let filter = AspectScaledToFillSizeFilter(size: pic.frame.size)
                    pic.af_setImageWithURL(picURL, filter: filter)
                }
            }
        }
    }
}
