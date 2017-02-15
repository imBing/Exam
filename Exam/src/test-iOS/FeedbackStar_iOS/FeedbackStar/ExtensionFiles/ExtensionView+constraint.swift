//
//  ExtensionView+Constraint.swift
//  FeedbackStar
//
//  Created by James Xu on 16/10/18.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

private enum AdaptType {
    case SP
    case SPH
}

private enum AdaptConstraint {
    case Left
    case Right
    case Width
    case Height
    case Top
    case Bottom
}

////以4.7寸为基准
//private func SPValue(_ value: CGFloat) -> CGFloat {
//    return ((UIScreen.main.bounds.width / 375.0) * (value))
//}
//
//private func SPHValue(_ value: CGFloat) -> CGFloat {
//    let MULTI: CGFloat = 1.15
//    let subValue1 = (UIScreen.main.bounds.width - 375) / 375.0
//    let subValue2 = (MULTI - 1) / 0.29
//    return (subValue1 * subValue2 + 1) * value * 0.9
//}

extension UIView {
    private struct AssociatedKeys {
        static var isLeftConstraintAdapted = false
        static var isRightConstraintAdapted = false
        static var isWidthConstraintAdapted = false
        static var isHeightConstraintAdapted = false
        static var isTopConstraintAdapted = false
        static var isBottomConstraintAdapted = false
        static var isAllConstraintAdapted = false
        static var isFontAdapted = false
    }
    
