//
//  MusicCell.swift
//  Hear You
//
//  Created by 董亚珣 on 16/5/31.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
