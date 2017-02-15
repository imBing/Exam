//
//  ExtensionTextView.swift
//  FeedbackStar
//
//  Created by ya Liu on 2016/12/28.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit
let LimitLabelTag = 9527
let LimitBackViewTag = 9528

extension UITextView {
    private struct AssociatedKeys {
        static var inputMaxCount: Int = 140
        static var limitLabelIntY: CGFloat = 0
    }
    
    var inputMaxCount: Int {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.inputMaxCount)
            if let any = any {
                return any as! Int
            }
            return 140
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.inputMaxCount, newValue as Int!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var limitLabelIntY: CGFloat {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.limitLabelIntY)
            if let any = any {
                return any as! CGFloat
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.limitLabelIntY, newValue as CGFloat!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    //使用默认位置
    func addLimitLabelView(textViewFrame: CGRect) {
        self.addLimitLabelView(frame: CGRect(self.width - 6.s - 100.s, self.height - 16.s - 17.s, 100.s, 17.s), textViewFrame: textViewFrame)
    }
    
    func setLimitLabelViewHidden(isHidden: Bool) {
        if let view = self.superview?.viewWithTag(LimitLabelTag) {
            view.isHidden = isHidden
        }
    }
    //自定义位置
    func addLimitLabelView(frame: CGRect, textViewFrame: CGRect) {
        let backView = UIView(frame:textViewFrame)
        backView.backgroundColor = self.backgroundColor
        backView.tag = LimitBackViewTag
        self.backgroundColor = ClearColor
        self.superview?.addSubview(backView)
        self.superview?.insertSubview(backView, belowSubview: self)
        
        let limitLabel = UILabel(frame: frame)
        limitLabel.tag = LimitLabelTag
        limitLabel.text = "0/\(self.inputMaxCount)"
        limitLabel.textAlignment = .right
        limitLabel.textColor = RGB(160, 160, 160)
        limitLabel.font = GetFont(14.s)
        backView.addSubview(limitLabel)
    }
    
    func updateLimitLabelTitle(_ replacementText: String) -> Bool {
        if let backView = self.superview?.viewWithTag(LimitBackViewTag) {
            if let label = backView.viewWithTag(LimitLabelTag) as? UILabel {
                let textLength = self.text?.lengthOfBytes(using: .utf8) ?? 0
                let replaceStrLength = replacementText.lengthOfBytes(using: .utf8)
                var length = replaceStrLength
                if replaceStrLength == 0 {
                    length -= 1
                }
                var finalLength = textLength + length
                if finalLength <= self.inputMaxCount || replaceStrLength == 0 {
                    finalLength = max(0, finalLength)
                    label.text = "\(finalLength)/\(self.inputMaxCount)"
                    return true
                }
            }
        }
        return false
    }
    
    func updateLimitLabelTitle(count: Int) {
        if let label = self.superview?.viewWithTag(LimitLabelTag) as? UILabel {
            label.text = "\(count)/\(self.inputMaxCount)"
        }
    }
}
