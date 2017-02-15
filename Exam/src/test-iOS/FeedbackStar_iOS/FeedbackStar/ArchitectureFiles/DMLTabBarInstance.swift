//
//  DMLTabBarInstance.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/5.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

let TabbarShareInstance = DMLTabBarInstance()
let TAB_COLOR_UNSELECTED = HEXCOLOR("999999")
let TAB_COLOR_SELECTED = SubColor

//MARK: DMLTabBarInstance
class DMLTabBarInstance {

    let tabStrArr = [
        (LS("tabName_home"), "main_moments_icon_unselected", "main_moments_icon_selected", "DMLHomeViewController"),
        (LS("tabName_colleagues"), "main_colleagues_icon_unselected", "main_colleagues_icon_selected", "DMLColleageViewController"),
        (LS("tabName_message"), "main_messages_icon_unselected", "main_messages_icon_selected", "DMLMessageViewController"),
        (LS("tabName_me"), "main_me_icon_unselected", "main_me_icon_selected", "DMLUserViewController")]
    
    lazy var tabUnitArr: [TabUnit] = { [unowned self] in
        var unitArray = [TabUnit]()
        for i in 0..<self.tabStrArr.count {
            let tupleUnit = self.tabStrArr[i]
            let title =  " " + tupleUnit.0
            let icon_unselected = tupleUnit.1
            let icon_selected = tupleUnit.2
            let vcName = tupleUnit.3
            let tabUnit = TabUnit(title, icon_unselected, icon_selected, vcName)
            unitArray.append(tabUnit)
        }
        return unitArray
        }()
    
    lazy var tabVCArr: [UIViewController] = { [unowned self] in
        var vcArray = [UIViewController]()
        for i in 0..<self.tabUnitArr.count {
            let tabUnit: TabUnit = self.tabUnitArr[i]
            if let vc = tabUnit.viewController {
                vcArray.append(vc)
            }
        }
        return vcArray
        }()
}

class TabUnit {
    var title: String
    var icon_unselected: String
    var icon_selected: String
    var vcName: String
    lazy var viewController: UIViewController? = { [unowned self] in
        let vc = ClassFromVCString(self.vcName)
        return vc
        }()
    
    init(_ titleStr: String, _ iconStr_unselected: String, _ iconStr_selected: String, _ vcNameStr: String) {
        self.title = titleStr
        self.icon_unselected = iconStr_unselected
        self.icon_selected = iconStr_selected
        self.vcName = vcNameStr
    }
}



//MARK: TabBarView
class DMLTabBar: UIView {
    var rootViewController: UIViewController?
    var selectedIndex: Int = 0
    var tabNormalSelectClosure: ((Int) -> Void)?
    var tabAddBtn: DMLTabAddBtn?
    var tabAddSelectClosure: (() -> ())?
    
    convenience init(rootViewController: UIViewController, tabSelect: @escaping (Int) -> Void) {
        self.init()
        self.rootViewController = rootViewController
        self.tabNormalSelectClosure = tabSelect
        self.configUI()
    }
    
    fileprivate func configUI() {
        if self.frame == CGRect.zero {
            self.frame = CGRect(x: 0, y: DeviceHeight - N_TabBarHeight, width: DeviceWidth, height: N_TabBarHeight)
        }
        
        let addBackView = UIView(frame: CGRect(0, 0, SPH(49), SPH(49)))
        addBackView.center = CGPoint(self.width / 2.0, 5)
        addBackView.backgroundColor = ClearColor
        addBackView.layer.cornerRadius = addBackView.width / 2.0
        addBackView.addBorder(0.5, HEXCOLORB)
        self.addSubview(addBackView)
        
        let backView = UIToolbar()
        backView.frame = self.bounds
        backView.alpha = 0.9
        self.addSubview(backView)
        self.rootViewController?.view.addSubview(self)
        
        let addBtnWidth = SPH(48)
        let fixSpace = SPH(40)
        let fixEadge = SPH(10)
        let tabUnitCount = TabbarShareInstance.tabUnitArr.count
        let unitWidth = (DeviceWidth - addBtnWidth - fixSpace - fixEadge * 2) / CGFloat(tabUnitCount)
        
        let addBtnHeight: CGFloat = SPH(48);
        let addBtn = DMLTabAddBtn(CGRect(0, 0, addBtnWidth, addBtnHeight), LS("tabName_add"))
        addBtn.center = CGPoint(self.width / 2.0, 5)
        addBtn.action = { [unowned self] in
            self.tabAddSelectClosure?()
        }
        self.addSubview(addBtn)
        self.tabAddBtn = addBtn
        
        for i in 0..<tabUnitCount {
            let tabUnit = TabbarShareInstance.tabUnitArr[i]
            var originX = (unitWidth) * CGFloat(i) + fixEadge
            if i >= 2 {
                originX += addBtnWidth + fixSpace
            }
            let frame = CGRect(x: originX, y: 0, width: unitWidth, height: self.frame.size.height)
            
            let tabBtn = DMLTabNormalBtn(frame, i, tabUnit.title, UIImage(named: tabUnit.icon_unselected)!, UIImage(named: tabUnit.icon_selected)!, { [unowned self] in
                self.refreshTabbar(i)
                })
            self.addSubview(tabBtn)
            
            if i == 0 {
                self.refreshTabbar(i)
            }
        }
    }
    
    func setTabShowRedDot(_ index: Int, _ isShow: Bool) {
        for subView in self.subviews {
            if subView.isKind(of: DMLTabNormalBtn.self) {
                let btn = subView as! DMLTabNormalBtn
                if btn.index == index {
                    btn.setUnreadDotViewHidden(!isShow)
                    break
                }
            }
        }
    }
    
