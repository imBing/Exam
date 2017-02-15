//
//  SetPasswordController.swift
//  loginSwift
//
//  Created by Vin on 16/11/15.
//  Copyright © 2016年 daimler. All rights reserved.
//

import UIKit

class SetPasswordController: DMLBaseViewController, UITextFieldDelegate {
    // 邮箱
    var email: String?
    // 验证码
    var verCode: String?
    // 密码是否可见
    fileprivate var isSecure: Bool = true
    
    @IBOutlet weak var setPwdView: UIView!

    @IBOutlet weak var passwordImageView: UIImageView!
    
    @IBOutlet weak var setPwdTextField: UITextField!
    @IBOutlet weak var seePwdBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setPwdTextField.delegate = self
        self.seePwdBtn.setBackgroundImage(UIImage(named: "look_icon_unselected"), for: .normal)
        self.nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setPwdTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let textLength = textField.text?.lengthOfBytes(using: .utf8) ?? 0
            let replaceStrLength = string.lengthOfBytes(using: .utf8)
            let rangeLength = range.length
            let finalLength = textLength + replaceStrLength - rangeLength
            if finalLength <= 20 || replaceStrLength == 0 {
                return true
            }
            return false
    }
    
    @IBAction func seePwdBtnClick() {
        if isSecure {
            self.seePwdBtn.setBackgroundImage(UIImage(named: "look_icon_selected"), for: .normal)
            isSecure = false
            setPwdTextField.isSecureTextEntry = false
        }else {
            self.seePwdBtn.setBackgroundImage(UIImage(named: "look_icon_unselected"), for: .normal)
            isSecure = true
            setPwdTextField.isSecureTextEntry = true
        }
    }

    @IBAction func nextButtonClick() {
        if (setPwdTextField.text?.isEmpty)! {
            
            setPwdTextField.resignFirstResponder()

            showToastMessage("Please enter the password")
            return
        }
        
        if DMLTool.validatePassword(vStr: setPwdTextField.text ?? "") {
            guard let verCode = verCode else {
                self.showToastMessage("verCode can not be empty!")
                return
            }
            if let tempPwd = setPwdTextField.text, let tempEmail = email {
                setPassword(password: tempPwd,email: tempEmail,verCode: verCode)
            }
        }else {
            self.showToastMessage("Between 6-20 characters, include letters and numbers")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextButtonClick()
        return true
    }
    

}

fileprivate extension SetPasswordController {
    // 设置主界面
    func setupUI() {
        nextButton.layer.cornerRadius = 20.s
        nextButton.layer.masksToBounds = true
        prepareNav()
        // 控件约束适配
        bgView.adaptAllViewsToSPH()
    }
    
    // 设置导航栏
    func prepareNav() {
        navigationBar.resetTitle("Set Password")
    }
}

extension SetPasswordController {
    func setPassword(password: String, email: String, verCode: String) {
        
        if DMLTool .ValidateText(validatedType: .PhoneNumber, validateString:setPwdTextField.text! ){
        
        }

        let urlServer = ONE_AUTH_API_USER
        var params = [String: String]()
        params["email"] = email
        params["validation_code"] = verCode
        params["password"] = password
        
        self.showUploading()
        DMLRequestPutService(urlServer, params) { (response) in
            self.clearAllLoadingAndTips()
            response.sucess { [unowned self] in
                UserDefaults.standard.set(response.dic["access_token"]! as! String, forKey: userTokenKey)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: HOME_LIST_REFRESH), object: "login")
                let vc = BasicInfoViewController()
                vc.basicType = EntryBasicInfoType.setPassword_Type
                self.navigationController?.pushViewController(vc, animated: true)
                            }
            response.failure { [unowned self] in
                if let message = response.dic["message"] {
                    self.showToastMessage(message as! String)
                }else {
                    self.showToastMessage(response.errorMessage)
                }
            }
        }
        
    }
}








