//
//  BasicInfoViewController.swift
//  FeedbackStar
//
//  Created by ya Liu on 2016/12/9.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

import AFNetworking

enum EntryBasicInfoType: Int {
    case setPassword_Type
    case setting_Type
    
}

class BasicInfoViewController: DMLBaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    let email = UserDefaults.standard.value(forKey: emailNameKey)
    
    var picUrl:String?
    
    var basicType:EntryBasicInfoType?
    //判断是从设置密码进入  还是从setting 进入
    var isSetting: Bool = true
    //MARK--submit
    
    @IBAction func submitAction(_ sender: AnyObject) {
        
        self.countryTextfield .resignFirstResponder()
        self.FirstNameTextField .resignFirstResponder()
        self.LastNameTextField.resignFirstResponder()
        self.departmentTextField .resignFirstResponder()
        
        
        if (self.FirstNameTextField.text?.isEmpty)!{
            showToastMessage("Please enter First Name")
            return
        }
        
        if (self.LastNameTextField.text?.isEmpty)!{
            
            showToastMessage("Please enter Last Name")
            return
        }
        
        if (self.countryTextfield.text?.isEmpty)! {
            showToastMessage("Please enter Country")
            return
        }
        
        if (departmentTextField.text?.isEmpty)! {
            showToastMessage("Please enter Department")
            return
        }
        
        var params = ["email": "\(email ?? "")",
            "first_name": "\(self.FirstNameTextField.text!)",
            "last_name":"\(self.LastNameTextField.text!)",
            "department": "\(self.departmentTextField.text!)",
            "country":"\(self.countryTextfield.text!)"] as [String : Any]
        
        if let url = self.picUrl {
            params["avatar"] = url
        }
        
        self.showUploading()
        DMLRequestPutService(ONE_AUTH_API_PROFILE, params) { (response) in
            self.clearAllLoadingAndTips()
            response.sucess { [unowned self] in
                UserDefaults.standard.set(response.dic, forKey: "userInfo")
                UserDefaults.standard.set(response.dic["access_token"]! as! String, forKey: userTokenKey)
                UserDefaults.standard .synchronize()
                
                let alertVc = UIAlertController(title: "Congratulations!", message: "register test finished,let's login~", preferredStyle: .alert)
                let action = UIAlertAction(title: "I got it!", style: .cancel, handler: { action in
                    self.dismiss()
                    
                    let vc = DMLNavigationViewController(rootViewController: LoginRegisterController())
                    AppDelegate.rootViewController.present(vc, animated: true, completion: nil)
                    
                })
                alertVc.addAction(action)
                APPManager.getCurrentActiveVC().present(alertVc, animated: true, completion: nil)
            }
            response.failure { [unowned self] in
                self.showToastMessage(response.errorMessage)
                print(response.error as Any)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageview.layer.cornerRadius = 25.s
        self.imageview.layer.masksToBounds = true
        self.view.bringSubview(toFront: self.navigationBar)
        prepareNav()
        createUI()
        self.submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
    }
    
    // 设置导航栏
    func prepareNav() {
        if self.basicType == EntryBasicInfoType.setting_Type{
            navigationBar.resetTitle("Edit Basic Info")
        }else{
            navigationBar.resetTitle("Add Basic Info")
        }
    }
    func createUI() {
        self.countryTextfield.delegate = self;
        self.departmentTextField.delegate = self
        self.FirstNameTextField.delegate = self;
        self.LastNameTextField.delegate = self;
        self.countryTextfield.autocapitalizationType = UITextAutocapitalizationType.words
        self.departmentTextField.autocapitalizationType = UITextAutocapitalizationType.words
        self.FirstNameTextField.autocapitalizationType = UITextAutocapitalizationType.words
        self.LastNameTextField.autocapitalizationType = UITextAutocapitalizationType.words
        
        if self.basicType == EntryBasicInfoType.setting_Type{
            if let dict = UserDefaults.standard.value(forKey: "userInfo") {
                let model = UserProfile(dic: dict as! NSDictionary )
                imageview.setImageWithUrlStr(model?.avatar ?? "", "rectangle_icon")
                FirstNameTextField.text = model?.firstName
                LastNameTextField.text = model?.lastName
                countryTextfield.text = model?.country
                departmentTextField.text = model?.department
            }
            
            FirstNameTextField.textAlignment = .right
            LastNameTextField.textAlignment = .right
            countryTextfield.textAlignment = .right
            departmentTextField.textAlignment = .right
            
        }else{
            FirstNameTextField.text = ""
            LastNameTextField.text = ""
            countryTextfield.text = ""
            departmentTextField.text = ""
        }
        
        self.view.backgroundColor = HEXCOLORF4
        self.submitButton.layer.cornerRadius = 20.s
        self.submitButton.layer.masksToBounds = true
        // 控件约束适配
        bgView.adaptAllViewsToSPH()
        
    }
    
    @IBAction func updateIconAction(_ sender: AnyObject) {
        var alert: UIAlertController!
        alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cleanAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler:nil)
        let photoAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.camera()
        }
        let choseAction = UIAlertAction(title: "Choose from Photos", style: UIAlertActionStyle.default){ (action:UIAlertAction)in
            self.photo()
        }
        alert.addAction(cleanAction)
        alert.addAction(photoAction)
        alert.addAction(choseAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //调用照相机方法
    func camera(){
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            let sourceTypes = UIImagePickerController.availableMediaTypes(for: picker.sourceType)
            if let sourceTypes = sourceTypes, sourceTypes.contains(kUTTypeImage as String) {
                picker.mediaTypes = [kUTTypeImage as String]
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }
        }else {
            self.showToastMessage("No device support!")
        }
        
    }
    //调用照片方法
    func photo(){
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    //MARK:- UIImagePickerControllerDelegate
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]){
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type=="public.image"
        {
            let img = info[UIImagePickerControllerEditedImage]as?UIImage
            let image = img?.transformtoSize(CGSize(width:324,height:324))
            //先把图片转化成nsdata
            let imgData = UIImageJPEGRepresentation(image!,1.0)
            //home 目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents"
            //文件管理器
            let fileManager:FileManager = FileManager.default
            let time = "\(NSDate().timeIntervalSince1970)"
            let imageName = self.email as! String + time
            let imageName_md5 = imageName.MD5
            let fileName = imageName_md5 + ".jpg"
            
            
            fileManager.createFile(atPath: documentPath + "/" + fileName, contents: imgData, attributes: nil)
            
            //            let filePath: String = String(format: "%@%@", documentPath, "/" + fileName)
            //            print("filePath:" + filePath)
            
            self.showUploading()
            let manager = AFHTTPSessionManager()
            manager.securityPolicy =  AFSecurityPolicy(pinningMode: .none)
            manager.requestSerializer = AFJSONRequestSerializer()
            //            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            manager.responseSerializer = AFJSONResponseSerializer()
            if manager.requestSerializer.value(forHTTPHeaderField: "Authorization") == nil {
                if let token = UserDefaults.standard.value(forKey: userTokenKey), let email = UserDefaults.standard.value(forKey: emailNameKey) {
                    let tokenStr = "\(email)" + ":" + "\(token)"
                    let utf8EncodeData = tokenStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
                    // 将NSData进行Base64编码
                    let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
                    let Authorization = "Basic" + " " + base64String!
                    manager.requestSerializer.setValue(Authorization, forHTTPHeaderField: "Authorization")
                }
            }
            manager.post(UPLOAD_IMAGE, parameters: nil, constructingBodyWith: { (formData) in
                formData.appendPart(withFileData: imgData!, name: "file", fileName: fileName, mimeType: "image/png")
                }, progress: nil, success: { (task, response) in
                    self.clearAllLoadingAndTips()
                    print("上传成功 \(response!)")
                    var dic: NSDictionary = NSDictionary()
                    dic = response as! NSDictionary
                    self.picUrl = dic.object(forKey: "url") as! String?
                    self.removeLoading()
                }, failure: { (task, error) in
                    self.clearAllLoadingAndTips()
                    self.showToastMessage("upload image error!")
            })
            imageview.image = image
            picker.dismiss(animated:true, completion:nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController){
        picker.dismiss(animated:true, completion:nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.departmentTextField .resignFirstResponder()
        self.FirstNameTextField .resignFirstResponder()
        self.LastNameTextField.resignFirstResponder()
        self.countryTextfield.resignFirstResponder()
        let standardY = N_StatusBarHeight + N_NavBarHeight
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .allowUserInteraction, animations: {
            self.bgView.setTopConstraint(constant: standardY)
            }, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if UIDevice.current.is4Series {
            let standardY = N_StatusBarHeight + N_NavBarHeight
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .allowUserInteraction, animations: {
                if textField == self.FirstNameTextField {
                    self.bgView.setTopConstraint(constant: standardY - 48.s)
                }else if textField == self.LastNameTextField {
                    self.bgView.setTopConstraint(constant: standardY - 48.s * 2)
                }else if textField == self.countryTextfield {
                    self.bgView.setTopConstraint(constant: standardY - 48.s * 3)
                }else if textField == self.departmentTextField {
                    self.bgView.setTopConstraint(constant: standardY - 48.s * 4)
                }
                }, completion: nil)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if ((textField.text?.lengthOfBytes(using: .utf8)) != nil) {
            textField.textAlignment = .right
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.departmentTextField .resignFirstResponder()
        self.FirstNameTextField .resignFirstResponder()
        self.LastNameTextField.resignFirstResponder()
        self.countryTextfield.resignFirstResponder()
        let standardY = N_StatusBarHeight + N_NavBarHeight
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .allowUserInteraction, animations: {
            self.bgView.setTopConstraint(constant: standardY)
            }, completion: nil)
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = textField.text?.lengthOfBytes(using: .utf8) ?? 0
        let replaceStrLength = string.lengthOfBytes(using: .utf8)
        let rangeLength = range.length
        let finalLength = textLength + replaceStrLength - rangeLength
        if finalLength <= 40 || replaceStrLength == 0 {
            return true
        }
        return false
    }
}
