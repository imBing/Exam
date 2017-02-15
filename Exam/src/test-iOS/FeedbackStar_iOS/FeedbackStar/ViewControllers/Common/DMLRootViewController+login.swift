//
//  DMLRootViewController+login.swift
//  FeedbackStar
//
//  Created by James Xu on 16/12/7.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

extension DMLRootViewController {
    func checkLogin() {
//        if let _ = UserDefaults.standard.value(forKey: userTokenKey) {
//            return
//        }
        
        let vc = DMLNavigationViewController(rootViewController: LoginRegisterController())
        APPManager.getCurrentActiveVC().present(vc, animated: true, completion: nil)
    }
}
