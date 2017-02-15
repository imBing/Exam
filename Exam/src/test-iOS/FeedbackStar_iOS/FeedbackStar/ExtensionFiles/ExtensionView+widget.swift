//
//  ExtensionFile.swift
//  SwiftTestProject
//
//  Created by xuqingqing on 16/7/19.
//  Copyright © 2016年 LKZ. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

//MARK:UILabel的扩展
extension UILabel {
    /*
    x,y,w,h 坐标及大小
    tx：文字内容
    tc：文字颜色
    ts：文字大小
    ta：文字对齐方式
    tg：label的tag值
    sv：label的superView
    */
    
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String?, _ tc: UIColor?, _ ts: CGFloat) {
        self.init(frame: CGRect(x ,y ,w ,h))
        self.text = tx
        self.textColor = tc
        self.font = UIFont.systemFont(ofSize: CGFloat(ts))
    }
    
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String?, _ tc: UIColor?, _ ts: CGFloat, _ sv: UIView!) -> UILabel {
        return create(x, y, w, h, tx, tc, ts, sv, NSTextAlignment.left, 0)
    }
    
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String?, _ tc: UIColor?, _ ts: CGFloat, _ sv: UIView!, _ ta: NSTextAlignment) -> UILabel {
        return create(x, y, w, h, tx, tc, ts, sv, ta, 0)
    }
    
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String?, _ tc: UIColor?, _ ts: CGFloat, _ sv: UIView?, _ ta: NSTextAlignment, _ tg: NSInteger) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        label.text = tx
        label.textColor = tc
        label.font = UIFont.systemFont(ofSize: CGFloat(ts))
        label.textAlignment = ta
        if tg != 0 {
            label.tag = tg
        }
        sv?.addSubview(label)
        return label
    }
}

