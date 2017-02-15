//
//  RegisterController.swift
//  loginSwift
//
//  Created by Vin on 16/11/15.
//  Copyright © 2016年 daimler. All rights reserved.
//

import UIKit

class RegisterController: DMLBaseViewController,UITextFieldDelegate {
    // 邮箱
    var email: String?
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var verCodeView: UIView!

    @IBOutlet weak var verCodeImageView: UIImageView!
    
    @IBOutlet weak var verCodeTextField: UITextField!
    @IBOutlet weak var verCodeBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    
    // MARK: - 按钮点击事件
    @IBAction func verCodeBtnClick() {
        // 启动倒计时
        isCounting = true
     
    }
    
    @IBAction func nextButtonClick() {
        verCodeTextField.resignFirstResponder()
        checkVerCode()
    }
    
    // MARK: - 计时器
    // 倒计时剩余秒数
    var remainingSeconds: Int = 0 {
        willSet {
            verCodeBtn.setTitle("\(newValue)s ", for: .normal)
            if newValue <= 0 {
                verCodeBtn.setTitle("Resend", for: .normal)
                isCounting = false
            }
        }
    }
    // 计时器
    var countdownTimer: Timer?
    // 计时器开关
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 59
                verCodeBtn.backgroundColor = UIColor.white
                self.postEmail()

            }else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                verCodeBtn.backgroundColor = UIColor.white
            }
            verCodeBtn.isEnabled = !newValue
        }
    }
    // 更新时间方法
    func updateTime() {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        verCodeTextField.delegate = self
        setupUI()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = textField.text?.lengthOfBytes(using: .utf8) ?? 0
        let replaceStrLength = string.lengthOfBytes(using: .utf8)
        let rangeLength = range.length
        let finalLength = textLength + replaceStrLength - rangeLength
        if finalLength <= 6 || replaceStrLength == 0 {
            return true
        }
        return false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        verCodeTextField.resignFirstResponder()
    }



}


fileprivate extension RegisterController {
    
    
    // 设置界面
    func setupUI() {
        // 设置导航栏title
        navigationBar.resetTitle("Confirmation Code")
        // 下一步按钮切圆
        nextButton.layer.cornerRadius = 20.s
        nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        // 验证码按钮处理
        verCodeBtn.layer.borderColor = UIColor(red: 236/255.0, green: 128/255.0, blue: 96/255.0, alpha: 1.0).cgColor
        verCodeBtn.layer.borderWidth = 1
        verCodeBtn.layer.cornerRadius = 7.s
        verCodeBtn.layer.masksToBounds = true
        
        
        let emailheadStr = "Your code has been sent to  "
        let mutableString = NSMutableAttributedString(string:emailheadStr + email!)
        mutableString.addAttribute(NSFontAttributeName, value: GetFont(14.s), range: NSMakeRange(0, mutableString.length))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: HEXCOLOR6, range: NSMakeRange(0, emailheadStr.lengthOfBytes(using: .utf8)))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: HEXCOLOR3, range: NSMakeRange(mutableString.length - (email?.lengthOfBytes(using: .utf8))!, (email?.lengthOfBytes(using: .utf8))!))
        self.emailLabel.attributedText = mutableString
        
    
        // 约束适配
        bgView.adaptAllViewsToSPH()
    }
    
    
    func postEmail() {
        // 服务器地址
        let urlServer = ONE_AUTH_API_USER
        let params = ["email": email!]
        DMLRequestPostService(urlServer, params) { (response) in
            response.sucess {
            }
            response.failure {
                if let message = response.dic["message"] {
                        self.showToastMessage(message as! String)
                }else {
                    self.showToastMessage(response.errorMessage)
                }
            }
        }
    }

}

// MARK: - 网络访问
fileprivate extension RegisterController {
    func checkVerCode() {
        guard let text = verCodeTextField.text, text.isValid else {
            showToastMessage("Code cannot be empty")
            return
        }
        
        let urlServer = ONE_AUTH_API_VALIDATION_CODE
        let params = ["email": self.email ?? "", "validation_code": verCodeTextField.text!]

        self.showUploading()
        
        //operationTest 1  solution & suggestion
        DMLRequestPutService(urlServer, params) { (response) in
            self.clearAllLoadingAndTips()
            response.sucess { [unowned self] in
                let setPwdCon = SetPasswordController()
                setPwdCon.email = self.email
//              setPwdCon.verCode = self.verCodeTextField.text
                self.navigationController?.pushViewController(setPwdCon, animated: true)
            }
            response.failure {
                if let message = response.dic["message"] {
                    self.showToastMessage(message as! String)
                }else {
                    self.showToastMessage(response.errorMessage)
                }
            }
        }
    }
    
}






