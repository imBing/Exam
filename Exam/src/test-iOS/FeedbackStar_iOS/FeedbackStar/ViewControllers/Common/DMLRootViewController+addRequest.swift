//
//  DMLRootViewController+addRequest.swift
//  FeedbackStar
//
//  Created by James Xu on 16/11/8.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

let addFeedbackPopView = AddFeedbackView(frame: CGRect(0, 0, DeviceWidth, DeviceHeight))
extension DMLRootViewController {
    func addRequest() {
        addFeedbackPopView.moduleClickClouser = { index in
            //do something
        }
        addFeedbackPopView.cancleClickClouser = { [unowned self] in
            self.press()
        }
        
        if addFeedbackPopView.isPop {
            press()
        }else {
            pop()
        }
    }
    
    // 弹出控制器
    func pop() {
        // “弹出”状态
        addFeedbackPopView.presentOut()
        self.view.addSubview(addFeedbackPopView)
        self.view.bringSubview(toFront: self.tabBarView!)
        
        self.tabBarView?.updateTabBtnColor(isAddSelected: true)
    }
    
    // 收回控制器
    func press() {
        // ”收回“状态
        addFeedbackPopView.disMiss()
        self.tabBarView?.updateTabBtnColor(isAddSelected: false)
    }
    
}
