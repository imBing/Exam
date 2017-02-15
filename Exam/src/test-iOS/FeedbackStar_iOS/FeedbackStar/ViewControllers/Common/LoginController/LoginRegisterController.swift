//
//  LoginRegisterController.swift
//  loginSwift
//
//  Created by Vin on 16/11/15.
//  Copyright © 2016年 daimler. All rights reserved.
//

import UIKit
import AFNetworking

let emailNameKey = "emailName"
let passwordKey = "password"

//邮箱已注册
let ERROR_CODE_422: Int = 422
//验证码过期
let ERROR_CODE_401: Int = 401

class LoginRegisterController: DMLBaseViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonClick() {
        // 邮箱验证，跳转界面
        if  DMLTool.validateEmail(vStr: emailTextField.text ?? "") {
            emailTextField.resignFirstResponder()
            // 存储邮箱
            UserDefaults.standard.set(emailTextField.text, forKey: emailNameKey)
            postEmail()
        }else{
            showToastMessage("Please enter your daimler email.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let userName = UserDefaults.standard.value(forKey: emailNameKey) as? String {
            emailTextField.text = userName
        }
        self.nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        emailTextField.delegate =  self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWasShown(notification: Notification) {
        if UIDevice.current.is4Series {
            UIView.animate(withDuration: 0.25, animations: {
                self.bgView.originY = N_StatusBarHeight + N_NavBarHeight - 88.s
            })
        }
    }
    
    func keyboardWasHidden(notification: Notification) {
        if UIDevice.current.is4Series {
            UIView.animate(withDuration: 0.25, delay: 0.25, options: .allowUserInteraction, animations: {
                self.bgView.originY = N_StatusBarHeight + N_NavBarHeight
                }, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextButtonClick()
        return true
    }
}

// MARK: - 界面
fileprivate extension LoginRegisterController {
    // 设置界面控件
    func setupUI() {
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Enter your daimler email",attributes:[NSForegroundColorAttributeName: UIColor.white])
        
        // 替换emailTextField系统“清空”按钮
        let rightCancelBtn: UIButton = UIButton.init(type: .custom)
        rightCancelBtn.setImage(UIImage(named: "cancel_icon_2"), for: .normal)
        rightCancelBtn.frame = CGRect(0.0, 0.0, 14.5, 14.5)
        rightCancelBtn.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        emailTextField.rightView = rightCancelBtn
        emailTextField.rightViewMode = .whileEditing
        
        nextButton.layer.cornerRadius = 20.s
        nextButton.layer.masksToBounds = true
        prepareNav()
        // 控件约束适配
        bgView.adaptAllViewsToSPH()
    }
    
    // 清空邮箱输入框
    @objc func clearText() {
        emailTextField.text = ""
    }
    
    // 准备导航栏
    func prepareNav() {
        navigationBar.resetTitle("Sign Up/Login")
    }
    // 界面跳转
    func interfaceJump() {
        emailTextField.resignFirstResponder()
        perform(DelayTime: 0.01) {
            let registerCon = RegisterController()
            registerCon.email = self.emailTextField.text
            self.navigationController?.pushViewController(registerCon, animated: true)
        }
    }
}

// MARK: - 网络
fileprivate extension LoginRegisterController {
    func postEmail() {
        let urlServer = ONE_AUTH_API_USER
        let params = ["email":"\(emailTextField.text!)"]
        self.showUploading()
        
        //operationTest 2  solution & suggestion
        DMLRequestPostService(urlServer, params) { (response) in
            self.removeLoading()
            response.sucess {
                self.interfaceJump()
            }
            response.failure {
                if let message = response.dic["errorMessage"] {
                    if response.containsError(ERROR_CODE_422) {
                        self.pushVC(LoginController())
                    }else {
                        self.showToastMessage(message as! String)
                    }
                }else {
                    self.showToastMessage(response.errorMessage)
                }
            }
        }
    }
    
}




