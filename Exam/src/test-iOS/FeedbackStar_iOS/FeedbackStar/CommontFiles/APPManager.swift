//
//  APPManager.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/9.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class APPManager: NSObject {
    class func getRootViewController() -> DMLRootViewController {
        return AppDelegate.rootViewController
    }
    
    class func getCurrentActiveVC() -> UIViewController {
        var result: UIViewController?
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin
                    break
                }
            }
        }
        let frontView = window?.subviews.last
        let nextResponser = frontView?.next
        if nextResponser is UIViewController {
            result = nextResponser as? UIViewController
        }else {
            var lastPresentVC: UIViewController = AppDelegate.navigationController
            for _ in 0..<99999 {
                if lastPresentVC is UINavigationController {
                    let lastPresentNVC = lastPresentVC as! UINavigationController
                    if let presentVC = lastPresentNVC.viewControllers.last?.presentedViewController {
                        lastPresentVC = presentVC
                    }else {
                        result = lastPresentNVC.viewControllers.last
                        break
                    }
                }else {
                    if let presentVC = lastPresentVC.presentedViewController {
                        lastPresentVC = presentVC
                    }else {
                        result = lastPresentVC
                        break
                    }
                }
            }
        }
        if let result = result {
            return result
        }
        
//        if self.getCurrentActiveNVC() === AppDelegate.navigationController {
//            if AppDelegate.navigationController.viewControllers.count == 1 {
//                return self.getRootViewController().currentVC
//            }
//        }
        
        return self.getRootViewController().currentVC
    }
    
    class func getCurrentActiveNVC() -> UINavigationController {
        if self.getCurrentActiveVC() === AppDelegate.rootViewController.currentVC {
            return AppDelegate.navigationController
        }
        return self.getCurrentActiveVC().navigationController ?? AppDelegate.navigationController
    }
    
    class func getTabSelectedIndex() -> Int {
        return self.getRootViewController().selectedIndex
    }
    
    class func setTabSelectedAtIndex(_ index: Int) {
        self.getRootViewController().tabBarView?.refreshTabbar(index)
    }
    
    class func setMessageTabUnread(_ isUnread: Bool) {
        self.getRootViewController().tabBarView?.setTabShowRedDot(2, isUnread)
    }
    
    class func logOut() {
        AppDelegate.logOut()
    }
}
