//
//  DMLCommonDefineFile.swift
//  FeedbackStar
//
//  Created by xuqingqing on 16/7/22.
//  Copyright © 2016年 DML. All rights reserved.
//

import Foundation
import UIKit
/********************此文件定义项目中数字常量********************/

//屏幕尺寸
let DeviceWidth: CGFloat = UIScreen.main.bounds.width
let DeviceHeight: CGFloat = UIScreen.main.bounds.height

//获取当前设备系统版本
let SystemVersionValue: String = UIDevice.current.systemVersion
let CurrentBundleVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let CurrentAppName: String = Bundle.main.infoDictionary!["CFBundleName"] as! String

//一些标准常量
let N_StatusBarHeight: CGFloat = 20.0
let N_NavBarHeight: CGFloat = 44.0
let N_TabBarHeight: CGFloat = 49.0
let N_ContentHeight: CGFloat = DeviceHeight - N_StatusBarHeight - N_NavBarHeight - N_TabBarHeight
let N_ContentHeight_Tab: CGFloat = DeviceHeight - N_StatusBarHeight - N_NavBarHeight

//适配尺寸
//修改放大系数(针对于plus), 6自动适应大小
let MULTI: CGFloat = 1.15
let MULTID: CGFloat = 1.08

//value的值以4.7寸为基准， 4寸及5.5寸自动适配
let baseWidth: CGFloat = 375.0
//缩小比例
let AdaptFixValue: CGFloat = 0.9

func SP(_ value: CGFloat) -> CGFloat {
    var ret = ((DeviceWidth / baseWidth) * (value)) * AdaptFixValue
    if ret > 0 && ret < 0.5 {
        ret = 0.5
    }
    return ret
}

func SPH(_ value: CGFloat) -> CGFloat {
    let subValue1 = (DeviceWidth - baseWidth) / baseWidth
    let subValue2 = (MULTI - 1) / 0.27
    var ret = (subValue1 * subValue2 + 1) * value * AdaptFixValue
    if ret > 0 && ret < 0.5 {
        ret = 0.5
    }
    return ret
}

func SPHP(_ value: CGFloat) -> CGFloat {
    let subValue1 = (DeviceWidth - baseWidth) / baseWidth
    let subValue2 = (MULTID - 1) / 0.27
    return (subValue1 * subValue2 + 1) * value
}


//MARK: Font-Define
func GetFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

func GetBoldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}


//MARK: Color
let MainColor = HEXCOLOR("00B3C7")
let SubColor = HEXCOLOR("16A6B7")
let ThirdColor = HEXCOLOR("EC8060")

let ClearColor = UIColor.clear
let WhiteColor = UIColor.white
let BlackColor = UIColor.black
let LightGrayColor = UIColor.lightGray
let GrayColor = UIColor.gray
let RedColor = UIColor.red
let BlueColor = UIColor.blue

let HEXCOLOR00B3C7 = HEXCOLOR("00B3C7")//主调色
let HEXCOLOR16 = HEXCOLOR("16A6B7")//按钮
let HEXCOLOR3 = HEXCOLOR("333333")//标题
let HEXCOLOR6 = HEXCOLOR("666666")//正文文本
let HEXCOLOR9 = HEXCOLOR("999999")//提示文字
let HEXCOLOREA = HEXCOLOR("EAEBED")//分割线
let HEXCOLORF4 = HEXCOLOR("F4F4F4")//背景色
let HEXCOLOREC = HEXCOLOR("EC8060") //辅助色,name
let HEXCOLORE0 = HEXCOLOR("E0E0E0")
let HEXCOLOR31 = HEXCOLOR("31BBCB") //button
let HEXCOLORB9 = HEXCOLOR("B9B9B9")  //虚线边框颜色
let HEXCOLOR00 = HEXCOLOR("00B8C3")
let HEXCOLORA0 = HEXCOLOR("A0A0A0")

let SEPERATE_COLOR = HEXCOLOR("EAEBED") //分割线
let BACKGROUND_COLOR = HEXCOLOR("F4F4F4") //背景色
let HEXCOLORB = HEXCOLOR("bbbbbb")
let HEXCOLORD = HEXCOLOR("dddddd")
let HEXCOLORC = HEXCOLOR("cccccc")
let HEXCOLORE = HEXCOLOR("eeeeee")

//MARK:Font
let naviTitleFont18 = UIFont.systemFont(ofSize: 18)
let titleFont16 =  UIFont.systemFont(ofSize: 16)
let contentFont14 = UIFont.systemFont(ofSize: 14)
let noticeFont = UIFont.systemFont(ofSize: 12)

//CGRect CGPoint
let CGRectZero = CGRect(0, 0, 0, 0)
let CGPointZero = CGPoint(0, 0)

//RGBColor
func RGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return RGB(red, green, blue, 1)
}

func RGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor(colorLiteralRed: Float(red) / 255.0, green: Float(green) / 255.0, blue: Float(blue) / 255.0, alpha: Float(alpha))
}

//MARK: Localization
func LS(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

//MARK: NSString -> Class
//TO NSObject
func ClassFromString(_ classNmae: String) -> NSObject? {
    let anyClass: AnyClass? = NSClassFromString(CurrentAppName + "." + classNmae)
    if let l = anyClass {
        let cls = l as? NSObject.Type
        return cls?.init()
    }
    return nil
}

//TO ViewControllers
func ClassFromVCString(_ classNmae: String) -> UIViewController? {
    let anyClass: AnyClass? = NSClassFromString(CurrentAppName + "." + classNmae)
    if let l = anyClass {
        let cls = l as? UIViewController.Type
        return cls?.init()
    }
    return nil
}

func compareVersion(_ version1: String, _ version2: String) -> ComparisonResult {
    let arr1 = version1.components(separatedBy: ".")
    let arr2 = version2.components(separatedBy: ".")
    
    var value1 = 0
    var value2 = 0
    
    let maxCount = max(arr1.count, arr2.count)
    for i in 0..<maxCount {
        if i < arr1.count {
            value1 += Int(pow(10, Double(maxCount - i - 1))) * arr1[i].intValue
        }
        if i < arr2.count {
            value2 += Int(pow(10, Double(maxCount - i - 1))) * arr2[i].intValue
        }
    }
    
    if value1 < value2 {
        return .orderedAscending
    }else if value1 > value2 {
        return .orderedDescending
    }
    return .orderedSame
}

//小于系统版本号时返回false
func compareSystemVersion(comparedVersion: String) -> Bool {
    if compareVersion(SystemVersionValue, comparedVersion) == .orderedDescending {
        return false
    }
    return true
}

//CGRect 
func Rect(_ x: CGFloat, _ y : CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: w, height: h)
}

extension CGRect {
    public init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}

//CGSize
func Size(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width: width, height: height)
}

extension CGSize {
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
}

//CGPoint
func Point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

extension CGPoint {
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
}

//TODO: 统计需要加入线上接口判断（注意）


//MARK: print-Debug
// custom print - Debug
func DPrint<AnyObj>(_ object: AnyObj, methodName: String = #function) {
    #if DEBUG
        print("\(methodName):\(object)")
    #endif
}

