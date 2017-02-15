//
//  DMLRootViewController.swift
//  SwiftApp
//
//  Created by James Xu on 16/9/1.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class DMLRootViewController: UIViewController {
    var selectedIndex: Int = 0
    var tabBarView: DMLTabBar?
    var childVCArray: [UIViewController] = TabbarShareInstance.tabVCArr
    var currentVC: UIViewController {
        if self.selectedIndex < self.childVCArray.count {
            return self.childVCArray[self.selectedIndex]
        }
        if self.childVCArray.count > 0 {
            return self.childVCArray[0]
        }else {
            return UIViewController()

    }
    }
    
    var currentView: UIView {
        return self.currentVC.view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initViewControllers
        self.initChildVC()
        //initTabBar
        self.initTabBar()
        //changeTabbarIndex
        self.tabBarView?.refreshTabbar(0)
    }
    
    func initChildVC() {
        self.addChildViewController(self.currentVC)
        self.view.addSubview(self.currentView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkLogin()
    }
    
    func initTabBar() {
        self.tabBarView = DMLTabBar(rootViewController: self) { (selectIndex) in
            self.tabSelectedAtIndex(selectIndex)
        }
        self.tabBarView?.tabAddSelectClosure = {
            self.addRequest()
        }
    }
    
    func tabSelectedAtIndex(_ tabIndex: Int) {
        self.popToRootViewController()
        self.replaceControllerWithIndex(tabIndex)
        self.press()
    }
    
    func setTabbarUserInteractionEnabled(_ isUserInteractionEnabled: Bool) {
        self.tabBarView?.isUserInteractionEnabled = isUserInteractionEnabled
        self.tabBarView?.tabAddBtn?.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    func popToRootViewController() {
        let _ = self.navigationController?.popToRootViewController(animated: false)
    }
    
    func replaceControllerWithIndex(_ tabIndex: Int) {
        let oldController = self.currentVC
        let newController = self.getVCAtIndex(tabIndex)
        if tabIndex < self.childVCArray.count {
            self.selectedIndex = tabIndex
        }
        self.replaceController(oldController, newViewContoller: newController)
    }
    
    func getVCAtIndex(_ index: Int) -> UIViewController{
        if index < self.childVCArray.count {
            return self.childVCArray[index]
        }else {
            if self.childVCArray.count > 0 {
                return self.currentVC
            }
        }
        return UIViewController()
    }
    
    func replaceController(_ oldViewController: UIViewController, newViewContoller: UIViewController) {
        newViewContoller.view.frame = self.view.frame
        if newViewContoller === oldViewController {
            return
        }
        self.addChildViewController(newViewContoller)
        self.transition(from: oldViewController, to: newViewContoller, duration: 0.01, options: .allowUserInteraction, animations: {
            if let t = self.tabBarView {
                self.view.bringSubview(toFront: t)
            }
            }) { (finished) in
                if finished {
                    newViewContoller.didMove(toParentViewController: self)
                    oldViewController.willMove(toParentViewController: nil)
                    oldViewController.removeFromParentViewController()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //statusBar isHidden
    override var prefersStatusBarHidden: Bool {
        return false
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
