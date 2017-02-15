//
//  PopAnimation.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/1.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var transitionContext: UIViewControllerContextTransitioning?
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //return animation duration
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //获取动画来自的那个控制器
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        //获取转场到的那个控制器
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        if let fromViewController = fromVC, let toViewController = toVC {
            //转场动画是两个控制器视图时间的动画，需要一个containerView来作为一个“舞台”，让动画执行
            let containerView = transitionContext.containerView
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            
            let duration = self.transitionDuration(using: transitionContext)
            //执行动画，让fromVC的视图移动到屏幕最右侧
            var frame = toViewController.view.frame
            frame.origin.x = -DeviceWidth / 3.0;
            toViewController.view.frame = frame;
            let popCoverView = DMLPopCoverView.shareView()
            
            UIView.animate(withDuration: duration, animations: { 
                fromViewController.view.transform = CGAffineTransform(translationX: DeviceWidth, y: 0)
                popCoverView.backgroundColor = UIColor.clear
                var frame = toViewController.view.frame
                frame.origin.x = 0
                toViewController.view.frame = frame
                
                }, completion: { (finished) in
                    self.animationDidStop(CAAnimation(), finished: true)
            })
        }
        
        self.transitionContext = transitionContext
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transition = self.transitionContext {
            transition.completeTransition(!(transition.transitionWasCancelled))
            DMLPopCoverView.setHidden()
        }
    }
}
