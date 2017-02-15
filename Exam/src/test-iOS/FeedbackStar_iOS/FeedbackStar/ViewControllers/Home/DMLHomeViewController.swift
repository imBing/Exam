//
//  DMLHomeViewController.swift
//  SwiftApp
//
//  Created by James Xu on 16/9/5.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

private var vcTestCount: Int = 1
let HOME_LIST_REFRESH = "home_list_refresh"

class DMLHomeViewController: DMLBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.resetTitle("Moments")
        NotificationCenter.default.addObserver(self, selector: #selector(self.addAlertView), name: NSNotification.Name(rawValue: "loginSuccessNotification"), object: nil)
        self.perform(DelayTime: 1) {
            self.drawView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.rootViewController.perform(DelayTime: 0.15, {

        if APPManager.getCurrentActiveVC() === self {
                let alertVc = UIAlertController(title: "Congratulations!", message: "Login test finished, So great~", preferredStyle: .alert)
                let action = UIAlertAction(title: "I got it!", style: .cancel, handler: { action in
                })
                alertVc.addAction(action)
                AppDelegate.rootViewController.present(alertVc, animated: true, completion: nil)
            }

        })
    }
    
    func drawView() {
        let successLabel = UILabel(0, 100.s, DeviceWidth, 50.s, "One Auth Passed!", HEXCOLOR3, 14.s)
        successLabel.textAlignment = .center
        self.mainView.addSubview(successLabel)
        
        let imageView = UIImageView(50.s, successLabel.maxY + 30.s, DeviceWidth - 100.s, 200.s, "headerBackImage1", UIViewContentMode.scaleAspectFit)
        self.mainView.addSubview(imageView)
    }
    
    func addAlertView() {
        let alertVc = UIAlertController(title: "Congratulations!", message: "Login test finished, So great~", preferredStyle: .alert)
        let action = UIAlertAction(title: "I got it!", style: .cancel, handler: { action in
        })
        alertVc.addAction(action)
        AppDelegate.rootViewController.present(alertVc, animated: true, completion: nil)
    }
}
