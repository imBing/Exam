//
//  DMLAppDelegate.swift
//  FeedbackStar
//
//  Created by James Xu on 16/8/24.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit
import Kingfisher

let AppDelegate: DMLAppDelegate = UIApplication.shared.delegate as! DMLAppDelegate

@UIApplicationMain
class DMLAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let navigationController = DMLNavigationViewController(rootViewController: DMLRootViewController())
    
    var rootViewController: DMLRootViewController {
        return (self.navigationController.viewControllers.first as? DMLRootViewController)!
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //config tabVC
        self.setRootViewController()
        return true
    }
        
    private func setRootViewController() {
        self.window?.rootViewController = self.navigationController
    }
    
    func removeSendFeedbackView() {
        APPManager.getRootViewController().press()
    }

    func logOut() {
        let url = ONE_AUTH_API_ACCESS_TOKENS_LOGOUT
        DMLRequestDeleteService(url){ (response) in
            response.sucess {
                print("logout successful")
            }
            response.failure {
                print(response.description)
            }
        }
        
        APPManager.setTabSelectedAtIndex(0)
        UserDefaults.standard.removeObject(forKey: userTokenKey)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogOutNotification), object: nil)
        let rootVC = APPManager.getRootViewController()
        rootVC.checkLogin()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.removeSendFeedbackView()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