//MARK:UIButton的扩展
extension UIButton {
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ np: String, _ ta: AnyObject?, _ ac: Selector) {
        self.init(type: .custom)
        self.frame = CGRect(x, y , w, h)
        self.setImage(UIImage(named: np), for: UIControlState())
        self.addTarget(ta, action: ac, for: .touchUpInside)
    }
    
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String, _ ts: CGFloat, _ nc: UIColor?, _ ta: AnyObject?, _ ac: Selector) {
        self.init(type: .custom)
        self.frame = CGRect(x, y , w, h)
        self.setTitle(tx, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: ts)
        self.setTitleColor(nc, for: .normal)
        self.addTarget(ta, action: ac, for: .touchUpInside)
    }
    
    
    //图片button 不带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ np: String, _ ta: AnyObject?, _ ac: Selector, _ sv: UIView) -> UIButton {
        return self.create(x, y, w, h, np, ta, ac, sv, 0)
    }
    
    //图片button 带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ np: String, _ ta: AnyObject?, _ ac: Selector, _ sv: UIView?, _ tg: NSInteger) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: x, y: y, width: w, height: h)
        if tg != 0 {
            btn.tag = tg
        }
        btn.setImage(UIImage(named: np), for: UIControlState())
        btn.addTarget(ta, action: ac, for: .touchUpInside)
        sv?.addSubview(btn)
        return btn
    }
    
    //文本button 不带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String, _ ts: CGFloat, _ nc: UIColor?, _ ta: AnyObject?, _ ac: Selector, _ sv: UIView?) -> UIButton {
        return self.create(x, y, w, h, tx, ts, nc, ta, ac, sv, 0)
    }
    
    //文本button 带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ tx: String, _ ts: CGFloat, _ nc: UIColor?, _ ta: AnyObject?, _ ac: Selector, _ sv: UIView?, _ tg: NSInteger) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: x, y: y, width: w, height: h)
        if tg != 0 {
            btn.tag = tg
        }
        btn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(ts))
        btn.setTitle(tx, for: UIControlState())
        btn.setTitleColor(nc, for: UIControlState())
        btn.addTarget(ta, action: ac, for: .touchUpInside)
        sv?.addSubview(btn)
        return btn
    }
    
    //setUrlImages
    func setImageWithUrlStr(_ urlStr: String, _ state: UIControlState) {
        self.setImageWithUrlStr(urlStr, nil, state)
    }
    
    func setImageWithUrlStr(_ urlStr: String, _ placeholder: String?, _ state: UIControlState) {
        var image: UIImage?
        if let placeholder = placeholder {
            image = UIImage(named: placeholder)
        }
        if let url = URL(string: urlStr) {
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            self.kf.setImage(with: resource, for: state, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            if let _ = image {
                self.setImage(image, for: state)
            }
        }
    }
    
    
    
    func setBackgroundImageWithUrlStr(_ urlStr: String, _ state: UIControlState) {
        self.setImageWithUrlStr(urlStr, nil, state)
    }
    
    func setBackgroundImageWithUrlStr(_ urlStr: String, _ placeholder: String?, _ state: UIControlState) {
        var image: UIImage?
        if let placeholder = placeholder {
            image = UIImage(named: placeholder)
        }
        if let url = URL(string: urlStr) {
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            self.kf.setBackgroundImage(with: resource, for: state, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            if let _ = image {
                self.setBackgroundImage(image, for: state)
            }
        }
    }
}

//MARK:View扩展
extension UIView {
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin.x = newValue.x
            self.frame.origin.y = newValue.y
        }
    }
    
    var originX: CGFloat {
        get {
            return self.frame.minX
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var originY: CGFloat {
        get {
            return self.frame.minY
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var maxX: CGFloat {
        get {
            return self.originX + self.width
        }
    }
    
    var maxY: CGFloat {
        get {
            return self.originY + self.height
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(newValue, self.center.y)
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(self.center.x, newValue)
        }
    }

    
    func removeSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ bc: UIColor) {
        self.init(frame: CGRect(x, y , w, h))
        self.backgroundColor = bc
    }

    
    //不带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ bc: UIColor, _ sv: UIView?) -> UIView {
        return self.create(x, y, w, h, bc, sv, 0)
    }
    
    //带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ bc: UIColor, _ sv: UIView?, _ tg: NSInteger) -> UIView {
        let view = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
        view.backgroundColor = bc
        if tg != 0 {
            view.tag = tg
        }
        sv?.addSubview(view)
        return view
    }
    
    //加阴影
    func addShadow(_ shadowOffsetW: CGFloat, _ shadowOffsetY: CGFloat, _ shadowColor: UIColor, _ shadowOpacity: Float) {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffsetW, height: shadowOffsetY)
        self.layer.shadowOpacity = shadowOpacity
    }
    
    func addDefaultShadow() {
        self.addShadow(0.5, 0.5, LightGrayColor, 0.5)
    }
    
    //加边框
    func addBorder(_ borderWidth: CGFloat, _ borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    //加虚线边框
    func addDashedbox(_ frame:CGRect ,_ strokeColor:UIColor,_ fillColor: UIColor,_ Radius:CGFloat)  {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(0,0,frame.size.width,frame.size.height), cornerRadius: Radius).cgPath
        layer.strokeColor =  strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineDashPattern = [3 , 3]
        self.layer.addSublayer(layer)
    }
    
    
    
}

//MARK:分割线
class HLine: UIView {
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ bc: UIColor) {
        var h: CGFloat = 0.5
        if compareSystemVersion(comparedVersion: "8.0") {
            h = 0.51
        }
        self.init(frame: CGRect(x, y , w, h))
        self.backgroundColor = bc
    }
}

class VLine: UIView {
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ h: CGFloat, _ bc: UIColor) {
        var w: CGFloat = 0.5
        if compareSystemVersion(comparedVersion: "8.0") {
            w = 0.51
        }
        self.init(frame: CGRect(x, y , w, h))
        self.backgroundColor = bc
    }
}

class Line: UIView {
    //水平分割线 不带tag值
    class func createH(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ bc: UIColor, _ sv: UIView?) -> UIView {
        return self.createH(x, y, w, bc, sv, 0)
    }
    
    //水平分割线 带tag值
    class func createH(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ bc: UIColor, _ sv: UIView?, _ tg: NSInteger) -> UIView {
        var height = 0.5
        if compareSystemVersion(comparedVersion: "8.0") {
            height = 0.51
        }
        return UIView.create(x, y, w, CGFloat(height), bc, sv, tg)
    }

