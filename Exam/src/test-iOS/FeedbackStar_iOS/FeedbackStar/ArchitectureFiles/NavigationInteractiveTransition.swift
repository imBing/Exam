//
//  NavigationInteractiveTransition.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/1.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class NavigationInteractiveTransition: NSObject, UINavigationControllerDelegate {
    weak var navigationVC: UINavigationController?
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    convenience init(nvc: UINavigationController?) {
        self.init()
        self.navigationVC = nvc
        self.navigationVC!.delegate = self
    }
    
    //我们把用户的每次Pan手势操作作为一次pop动画的执行
    func handleControllerPop(_ recognizer: UIPanGestureRecognizer) {
        //interactivePopTransition就是我们说的方法2返回的对象，我们需要更新它的进度来控制Pop动画的流程，我们用手指在视图中的位置与视图宽度比例作为它的进度。
        var progress = recognizer.translation(in: recognizer.view).x / recognizer.view!.bounds.size.width
        let PanSpeed = recognizer.velocity(in: recognizer.view).x
        
        //稳定进度区间，让它在0.0（未完成）～1.0（已完成）之间
        progress = min(1.0, max(0.0, progress))
        
        switch recognizer.state {
        case .began:
            if progress > 0.0 {
                //手势开始，新建一个监控对象
                self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
                //告诉控制器开始执行pop的动画
                let _ = self.navigationVC?.popViewController(animated: true)
            }
        case .changed:
            //更新手势的完成进度
            self.interactivePopTransition?.update(progress)
        case .ended, .cancelled:
            //手势结束时如果进度大于一半，那么就完成pop操作，否则重新来过
            if progress > 0.3 || PanSpeed > 500.0 {
//                self.interactivePopTransition?.completionSpeed = 0.7   ios10 上面有卡顿，先去掉
                self.interactivePopTransition?.finish()
            }else {
//                self.interactivePopTransition?.completionSpeed = 0.2
                self.interactivePopTransition?.cancel()
            }
            self.interactivePopTransition = nil;
        default: break
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //方法1中判断如果当前执行的是Pop操作，就返回我们自定义的Pop动画对象
        if operation == .pop {
            return PopAnimation()
        }else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //方法2会传给你当前的动画对象animationController，判断如果是我们自定义的Pop动画对象，那么就返回interactivePopTransition来监控动画完成度
        if animationController is PopAnimation {
            return self.interactivePopTransition
        }
        return nil
    }
}
