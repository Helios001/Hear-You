//
//  LoadingButton.swift
//  Hello
//
//  Created by 董亚珣 on 16/3/23.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    
    lazy var spiner: SpinerLayer! = {
        let spiner = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(spiner)
        return spiner
    }()
    
    private var cachedTitle: String?
    private var cachedFrame: CGRect!
    private var cachedRadius: CGFloat!
    
    func loading() {
    
        cachedTitle = titleForState(.Normal)
        cachedFrame = layer.frame
        cachedRadius = layer.cornerRadius
        
        enabled = false
        setTitle("", forState: .Normal)
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2
            
            }) { (finished) -> Void in
                
                self.shrink()
                
                NSTimer.schedule(delay: -0.15) { timer in
                    
                    self.spiner.animation()
                }
                
        }
    }
    
    func loadingSucceed() {
        
        NSTimer.schedule(delay: 1) { timer in
            
            self.spiner.stopAnimation()
            
            self.layer.removeAllAnimations()
            
            self.layer.cornerRadius = self.cachedRadius
            
            self.setTitle(self.cachedTitle, forState: .Normal)
            self.enabled = true
        }
    }
    
    func loadingFailed() {

        self.spiner.stopAnimation()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            self.layer.cornerRadius = self.cachedRadius
            
            }) { (finished) -> Void in
                
            self.shrinkBack()
        }
    }
    
    private func shrink() {
        
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = 0.1
        shrinkAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        
        layer.addAnimation(shrinkAnim, forKey: "shrink")
    }
    
    private func shrinkBack() {
        
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        
        shrinkAnim.fromValue = frame.height
        shrinkAnim.toValue = frame.width
        shrinkAnim.duration = 0.1
        shrinkAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.removedOnCompletion = false
        shrinkAnim.delegate = self
        
        layer.addAnimation(shrinkAnim, forKey: "shrinkBack")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        self.setTitle(self.cachedTitle, forState: .Normal)
        enabled = true
        
        self.layer.removeAllAnimations()
    }
}
