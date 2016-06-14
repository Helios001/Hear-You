//
//  DMMaterialTransition.swift
//  DMMaterialTransition
//
//  Created by snow on 16/3/24.
//  Copyright © 2016年 snow. All rights reserved.
//

import UIKit

public class DMMaterialTransition: NSObject {
    
    
    public let animatedView : UIView
    
    var startFrame : CGRect!
    
    var startBackgroundColor : UIColor
    
    public var animatedType : AnimatedType = .PresentNormal
    
    public enum AnimatedType {
        
        case PresentLoading
        case PresentNormal
        case Dismiss
    }
    
    public init(animatedView: UIView) {
        
        assert(animatedView.superview != nil, "animatedView must be attached to a superview")
        
        self.animatedView = animatedView
        
        self.startBackgroundColor = animatedView.backgroundColor!
    }
}

extension DMMaterialTransition : UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let containerView = transitionContext.containerView() else {
            return
        }
        
        var cacheFrame = animatedView.frame
        
        switch (animatedType) {
            
        case .PresentLoading :
            
            cacheFrame.origin.x += (CGRectGetWidth(cacheFrame) - CGRectGetHeight(cacheFrame)) / 2
            cacheFrame.size.width = cacheFrame.size.height
        default :
            break
        }
        
        self.startFrame = animatedView.superview!.convertRect(cacheFrame, toView: nil)
        
        let startFrame = containerView.superview?.convertRect(self.startFrame, toView: containerView)
        
        let animatedViewForTransition : UIView = {
            
            let view = UIView(frame: startFrame!)
            
            containerView.addSubview(view)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = CGRectGetHeight(view.frame) / 2
            view.backgroundColor = startBackgroundColor
            
            return view
        }()
        
        let finalTransform : CGAffineTransform = {
            
            let size = max(CGRectGetHeight(containerView.frame), CGRectGetWidth(containerView.frame)) * 1.2
            
            let scaleFactor = size / CGRectGetWidth(animatedViewForTransition.frame)
            
            return CGAffineTransformMakeScale(scaleFactor, scaleFactor)
        }()
        
        switch animatedType {
        case .PresentLoading , .PresentNormal :
            
            if let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                
                presentedView.frame = containerView.bounds
                presentedView.layer.opacity = 0
                
                containerView.addSubview(presentedView)
                
                UIView.transitionWithView(animatedViewForTransition,
                    duration: self.transitionDuration(transitionContext) * 0.7,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { _ in
                        
                        animatedViewForTransition.transform = finalTransform
                        animatedViewForTransition.center = containerView.center
                        animatedViewForTransition.backgroundColor = presentedView.backgroundColor
                        
                    },
                    completion: nil)
                
                UIView.animateWithDuration(self.transitionDuration(transitionContext) * 0.42,
                    delay: self.transitionDuration(transitionContext) * 0.58,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { () -> Void in
                        
                        presentedView.layer.opacity = 1
                    },
                    completion: { (finished) -> Void in
                        
                        animatedViewForTransition.removeFromSuperview()
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }
        case .Dismiss :
            
            if let presentedView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
                
                presentedView.frame = containerView.bounds
                presentedView.layer.opacity = 0
                
                containerView.addSubview(presentedView)
                
                animatedViewForTransition.transform = finalTransform
                animatedViewForTransition.center = containerView.center
                animatedViewForTransition.backgroundColor = presentedView.backgroundColor
                
                UIView.animateWithDuration(self.transitionDuration(transitionContext) * 0.7,
                    animations: { () -> Void in
                        
                        presentedView.layer.opacity = 0
                    },
                    completion: nil)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC) * Int64(self.transitionDuration(transitionContext) * 0.32)), dispatch_get_main_queue(), { () -> Void in
                    
                    UIView.transitionWithView(animatedViewForTransition,
                        duration: self.transitionDuration(transitionContext) * 0.58,
                        options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: { () -> Void in
                            
                            animatedViewForTransition.transform = CGAffineTransformIdentity
                            animatedViewForTransition.backgroundColor = self.startBackgroundColor
                            animatedViewForTransition.frame = startFrame!
                        }, completion: { (finished) -> Void in
                            
                            animatedViewForTransition.removeFromSuperview()
                            
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    })
                })
            }
        }
    }
}
