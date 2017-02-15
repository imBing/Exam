//
//  DMLUserViewController.swift
//  SwiftApp
//
//  Created by James Xu on 16/9/5.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class DMLUserViewController: DMLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.resetUI("Me", self.navigationBar.leftItems, [NavItem("Settings") {
            self.gotoSettings()
            }])
    }
    
    func gotoSettings() {
        pushVC(DMLSettingController())
        
    }
}




