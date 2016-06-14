//
//  UIImage+Extension.swift
//  Hear You
//
//  Created by 董亚珣 on 16/4/11.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

extension UIImage {
    
    // 创建纯色的图片
    func imageWithGradientTintColor(tintColor: UIColor) -> UIImage {
        
        return imageWithTintColor(tintColor, blendMode: CGBlendMode.Overlay)
    }
    
    // 压缩图片
    func scaleToSize(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }

    private func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        
        tintColor.setFill()
        
        let bounds = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
        
        UIRectFill(bounds)
        
        self.drawInRect(bounds, blendMode: blendMode, alpha: 1)
        
        if blendMode != CGBlendMode.DestinationIn {
            self.drawInRect(bounds, blendMode: CGBlendMode.DestinationIn, alpha: 1)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}