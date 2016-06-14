//
//  MyMusicCell.swift
//  Hear You
//
//  Created by 董亚珣 on 16/5/27.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class MyMusicCell: UIView {

    var backImage: UIImageView!
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleWidth : CGFloat = frame.width - 40
        let titleHeight : CGFloat = 60
        
        backImage = UIImageView(frame:frame)
        backImage.backgroundColor = UIColor.clearColor()
        title = UILabel()
        title.frame = CGRectMake((frame.width - titleWidth) / 2, (frame.height - titleHeight) / 2, titleWidth, titleHeight)
        title.textAlignment = .Center
        title.font = UIFont.systemFontOfSize(35)
        
        addSubview(backImage)
        addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
