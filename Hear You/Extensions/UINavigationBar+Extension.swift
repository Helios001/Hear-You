//
//  UINavigationController+Extension.swift
//  Hear You
//
//  Created by 董亚珣 on 16/6/7.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit
import ObjectiveC.runtime

private var alphaViewKey: UInt = 0
//var alphaViewKey : Character

extension UINavigationBar {
    
    var alphaView : UIView {
        
        get {
            
            if let view = objc_getAssociatedObject(self, &alphaViewKey) as? UIView {
                return view
            } else {
                let view = UIView.init(frame: CGRectMake(0, -20, screenBounds.width, 64))
                setBackgroundImage(UIImage(), forBarMetrics: .Default)
                subviews[0].alpha = 0
//                insertSubview(view, atIndex: 0)
                return view
            }
        }
        
        set {
            objc_setAssociatedObject(self, &alphaViewKey, alphaView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setNavigationBarAlpha(alpha: CGFloat) {
        
//        if alphaView == nil {
//            setBackgroundImage(UIImage(), forBarMetrics: .Default)
//            alphaView = UIView.init(frame: CGRectMake(0, -20, screenBounds.width, 64))
//            insertSubview(alphaView!, atIndex: 0)
//        }
        
        subviews[0].alpha = alpha
    }
    
}