    func refreshTabbar(_ index: Int) {
        for subView in self.subviews {
            if subView.isKind(of: DMLTabNormalBtn.self) {
                let btn = subView as! DMLTabNormalBtn
                if btn.index == index {
                    btn.setSelected()
                    self.selectedIndex = index
                    self.tabNormalSelectClosure?(index)
                }else {
                    btn.isSelected = false
                    btn.reset()
                }
            }
        }
    }
    
    func updateTabBtnColor(isAddSelected: Bool) {
        self.tabAddBtn?.updateTitleColor(isSelected: isAddSelected)
        for subView in self.subviews {
            if subView.isKind(of: DMLTabNormalBtn.self) {
                let btn = subView as! DMLTabNormalBtn
                if isAddSelected {
                    btn.reset()
                }else {
                    if btn.isSelected {
                        btn.setSelected()
                    }
                }
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let btn = self.tabAddBtn {
            if let view = super.hitTest(point, with: event) {
                return view
            }else {
                let temPoint  = btn.convert(point, from: self)
                if btn.bounds.contains(temPoint) {
                    return btn
                }
            }
        }
        return nil
    }
}

//MARK: DMLTabAddBtn
class DMLTabAddBtn :UIButton {
    let customLabel = UILabel()
    var title: String?
    
    var action: (() -> ())?
    convenience init(_ frame: CGRect, _ title: String) {
        self.init(frame:frame)
        self.title = title
        self.configUI()
    }
    
    func configUI() {
        let backView = UIView()
        backView.frame = self.bounds
        self.addSubview(backView)
        
        backView.addMainChangeShade()
        backView.layer.cornerRadius = self.height / 2.0
        backView.layer.masksToBounds = true
        
        let width = self.height * 0.4
        let hLine = Line.createH(0, 0, width, WhiteColor, backView)
        let vLine = Line.createV(0, 0, width, WhiteColor, backView)
        hLine.height = 2.0
        vLine.width = 2.0
        hLine.center = CGPoint(self.width / 2.0, self.height / 2.0)
        vLine.center = hLine.center
        vLine.isUserInteractionEnabled = false
        hLine.isUserInteractionEnabled = false
        backView.isUserInteractionEnabled = false

        self.customLabel.frame = CGRect(x: -10.s, y: SPH(24) + 27, width: self.width + 20.s, height: 12)
        self.customLabel.text = self.title
        self.customLabel.font = GetFont(SPH(10))
        self.customLabel.textColor = TAB_COLOR_UNSELECTED
        self.customLabel.textAlignment = .center
        self.addSubview(self.customLabel)
        
        self.addTarget(self, action: #selector(self.touchSelect), for: .touchUpInside)
    }
    
    func updateTitleColor(isSelected: Bool) {
        if isSelected {
            self.customLabel.textColor = TAB_COLOR_SELECTED
        }else {
            self.customLabel.textColor = TAB_COLOR_UNSELECTED
        }
    }
    
    func touchSelect() {
        self.action?()
    }
}

//MARK: DMLTabNormalBtn
class DMLTabNormalBtn :UIButton {
    let customLabel = UILabel()
    let customImageView = UIImageView()
    let unreadDotView = UIView()
    var action: (() -> ())?
    var title: String?
    var index: Int?
    var selectedImage: UIImage?
    var unselectedImage: UIImage?
    
    convenience init(_ frame: CGRect, _ index: Int, _ title: String, _ image_unSelected: UIImage, _ image_selected: UIImage, _ action: @escaping () -> ()) {
        self.init(frame:frame)
        self.title = title
        self.index = index
        self.unselectedImage = image_unSelected
        self.selectedImage = image_selected
        self.action = action
        self.configUI()
    }
    
    func configUI() {
        self.backgroundColor = UIColor.clear
        self.showsTouchWhenHighlighted = false
        self.isExclusiveTouch = true
        
        let imageWidth: CGFloat = 24
        let imageHeight: CGFloat = 19
        self.customImageView.image = self.unselectedImage
        self.customImageView.frame = CGRect(x: (self.width - imageWidth) / 2, y: 7, width: imageWidth, height: imageHeight)
        self.customImageView.contentMode = .scaleAspectFit
        self.addSubview(self.customImageView)
        
        self.customLabel.frame = CGRect(x: 0, y: self.customImageView.frame.maxY + 3, width: self.width, height: 12)
        self.customLabel.text = self.title
        self.customLabel.font = GetFont(SPH(10))
        self.customLabel.textColor = TAB_COLOR_UNSELECTED
        self.customLabel.textAlignment = .center
        self.addSubview(self.customLabel)
        
        self.unreadDotView.frame = CGRect(x: 0, y: 0, width: 10.s, height: 10.s)
        self.unreadDotView.backgroundColor = RGB(236, 96, 96)
        self.unreadDotView.center = CGPoint(x: self.customImageView.maxX - 0.s, y: self.customImageView.originY + 2.s)
        self.unreadDotView.layer.cornerRadius = self.unreadDotView.width / 2.0
        self.addSubview(self.unreadDotView)
        self.setUnreadDotViewHidden(true)
        
        self.addTarget(self, action: #selector(self.touchSelect(_:)), for: .touchUpInside)
    }
    
    func setUnreadDotViewHidden(_ isHidden: Bool) {
        self.unreadDotView.isHidden = isHidden
    }
    
    func touchSelect(_ sender: UIButton) {
        self.action?()
    }
    
    func reset() {
        self.customLabel.textColor = TAB_COLOR_UNSELECTED
        self.customImageView.image = self.unselectedImage
    }
    
    func setSelected() {
        self.isSelected = true
        self.customImageView.image = self.selectedImage
        self.customLabel.textColor = TAB_COLOR_SELECTED
    }
}





