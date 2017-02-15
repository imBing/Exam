//
//  DMLSettingController.swift
//  FeedbackStar
//
//  Created by Vin on 2016/12/16.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

fileprivate let LogoutCellId = "LogoutCellId"

class DMLSettingController: DMLBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.resetTitle("Settings")
        setupUI()
        tableView.register(UINib(nibName: "LogoutCell", bundle: nil), forCellReuseIdentifier: LogoutCellId)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogoutCellId, for: indexPath) as! LogoutCell
        if indexPath.section == 0 {  // 第一组
            if indexPath.row == 0 {  // 第一组第一行
              cell.name = "Edit Basic Info"
            }
        }else {                      // 第二组
            if indexPath.row == 0 {  // 第二组第一行
                cell.name = "Suggestions & Feedback"
            }else {
                cell.name = "About us"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let view = UIView(0, 0, DeviceWidth, 10.s, RGB(244, 244, 244))
            let lineView = UIView(0, 9.s, DeviceWidth, 1.s, RGB(221, 221, 221))
            view.addSubview(lineView)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
           return 10.s
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = BasicInfoViewController()
             vc.basicType  = EntryBasicInfoType.setting_Type
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1 && indexPath.row == 0 {
            
        }
        
    }
    
    func setupUI() {
        tableView.rowHeight = 50.s
        tableView.tableFooterView = logoutFooterView
    }
    
    lazy var logoutFooterView: UIView = {
        let view = UIView(0, 0, DeviceWidth, 110.s, RGB(244, 244, 244))
        let logoutBtn = UIButton()
        logoutBtn.setTitle("Log Out", for: .normal)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.s)
        logoutBtn.setTitleColor(WhiteColor, for: .normal)
        logoutBtn.setBackgroundImage(ImageWithColor(RGB(49, 187, 203)), for: .normal)
        logoutBtn.frame = CGRect(16.s, 70.s, 343.s, 40.s)
        logoutBtn.centerX = DeviceWidth * 0.5
        logoutBtn.layer.cornerRadius = 20.s
        logoutBtn.layer.masksToBounds = true
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick), for: .touchUpInside)
        view.addSubview(logoutBtn)
        return view
    }()
    
    func logoutBtnClick() {
        APPManager.logOut()
    }
    
    
}