    var isLeftConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isLeftConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isLeftConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isRightConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isRightConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isRightConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var isWidthConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isWidthConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isWidthConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var isHeightConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isHeightConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isHeightConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isTopConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isTopConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isTopConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var isBottomConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isBottomConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isBottomConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isAllConstraintAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isAllConstraintAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isAllConstraintAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isFontAdapted: Bool {
        get {
            let any = objc_getAssociatedObject(self, &AssociatedKeys.isFontAdapted)
            if let any = any {
                return any as! Bool
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isFontAdapted, newValue as Bool!, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    
    open func updateAllConstraintsToSP() {
        self.updateLeftConstraintToSP()
        self.updateRightConstraintToSP()
        self.updateWidthConstraintToSP()
        self.updateHeightConstraintToSP()
        self.updateTopConstraintToSP()
        self.updateBottomConstraintToSP()
        self.isAllConstraintAdapted = true
        
        self.updateFontToSP()
    }
    
    open func updateAllConstraintsToSPH() {
        self.updateLeftConstraintToSPH()
        self.updateRightConstraintToSPH()
        self.updateWidthConstraintToSPH()
        self.updateHeightConstraintToSPH()
        self.updateTopConstraintToSPH()
        self.updateBottomConstraintToSPH()
        self.isAllConstraintAdapted = true
        
        self.updateFontToSPH()
    }
    
    open func adaptAllViewsToSPH() {
        for subView1 in self.subviews {
            subView1.updateAllConstraintsToSPH()
            for subView2 in subView1.subviews {
                subView2.updateAllConstraintsToSPH()
                for subView3 in subView2.subviews {
                    subView3.updateAllConstraintsToSPH()
                    for subView4 in subView3.subviews {
                        subView4.updateAllConstraintsToSPH()
                    }
                }
            }
        }
    }
    
    open func adaptAllViewsToSP() {
        for subView1 in self.subviews {
            subView1.updateAllConstraintsToSP()
            for subView2 in subView1.subviews {
                subView2.updateAllConstraintsToSP()
                for subView3 in subView2.subviews {
                    subView3.updateAllConstraintsToSP()
                    for subView4 in subView3.subviews {
                        subView4.updateAllConstraintsToSP()
                    }
                }
            }
        }
    }
    
    private func updateFont(_ adaptType: AdaptType) {
        guard !isFontAdapted else {
            print("\(self): font have adapted!")
            return
        }

        self.isFontAdapted = true
        
        if self is UILabel {
            let label = self as! UILabel
            if label.font.fontName.contains("Bold") {
                if adaptType == .SPH {
                    label.font = UIFont.boldSystemFont(ofSize: SPH(label.font.pointSize))
                }else {
                    label.font = UIFont.boldSystemFont(ofSize: SP(label.font.pointSize))
                }
            }else if label.font.fontName.contains("Italic") {
                if adaptType == .SPH {
                    label.font = UIFont.italicSystemFont(ofSize: SPH(label.font.pointSize))
                }else {
                    label.font = UIFont.italicSystemFont(ofSize: SP(label.font.pointSize))
                }
            }else {
                if adaptType == .SPH {
                    label.font = UIFont.systemFont(ofSize: SPH(label.font.pointSize))
                }else {
                    label.font = UIFont.systemFont(ofSize: SP(label.font.pointSize))
                }            }
        }else if self is UITextView {
            let textView = self as! UITextView
            if var font = textView.font {
                if font.fontName.contains("Bold") {
                    if adaptType == .SPH {
                        font = UIFont.boldSystemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.boldSystemFont(ofSize: SP(font.pointSize))
                    }
                }else if font.fontName.contains("Italic") {
                    if adaptType == .SPH {
                        font = UIFont.italicSystemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.italicSystemFont(ofSize: SP(font.pointSize))
                    }
                }else {
                    if adaptType == .SPH {
                        font = UIFont.systemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.systemFont(ofSize: SP(font.pointSize))
                    }
                }
            }
        }else if self is UITextField {
            let textField = self as! UITextField
            if var font = textField.font {
                if font.fontName.contains("Bold") {
                    if adaptType == .SPH {
                        font = UIFont.boldSystemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.boldSystemFont(ofSize: SP(font.pointSize))
                    }
                }else if font.fontName.contains("Italic") {
                    if adaptType == .SPH {
                        font = UIFont.italicSystemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.italicSystemFont(ofSize: SP(font.pointSize))
                    }
                }else {
                    if adaptType == .SPH {
                        font = UIFont.systemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.systemFont(ofSize: SP(font.pointSize))
                    }
                }
            }
        }else if self is UIButton {
            let button = self as! UIButton
            if var font = button.titleLabel?.font {
                if font.fontName.contains("Semibold") {
                    if adaptType == .SPH {
                        font = UIFont.boldSystemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.boldSystemFont(ofSize: SP(font.pointSize))
                    }
                }else if font.fontName.contains("Italic") {
                    if adaptType == .SPH {
                        font = UIFont.italicSystemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.italicSystemFont(ofSize: SP(font.pointSize))
                    }
                }else {
                    if adaptType == .SPH {
                        font = UIFont.systemFont(ofSize: SPH(font.pointSize))
                    }else {
                        font = UIFont.systemFont(ofSize: SP(font.pointSize))
                    }
                }
            }
        }

    }

    
    //left
    open func updateLeftConstraintToSP() {
        self.adaptConstraint(constraintType: .Left, adaptType: .SP)
    }
    
    open func updateLeftConstraintToSPH() {
        self.adaptConstraint(constraintType: .Left, adaptType: .SPH)
    }

    //right
    open func updateRightConstraintToSP() {
        self.adaptConstraint(constraintType: .Right, adaptType: .SP)
    }
    
    open func updateRightConstraintToSPH() {
        self.adaptConstraint(constraintType: .Right, adaptType: .SPH)
    }

    //width
    open func updateWidthConstraintToSP() {
        self.adaptConstraint(constraintType: .Width, adaptType: .SP)
    }
    
    open func updateWidthConstraintToSPH() {
        self.adaptConstraint(constraintType: .Width, adaptType: .SPH)
    }

    //height
    open func updateHeightConstraintToSP() {
        self.adaptConstraint(constraintType: .Height, adaptType: .SP)
    }
    
    open func updateHeightConstraintToSPH() {
        self.adaptConstraint(constraintType: .Height, adaptType: .SPH)
    }

    //top
    open func updateTopConstraintToSP() {
        self.adaptConstraint(constraintType: .Top, adaptType: .SP)
    }
    
    open func updateTopConstraintToSPH() {
        self.adaptConstraint(constraintType: .Top, adaptType: .SPH)
    }

    //bottom
    open func updateBottomConstraintToSP() {
        self.adaptConstraint(constraintType: .Bottom, adaptType: .SP)
    }
    
    open func updateBottomConstraintToSPH() {
        self.adaptConstraint(constraintType: .Bottom, adaptType: .SPH)
    }
    
    ///set
    //left
    open func setLeftConstraint(constant: CGFloat) {
        self.setConstraint(constraintType: .Left, constant: constant)
    }
    
    //right
    open func setRightConstraint(constant: CGFloat) {
        self.setConstraint(constraintType: .Right, constant: constant)
    }
    
    //width
    open func setWidthConstraint(constant: CGFloat) {
        self.setConstraint(constraintType: .Width, constant: constant)
    }
    
    //height
    open func setHeightConstraint(constant: CGFloat) {
        self.setConstraint(constraintType: .Height, constant: constant)
    }
    
    //top
    open func setTopConstraint(constant: CGFloat) {
        self.setConstraint(constraintType: .Top, constant: constant)
    }
    
    //bottom
    open func setBottomConstraint(constant: CGFloat) {
        self.setConstraint(constraintType: .Bottom, constant: constant)
    }
        
    
    //font SHP
    open func updateFontToSPH() {
        self.updateFont(.SPH)
    }
    
    //font SP
    open func updateFontToSP() {
        self.updateFont(.SP)
    }
    

    
    private func adaptConstraint(constraintType: AdaptConstraint, adaptType: AdaptType) {
        var layoutAttribute: NSLayoutAttribute?
        switch constraintType {
        case .Left:
            layoutAttribute = .left
            guard !(self.isAllConstraintAdapted || isLeftConstraintAdapted) else {
                print("\(self): left constraint have adapted!")
                return
            }
            isLeftConstraintAdapted = true
        case .Right:
            layoutAttribute = .right
            guard !(isAllConstraintAdapted || isRightConstraintAdapted) else {
                print("\(self): right constraint have adapted!")
                return
            }
            isRightConstraintAdapted = true
        case .Width:
            layoutAttribute = .width
            guard !(isAllConstraintAdapted || isWidthConstraintAdapted) else {
                print("\(self): width constraint have adapted!")
                return
            }
            isWidthConstraintAdapted = true
        case .Height:
            layoutAttribute = .height
            guard !(isAllConstraintAdapted || isHeightConstraintAdapted) else {
                print("\(self): height constraint have adapted!")
                return
            }
            isHeightConstraintAdapted = true
        case .Top:
            layoutAttribute = .top
            guard !(isAllConstraintAdapted || isTopConstraintAdapted) else {
                print("\(self): top constraint have adapted!")
                return
            }
            isTopConstraintAdapted = true
        case .Bottom:
            layoutAttribute = .bottom
            guard !(isAllConstraintAdapted || isBottomConstraintAdapted) else {
                print("\(self): bottom constraint have adapted!")
                return
            }
            isBottomConstraintAdapted = true
        }

        if let superview = self.superview {
            var constraints = [NSLayoutConstraint]()
            constraints.append(contentsOf: superview.constraints)
            constraints.append(contentsOf: self.constraints)
            
            for constraint in constraints {
                var firstItem = constraint.firstItem
                if let secondItem = constraint.secondItem {
                    if firstItem is UIView && secondItem is UIView {
                        if (firstItem as! UIView) === (secondItem as! UIView).superview {
                            firstItem = secondItem
                        }
                    }
                }
                if firstItem === self {
                    if constraint.firstAttribute == layoutAttribute! ||
                       (constraint.firstAttribute == .leading && layoutAttribute! == .left) ||
                       (constraint.firstAttribute == .trailing && layoutAttribute! == .right) {
                        switch adaptType {
                        case .SP:
                            constraint.constant = SP(constraint.constant)
                        case .SPH:
                            constraint.constant = SPH(constraint.constant)
                        }
                    }
                }
            }
        }
    }
    
    private func setConstraint(constraintType: AdaptConstraint, constant: CGFloat) {
        var layoutAttribute: NSLayoutAttribute?
        switch constraintType {
        case .Left:
            layoutAttribute = .left
            isLeftConstraintAdapted = true
        case .Right:
            layoutAttribute = .right
            isRightConstraintAdapted = true
        case .Width:
            layoutAttribute = .width
            isWidthConstraintAdapted = true
        case .Height:
            layoutAttribute = .height
            isHeightConstraintAdapted = true
        case .Top:
            layoutAttribute = .top
            isTopConstraintAdapted = true
        case .Bottom:
            layoutAttribute = .bottom
            isBottomConstraintAdapted = true
        }
        
        if let superview = self.superview {
            var constraints = [NSLayoutConstraint]()
            constraints.append(contentsOf: superview.constraints)
            constraints.append(contentsOf: self.constraints)
            for constraint in constraints {
                if constraint.firstItem === self {
                    if constraint.firstAttribute == layoutAttribute! ||
                        (constraint.firstAttribute == .leading && layoutAttribute! == .left) ||
                        (constraint.firstAttribute == .trailing && layoutAttribute! == .right) {
                        constraint.constant = constant
                    }
                }
            }
        }
    }
    

    
}
