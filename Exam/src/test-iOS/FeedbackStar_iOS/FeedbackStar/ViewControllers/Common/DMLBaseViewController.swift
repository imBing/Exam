//
//  DMLBaseViewController.swift
//  SwiftApp
//
//  Created by James Xu on 16/9/5.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class DMLBaseViewController: UIViewController {
    var mainView: BaseMainView = BaseMainView()
    lazy var navigationBar: DMLNavigationBar = {
        return DMLNavigationBar()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotifications()
        self.setParameters()
        self.createNavigationBar()
        self.configMainView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recoverLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.resignFirstResponder()
        SVProgressHUD.dismiss()
    }
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.recoverLoading), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.logOutRefresh), name: NSNotification.Name(rawValue: LogOutNotification), object: nil)
    }
    
    func setParameters() {
        self.view.backgroundColor = HEXCOLORE
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    func configMainView() {
        let originY = N_StatusBarHeight + N_NavBarHeight
        self.mainView.frame = CGRect(0, originY, self.view.width, N_ContentHeight_Tab)
        self.mainView.backgroundColor = ClearColor
        self.view.addSubview(self.mainView)
        self.view.sendSubview(toBack: self.mainView)
        self.view.sendSubview(toBack: self.navigationBar)
    }
    
        
    func createNavigationBar() {
        self.navigationBar = DMLNavigationBar(defaultTitle: "Daimler")
        self.view.addSubview(self.navigationBar)
    }
    
    func setNavigationHidden(_ isHidden: Bool) {
        self.navigationBar.isHidden = isHidden
    }
    
    func setNavigation(_ title: String?, _ leftItems: [NavItem]?, _ rightItems: [NavItem]?) {
        self.navigationBar.resetUI(title, leftItems, rightItems)
    }
    
    func setNavigationCustomView(_ configCustomView: () -> UIView) {
        self.navigationBar.setNavigationCustomView {
            return configCustomView()
        }
    }
    
    func logOutRefresh() {
        //tabVC内重写此方法以处理logout后重登陆的显示问题
    }
    
    func pushVC(_ newViewController: UIViewController) {
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func pop() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentVC(_ newViewController: UIViewController) {
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    func showToastMessage(_ text: String) {
        SVProgressHUD.showText(text, duration: 1.0)
    }
    
    func showSuccessMessage(_ text: String) {
        SVProgressHUD.showSuccess(withStatus: text)
    }
    
    func removToast() {
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

//ErrorViewShow
private let RequestErrorViewTag: Int = 88088

extension DMLBaseViewController {
    func showErrorView(_ response: DMLResponse) {
        self.removeErrorView()
        let backView = UIView(frame: self.mainView.bounds)
        backView.tag = RequestErrorViewTag
        backView.backgroundColor = BACKGROUND_COLOR
        self.mainView.addSubview(backView)
        self.mainView.bringSubview(toFront: backView)
        
        var errorImage: UIImage?
        switch response.errorCode {
        case .dmlErrorCodeDefaultNone,
             .dmlRequestCancel:
            return
        case .dmlNetWorkDisConnectError,
             .dmlNetWorkTimeOutError:
            errorImage = UIImage(named: "network_error")
        default:
            errorImage = UIImage(named: "service_error")
        }
        
        guard let image = errorImage  else {
            return
        }
        
        let errorView = UIImageView(image: image)
        errorView.frame = CGRect(0, 0, SP(image.size.width), SP(image.size.height))
        errorView.center = CGPoint(DeviceWidth / 2.0, N_ContentHeight / 2.0 - SP(50))
        backView.addSubview(errorView)
        
        let reloadBtn = UIButton(type: .custom)
        reloadBtn.frame = CGRect(0, 0, 115, 34)
        reloadBtn.center = CGPoint(DeviceWidth / 2.0, errorView.maxY + 54)
        reloadBtn.setImage(UIImage(named: "reloading_unselected"), for: .normal)
        reloadBtn.setImage(UIImage(named: "reloading_selected"), for: .highlighted)
        reloadBtn.addTarget(self, action: #selector(self.errorReloadBtnClick), for: .touchUpInside)
        backView.addSubview(reloadBtn)
    }
    
    func removeErrorView() {
        if let view = self.mainView.viewWithTag(RequestErrorViewTag) {
            view.removeFromSuperview()
        }
    }
    
    func errorReloadBtnClick() {
        self.clearAllLoadingAndTips()
        self.mainView.isRemoveLoading = false
        self.reloadDataClick()
    }
    
    //rewrite this func to reconnect
    func reloadDataClick() {
        print("not rewrite func: reloadDataClick()")
    }
    
    func clearAllLoadingAndTips() {
        self.removeErrorView()
        self.removeLoading()
        self.removeEmptyView()
        self.removToast()
    }
}

//loading empty func
extension DMLBaseViewController {
    func addEmptyView(_ picImageStr: String, _ text: String) {
        self.mainView.addEmptyView(Point(DeviceWidth / 2.0, N_ContentHeight / 2.0 - SP(20)), picImageStr, text)
    }
    
    func removeEmptyView() {
        self.mainView.removeEmptyView()
    }
    
    func showUploading() {
        SVProgressHUD.show(withStatus: "sending...")
    }
    
    func recoverLoading() {
        self.mainView.recoverLoading()
    }
    
    func addLoading() {
        if !self.mainView.isRemoveLoading {
            self.mainView.addLoading(Point(DeviceWidth / 2.0 + SP(10), N_ContentHeight / 2.0 - SP(20)))
        }
    }
    
    func removeLoading() {
        self.mainView.removeLoadingAnimated(!self.mainView.isRemoveLoading)
        self.mainView.isRemoveLoading = true
        SVProgressHUD.dismiss()
    }
}

private let DMLEmptyViewTag = 99095
//empotyView

//define BaseMainView
class BaseMainView: UIView {
    var isRemoveLoading = false
    
    func addEmptyView(_ emptyViewCenter: CGPoint? = nil, _ picImageStr: String? = nil, _ text: String? = nil) {
        let emptyView = self.viewWithTag(DMLEmptyViewTag)
        guard emptyView == nil else {
            return
        }
        self.removeEmptyView()
        let emptyBackView = UIView.create(0, 0,SP(260), SP(100), ClearColor, self, DMLEmptyViewTag)
        
        var imageWidth: CGFloat = 0
        var imageHeight: CGFloat = 0
        if let picImageStr = picImageStr, let image = UIImage(named: picImageStr) {
            imageWidth = SP(image.size.width)
            imageHeight = SP(image.size.height)
            
            let _ = UIImageView.create((emptyBackView.width - imageWidth) / 2.0, 0, imageWidth, imageHeight, picImageStr, .scaleToFill, emptyBackView, 0)
        }

        let emptyTitleLabel = UILabel.create(0, imageHeight + SP(16), emptyBackView.width, SP(17), text, RGB(185, 185, 185), SP(14), emptyBackView, .center, 0)
        emptyTitleLabel.autoAdaptHeight()
        
        emptyTitleLabel.numberOfLines = 0
        emptyBackView.height = emptyTitleLabel.maxY
        if let emptyViewCenter = emptyViewCenter {
            emptyBackView.center = emptyViewCenter
        }else {
            emptyBackView.center = self.center
        }
    }
    
    func removeEmptyView() {
        let emptyView = self.viewWithTag(DMLEmptyViewTag)
        if let emptyView = emptyView {
            emptyView.removeFromSuperview()
        }
    }
}

private let DMLLoadingViewTag = 99099
private let DMLLoadingImageView1Tag = 99098
private let DMLLoadingImageView2Tag = 99097
private let DMLLoadingLabelTag = 99096

//loading
extension BaseMainView {
    func addLoading(_ loadingViewCenter: CGPoint? = nil) {
        let loadingView = self.viewWithTag(DMLLoadingViewTag)
        guard loadingView == nil else {
            return
        }
        self.removeLoading()
        let loadingBackView = UIView.create(0, 0,SP(125), SP(125), ClearColor, self, DMLLoadingViewTag)
        let loadingImageView1 = UIImageView.create(SP(0), 0, SP(60), SP(60), "loadingPic_circle", .scaleToFill, loadingBackView, DMLLoadingImageView1Tag)
        loadingImageView1.alpha = 0.9
        let loadingImageView2 = UIImageView.create(SP(10), SP(10), SP(40), SP(40), "loadingPic_logo", .scaleToFill, loadingBackView, DMLLoadingImageView2Tag)
        loadingImageView2.alpha = 0.8
        let loadingTitleLabel = UILabel.create(loadingImageView2.maxX + SP(5), 0, SP(60), SP(15), "Loading...", HEXCOLOR9, SP(12), loadingBackView, .left, DMLLoadingLabelTag)
        loadingTitleLabel.font = UIFont.boldSystemFont(ofSize: SP(12))
        loadingImageView1.center = CGPoint(x: loadingImageView1.center.x, y: loadingBackView.height / 2)
        loadingImageView2.center = loadingImageView1.center
        loadingTitleLabel.center = CGPoint(x: loadingTitleLabel.center.x, y: loadingBackView.height / 2)
        
        if let loadingViewCenter = loadingViewCenter {
            loadingBackView.center = loadingViewCenter
        }else {
            loadingBackView.center = self.center
        }
        
        self.startLoadingAnimation()
    }
    
    
    func removeLoading() {
        self.removeLoadingAnimated(true)
    }
    
    func removeLoadingAnimated(_ animated: Bool) {
        let loadingView = self.viewWithTag(DMLLoadingViewTag)
        if let loadingView = loadingView {
            let loadingImageView1 = loadingView.viewWithTag(DMLLoadingImageView1Tag)
            let loadingImageView2 = loadingView.viewWithTag(DMLLoadingImageView2Tag)
            if let loadingImageView1 = loadingImageView1, let loadingImageView2 = loadingImageView2 {
                loadingImageView1.layer.removeAllAnimations()
                loadingImageView2.layer.removeAllAnimations()
                loadingView.removeFromSuperview()
            }
            
            if animated {
                let opacityAnimation = CABasicAnimation(keyPath: "opacity")
                opacityAnimation.fromValue = NSNumber(value: 0.0)
                opacityAnimation.toValue = NSNumber(value: 1.0)
                opacityAnimation.duration = 0.25
                self.layer.add(opacityAnimation, forKey: "baseAnimation")
            }
        }
    }
    
    func restartLoadingAniamtion() {
        let loadingView = self.viewWithTag(DMLLoadingViewTag)
        if let loadingView = loadingView {
            let loadingImageView = loadingView.viewWithTag(DMLLoadingImageView1Tag)
            if let loadingImageView = loadingImageView {
                let rotationAnimation = loadingImageView.layer.animation(forKey: "rotationAnimation")
                if rotationAnimation == nil {
                    self.startLoadingAnimation()
                }
            }
        }
    }
    
    func startLoadingAnimation() {
        let loadingView = self.viewWithTag(DMLLoadingViewTag)
        if let loadingView = loadingView {
            let loadingImageView1 = loadingView.viewWithTag(DMLLoadingImageView1Tag)
            let loadingImageView2 = loadingView.viewWithTag(DMLLoadingImageView2Tag)
            if let loadingImageView1 = loadingImageView1, let loadingImageView2 = loadingImageView2 {
                let rotationAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation1.toValue = NSNumber(value: M_PI * 2.0)
                rotationAnimation1.duration = 2.0;
                rotationAnimation1.isCumulative = true;
                rotationAnimation1.repeatCount = 10000;
                loadingImageView1.layer.add(rotationAnimation1, forKey: "rotationAnimation")
                
                let rotationAnimation2 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation2.toValue = NSNumber(value: -M_PI * 2.0)
                rotationAnimation2.duration = 2.0;
                rotationAnimation2.isCumulative = true;
                rotationAnimation2.repeatCount = 10000;
                loadingImageView2.layer.add(rotationAnimation2, forKey: "rotationAnimation")
            }
        }
    }
    
    func recoverLoading() {
        self.restartLoadingAniamtion()
    }
}