    //垂直分割线 不带tag值
    class func createV(_ x: CGFloat, _ y: CGFloat, _ h: CGFloat, _ bc: UIColor, _ sv: UIView?) -> UIView {
        return self.createV(x, y, h, bc, sv, 0)
    }
    
    //垂直分割线 带tag值
    class func createV(_ x: CGFloat, _ y: CGFloat, _ h: CGFloat, _ bc: UIColor, _ sv: UIView?, _ tg: NSInteger) -> UIView {
        var width = 0.5
        if compareSystemVersion(comparedVersion: "8.0") {
            width = 0.51
        }
        return UIView.create(x, y, CGFloat(width), h, bc, sv, tg)
    }
}

//MARK:UIImageView的扩展
extension UIImageView {
    public convenience init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ im: String, _ cm: UIViewContentMode) {
        self.init(frame: CGRect(x ,y ,w ,h))
        self.image = UIImage(named: im)
        self.contentMode = cm
    }
    

    //不带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ im: String, _ cm: UIViewContentMode, sv: UIView?) -> UIImageView {
        return self.create(x, y, w, h, im, cm, sv, 0)
    }
    
    //带tag值
    class func create(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ im: String, _ cm: UIViewContentMode, _ sv: UIView?, _ tg: NSInteger) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: w, height: h))
        imageView.image = UIImage(named: im)
        imageView.contentMode = cm
        if tg != 0 {
            imageView.tag = tg
        }
        sv?.addSubview(imageView)
        return imageView
    }
    
    func setImageWithUrlStr(_ urlStr: String) {
        self.setImageWithUrlStr(urlStr, nil)
    }
    
    func setImageWithUrlStr(_ urlStr: String, _ placeholder: String?) {
        self.setImageWithUrlStr(urlStr, placeholder, nil)
    }
    
    func setImageWithUrlStr(_ urlStr: String, _ placeholder: String?, _ progress: ((CGFloat) -> ())?) {
        var image: UIImage?
        if let placeholder = placeholder {
            image = UIImage(named: placeholder)
        }
        if let url = URL(string: urlStr) {
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            self.kf.setImage(with: resource, placeholder: image, options: nil, progressBlock: { (recivedSize, totalSize) in
                let pro = CGFloat(recivedSize) / CGFloat(totalSize)
                progress?(pro)
                }, completionHandler: { (image, error, type, url) in
            })
        }else{
            if let _ = image {
                self.image = image
            }
        }
    }
}

extension UIImage {
   class func downloadWith(urlStr: String, progress: ((CGFloat) -> ())?, complete: @escaping (UIImage) -> ()) {
        if let url = URL(string: urlStr) {
            let manager = KingfisherManager.shared
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            manager.retrieveImage(with: resource, options: nil, progressBlock: { (receivedSize, expectedSize) in
                let p = CGFloat(receivedSize) / CGFloat(expectedSize)
                progress?(p)

                }, completionHandler: { (image, error, url, data) in
                    if let image = image {
                        complete(image)
                    }
            })
            
//            let aa = [KingfisherOptionsInfoItem.onlyFromCache]
//            
//            manager.downloader.downloadImage(with: url, options: aa, progressBlock: { (receivedSize, expectedSize) in
//                let p = CGFloat(receivedSize) / CGFloat(expectedSize)
//                progress?(p)
//                }, completionHandler: { (image, error, url, data) in
//                    if let image = image {
//                        complete(image)
//                    }
//            })
        }
    }
}

//主渐变色
private let startColor = HEXCOLOR("00C7BB")
private let endColor = HEXCOLOR("00B3C7")

extension UIView {
    func addMainChangeShade() {
        let layer = CAGradientLayer()
        layer.bounds = self.bounds
        layer.borderWidth = 0
        layer.frame = self.bounds
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint(0, 0.5)
        layer.endPoint = CGPoint(1, 0.5)
        self.layer.insertSublayer(layer, at: 0)
    }
    
    //view添加点击事件
    func addOnClickListener(target: AnyObject, action: Selector) {
    let gr = UITapGestureRecognizer(target: target, action: action)
    gr.numberOfTapsRequired = 1
    isUserInteractionEnabled = true
    addGestureRecognizer(gr)
    }

    
    
}



