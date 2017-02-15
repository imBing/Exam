//
//  DMLNavigationBar.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/7.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

private let LeftBaseTag = 20500
private let RightBaseTag = 20600
private let TitleViewTag = 9555
private let WebProcessTag = 9097

private let WebProcessHeight: CGFloat = 2.0

class DMLNavigationBar: UIView {
    var leftItems: [NavItem]?
    var rightItems: [NavItem]?
    var navTitle: String?
    
    var contentView: UIView = UIView()
    var leftMax: CGFloat = 0
    var rightMax: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    convenience init(_ title: String?, _ leftItems: [NavItem]?, _ rightItems: [NavItem]?) {
        self.init(frame: CGRect.zero)
        self.leftItems = leftItems
        self.rightItems = rightItems
        self.navTitle = title
        self.congfigUI()
    }
    
    //default style
    convenience init(defaultTitle: String?) {
        var leftItems: [NavItem]?
        if APPManager.getCurrentActiveNVC().viewControllers.count > 1 {
            leftItems = [NavItem(UIImage(named: "nav_back")!) {
                APPManager.getCurrentActiveNVC().popViewController(animated: true)
                }]
        }

        self.init(defaultTitle, leftItems, [])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func congfigUI() {
        self.frame = CGRect(x: 0, y: 0, width: DeviceWidth, height: N_NavBarHeight + N_StatusBarHeight)
        
        self.addMainChangeShade()
        
        self.contentView.frame = CGRect(x: 0, y: N_StatusBarHeight, width: self.frame.width, height: self.frame.height - N_StatusBarHeight)
        self.contentView.backgroundColor = ClearColor
        
        self.addSubview(self.contentView)
        
        let bottomLine = Line.createH(0, 0, self.width, HEXCOLORC, self)
        bottomLine.originY = self.height - bottomLine.height
        
        self.createLeftItems()
        self.createRightItems()
        self.createNavTitleView()
    }
    
    func createLeftItems() {
        if let count = self.leftItems?.count {
            self.leftMax = SPH(8)
            for i in 0..<count {
                let item = self.leftItems![i]
                if item.itemObj is String {
                    let str = item.itemObj as! String
                    let fontSize: CGFloat = SPH(14)
                    let width = str.getLabelWidth(fontSize, fontSize) + SPH(10)
                    let itemBtn = UIButton.create(self.leftMax, 0, width, N_NavBarHeight, str, fontSize, WhiteColor, self, #selector(self.leftAction(_:)), self.contentView, LeftBaseTag + i)
                    itemBtn.contentHorizontalAlignment = .center
                    itemBtn.contentVerticalAlignment = .center
                    self.leftMax = itemBtn.frame.maxX
                }else if item.itemObj is UIImage {
                    let image = item.itemObj as! UIImage
                    let itemBtn = UIButton(type: .custom)
                    itemBtn.frame = CGRect(x: self.leftMax, y: 0, width: SPH(30), height: N_NavBarHeight)
                    itemBtn.tag = LeftBaseTag + i
                    itemBtn.setImage(image, for: UIControlState())
                    itemBtn.contentHorizontalAlignment = .center
                    itemBtn.contentVerticalAlignment = .center
                    itemBtn.addTarget(self, action: #selector(self.leftAction(_:)), for: .touchUpInside)
                    itemBtn.contentHorizontalAlignment = .center
                    itemBtn.contentVerticalAlignment = .center
                    
                    let imageSize = image.size
                    let HSpace: CGFloat = SPH(5)
                    let VSpace: CGFloat = 22 - SPH(10) * imageSize.height / imageSize.width
                    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(VSpace, HSpace, VSpace, HSpace)
                    
                    self.contentView.addSubview(itemBtn)
                    self.leftMax = itemBtn.frame.maxX
                }
            }
        }
    }
    
    func leftAction(_ sender: UIButton) {
        let item = self.leftItems![sender.tag - LeftBaseTag]
        item.action()
    }
    
    
    func createNavTitleView() {
        let originX = (self.width - (self.width - max(self.leftMax, self.rightMax) * 2) * 0.95) / 2
        let titleLabel = UILabel.create(originX, 0, self.width - 2 * originX, N_NavBarHeight, self.navTitle, WhiteColor, SPH(18), self.contentView, .center, TitleViewTag)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func createRightItems() {
        if let count = self.rightItems?.count {
            self.rightMax = SPH(8)
            for i in 0..<count {
                let item = self.rightItems![i]
                if item.itemObj is String {
                    let str = item.itemObj as! String
                    let fontSize: CGFloat = SPH(14)
                    let width = str.getLabelWidth(fontSize, fontSize) + SPH(16)
                    self.rightMax += width
                    let itemBtn = UIButton.create(self.width - self.rightMax, 0, width, N_NavBarHeight, str, fontSize, WhiteColor, self, #selector(self.rightAction(_:)), self.contentView, RightBaseTag + i)
                    itemBtn.contentHorizontalAlignment = .center
                    itemBtn.contentVerticalAlignment = .center
                    self.rightMax = self.width - itemBtn.frame.minX
                }else if item.itemObj is UIImage {
                    let image = item.itemObj as! UIImage
                    let itemBtn = UIButton(type: .custom)
                    self.rightMax += SPH(30)
                    itemBtn.frame = CGRect(x: self.width - self.rightMax, y: 0, width: SPH(30), height: N_NavBarHeight)
                    itemBtn.tag = RightBaseTag + i
                    itemBtn.setImage(image, for: UIControlState())
                    itemBtn.imageView?.contentMode = .scaleAspectFit
                    itemBtn.contentHorizontalAlignment = .center
                    itemBtn.contentVerticalAlignment = .center
                    itemBtn.addTarget(self, action: #selector(self.rightAction(_:)), for: .touchUpInside)
                    itemBtn.contentHorizontalAlignment = .center
                    itemBtn.contentVerticalAlignment = .center
                    
                    let imageSize = image.size
                    let HSpace: CGFloat = SPH(5)
                    let VSpace: CGFloat = 22 - SPH(16) * imageSize.height / imageSize.width
                    itemBtn.imageEdgeInsets = UIEdgeInsetsMake(VSpace, HSpace, VSpace, HSpace)
                    
                    self.contentView.addSubview(itemBtn)
                    self.rightMax = self.width - itemBtn.frame.minX
                }
            }
        }
    }
    
    func rightAction(_ sender: UIButton) {
        let item = self.rightItems![sender.tag - RightBaseTag]
        item.action()
    }
    
    //custom set navigation subview
    func setNavigationCustomView(_ configCustomView: () -> UIView) {
        self.resetUI("", nil, nil)
        self.contentView.addSubview(configCustomView())
    }
    
    //reset navTitle
    func resetTitle(_ title: String) {
        self.navTitle = title
        let titleLabel = self.contentView.viewWithTag(TitleViewTag) as? UILabel
        if  let titleLabel = titleLabel {
            titleLabel.text = self.navTitle
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }

    //reset navigationUI
    func resetUI(_ title: String?, _ leftItems: [NavItem]?, _ rightItems: [NavItem]?) {
        self.leftItems = leftItems
        self.rightItems = rightItems
        self.navTitle = title
        
        self.contentView.removeSubviews()
//        self.removeSubviews()
        self.congfigUI()
    }
    
    func addWebViewProcess() {
        if let processView = self.contentView.viewWithTag(WebProcessTag) {
            processView.removeFromSuperview()
        }
        
        let process = UIImageView(image: UIImage(named: "webViewProcess"))
        process.tag = WebProcessTag
        process.frame = CGRect(0, N_NavBarHeight - WebProcessHeight - 0.5, 0, WebProcessHeight)
        process.contentMode = .scaleToFill
        self.contentView.addSubview(process)
    }
    
    func setWebViewProcess(_ process: Double) {
        if let processView = self.contentView.viewWithTag(WebProcessTag) {
            UIView.animate(withDuration: 0.3, delay: 0.01, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: .curveEaseOut, animations: { 
                processView.frame = CGRect(0, N_NavBarHeight - WebProcessHeight - 0.5, DeviceWidth * CGFloat(process), WebProcessHeight)
                }, completion: nil)
        }
    }
    
    func removeWebViewProcess() {
        if let processView = self.contentView.viewWithTag(WebProcessTag) {
            processView.layer.removeAllAnimations()
            processView.removeFromSuperview()
        }
    }
    
    func resetLeftBackBtn() {
        var vc = self.getCurrentViewController()
        if vc == nil {
           vc = APPManager.getCurrentActiveVC()
        }
        
        let nvc = vc?.navigationController
        if let nvc = nvc, nvc.viewControllers.count <= 1 {
            self.leftItems?.removeAll()
            self.resetUI(self.navTitle, self.leftItems, self.rightItems)
        }
    }
    
    func getCurrentViewController() -> UIViewController? {
        var next = self.next
            repeat {
                if let n = next {
                    if n is UIViewController {
                        return n as? UIViewController
                    }
                    next = n.next
                }
            }while next != nil
 
        return nil
    }
}

//MARK: NavItem
class NavItem: NSObject {
    var itemObj : Any   //只能是UIImage或String
    var action: (Void) -> Void
    init(_ item: Any, action: @escaping (Void) -> Void) {
        self.itemObj = item
        self.action = action
    }
}













