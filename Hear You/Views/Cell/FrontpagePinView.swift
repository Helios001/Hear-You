//
//  FrontpagePinView.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/2.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class FrontpagePinView: UICollectionReusableView {
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thiredImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var fifthImage: UIImageView!
    
    var index : Int? {
        
        didSet {
            
            if let index = index {
                
                switch index {
                case 1:
                    firstImage.image = UIImage(named: "firstItem")
                    secondImage.image = UIImage(named: "secondItem_disable")
                    thiredImage.image = UIImage(named: "thirdItem_disable")
                    fourthImage.image = UIImage(named: "fouthItem_disable")
                    fifthImage.image = UIImage(named: "fifthItem_disable")
                case 2:
                    firstImage.image = UIImage(named: "firstItem_disable")
                    secondImage.image = UIImage(named: "secondItem")
                    thiredImage.image = UIImage(named: "thirdItem_disable")
                    fourthImage.image = UIImage(named: "fouthItem_disable")
                    fifthImage.image = UIImage(named: "fifthItem_disable")
                case 3:
                    firstImage.image = UIImage(named: "firstItem_disable")
                    secondImage.image = UIImage(named: "secondItem_disable")
                    thiredImage.image = UIImage(named: "thirdItem")
                    fourthImage.image = UIImage(named: "fouthItem_disable")
                    fifthImage.image = UIImage(named: "fifthItem_disable")
                case 4:
                    firstImage.image = UIImage(named: "firstItem_disable")
                    secondImage.image = UIImage(named: "secondItem_disable")
                    thiredImage.image = UIImage(named: "thirdItem_disable")
                    fourthImage.image = UIImage(named: "fouthItem")
                    fifthImage.image = UIImage(named: "fifthItem_disable")
                default:
                    firstImage.image = UIImage(named: "firstItem_disable")
                    secondImage.image = UIImage(named: "secondItem_disable")
                    thiredImage.image = UIImage(named: "thirdItem_disable")
                    fourthImage.image = UIImage(named: "fouthItem_disable")
                    fifthImage.image = UIImage(named: "fifthItem")
                }
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
