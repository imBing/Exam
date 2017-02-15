//
//  LoginController.swift
//  loginSwift
//
//  Created by Vin on 16/11/15.
//  Copyright © 2016年 daimler. All rights reserved.
//

import UIKit

let userTokenKey = "userToken"
let userM = "userMod"
var APP_IS_LOGIN: Bool {
    var isHaveToken = false
    if let _ = UserDefaults.standard.value(forKey: userTokenKey) {
        isHaveToken = true
    }
    return isHaveToken
}

class LoginController: DMLBaseViewController,UITextFieldDelegate {
    fileprivate var isSecure: Bool = true
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var seePwdBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        emailLabel.text = UserDefaults.standard.value(forKey: emailNameKey) as! String?
        self.seePwdBtn.setBackgroundImage(UIImage(named: "look_icon_unselected"), for: .normal)
        let email = UserDefaults.standard.value(forKey: emailNameKey) as! String?
        
        let emailheadStr = "   have been registered"
        let mutableString = NSMutableAttributedString(string:email! + emailheadStr)
        mutableString.addAttribute(NSFontAttributeName, value: GetFont(14.s), range: NSMakeRange(0, mutableString.length))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: HEXCOLOR3, range: NSMakeRange(0, (email?.lengthOfBytes(using: .utf8))!))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: HEXCOLOR6, range: NSMakeRange(mutableString.length - (emailheadStr.lengthOfBytes(using: .utf8)), (emailheadStr.lengthOfBytes(using: .utf8))))
        self.emailLabel.attributedText = mutableString
        self.nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        pwdTextField.delegate = self
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextButtonClick()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pwdTextField.resignFirstResponder()
    }
    
    @IBAction func seePwdBtnClick() {
        if isSecure {
            self.seePwdBtn.setBackgroundImage(UIImage(named: "look_icon_selected"), for: .normal)

            isSecure = false
            pwdTextField.isSecureTextEntry = false
        }else {
            self.seePwdBtn.setBackgroundImage(UIImage(named: "look_icon_unselected"), for: .normal)

            isSecure = true
            pwdTextField.isSecureTextEntry = true
        }

    }
    
    @IBAction func nextButtonClick() {
        pwdTextField.resignFirstResponder()
        if DMLTool.validatePassword(vStr: pwdTextField.text ?? "") {
            
        }else {
            self.showToastMessage("between 6-20 characters, include letters and numbers")
            return
        }
        
        login()
    }

    override func dismiss() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HOME_LIST_REFRESH), object: "login")
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension LoginController {
    func setupUI() {
        nextButton.layer.cornerRadius = 20.s
        nextButton.layer.masksToBounds = true
        
        prepareNav()
        view.adaptAllViewsToSPH()
    }
    
    func prepareNav() {
        navigationBar.resetUI("Password", self.navigationBar.leftItems, nil)
    }
}

fileprivate extension LoginController {
    func login() {
        let email =  UserDefaults.standard.value(forKey: emailNameKey) as! String?
        let str = "\(email!):\(pwdTextField.text!)"
        let utf8EncodeData = str.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        let Authorization = "Basic" + " " + base64String!
        let headparams = ["Authorization": Authorization]
        
        let urlServer = ONE_AUTH_API_ACCESS_TOKENS
        self.showUploading()
        
        //operationTest 3  solution & suggestion
        DMLRequestGetService(urlServer, headparams) { (response) in
            self.removeLoading()
            response.sucess { [unowned self] in
                UserDefaults.standard.set(response.dic["user_profile"]!, forKey: "userInfo")
                UserDefaults.standard.set(response.dic["access_token"]! as! String, forKey: userTokenKey)

                print(self.isSecure)
                
                //do something
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginSuccessNotification"), object: nil)
            }
            response.failure { [unowned self] in
                if let message = response.dic["message"] {
                    self.showToastMessage(message as! String)
                }else {
                    self.showToastMessage(response.errorMessage)
                }             }
        }
    }
}





