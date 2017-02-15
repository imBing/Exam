//
//  DMLNavigationViewController.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/1.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class DMLNavigationViewController: UINavigationController, UIGestureRecognizerDelegate {
    var navT: NavigationInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
        
        let gesture = self.interactivePopGestureRecognizer
        gesture?.isEnabled = false
        
        let gestureView = gesture?.view

        let popRecognizer = UIPanGestureRecognizer()
        popRecognizer.delegate = self
        popRecognizer.maximumNumberOfTouches = 1
        gestureView?.addGestureRecognizer(popRecognizer)
        
        self.navT = NavigationInteractiveTransition(nvc: self)
        popRecognizer.addTarget(self.navT!, action: #selector(NavigationInteractiveTransition.handleControllerPop(_:)))
        
        UIApplication.shared.isStatusBarHidden = false
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let recognizer = gestureRecognizer as! UIPanGestureRecognizer
            let progress = recognizer.translation(in: recognizer.view).x / recognizer.view!.bounds.size.width
            if progress < 0 {
                return false
            }
        }
        
        let curVc = self.viewControllers.last
        if self.viewControllers.count > 1 && curVc != nil {
            let preVc = self.viewControllers[self.viewControllers.count - 2]
            preVc.view.addSubview(DMLPopCoverView.shareView())
            
            let view = curVc!.view
            
            let shadowPath = UIBezierPath.init(rect: (view?.bounds)!)
            view?.layer.masksToBounds = false
            view?.layer.shadowColor = UIColor.gray.cgColor
            view?.layer.shadowOffset = CGSize(width: -1.5, height: 0)
            view?.layer.shadowOpacity = 0.5
            view?.layer.shadowPath = shadowPath.cgPath
        }
        
        let isSpecialVc = false
        
        var isTransitioning = false
        if let isTran = self.value(forKey: "_isTransitioning") {
            isTransitioning = (isTran as AnyObject).boolValue
        }
        return self.viewControllers.count != 1 && !isTransitioning && !isSpecialVc;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
