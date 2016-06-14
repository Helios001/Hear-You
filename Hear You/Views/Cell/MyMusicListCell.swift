//
//  MyMusicListCell.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/7.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class MyMusicListCell: UITableViewCell {
    
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumDesc: UILabel!
    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 5
        backView.layer.shadowColor = UIColor.darkGrayColor().CGColor;
        backView.layer.shadowOffset = CGSizeMake(0, 0)
        backView.layer.shadowRadius = 4.0
        backView.layer.shadowOpacity = 0.5
        backView.layer.masksToBounds = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
