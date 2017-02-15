//
//  ExtensionString+label.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/2.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

extension String {
    
    //MARK: Label-Height Width
    func getLabelHeight(_ fontSize: CGFloat, _ width: CGFloat) -> CGFloat {
        let dict = NSDictionary(object: GetFont(fontSize), forKey: NSFontAttributeName as NSCopying) as! [String : AnyObject]
        let str: NSString = NSString(string: self.protectedValue as! String)
        let rect = str.boundingRect(with: CGSize(width: width, height: 9999), options: .usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.height + 2
    }
    
    func getLabelWidth(_ fontSize: CGFloat, _ height: CGFloat) -> CGFloat {
        let dict = NSDictionary(object: GetFont(fontSize), forKey: NSFontAttributeName as NSCopying) as! [String : AnyObject]
        let str: NSString = NSString(string: self.protectedValue as! String)
        let rect = str.boundingRect(with: CGSize(width: 9999, height: height), options: .usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width + 2
    }
    
    func getBoldLabelHeight(_ fontSize: CGFloat, _ width: CGFloat) -> CGFloat {
        let dict = NSDictionary(object: GetBoldFont(fontSize), forKey: NSFontAttributeName as NSCopying) as! [String : AnyObject]
        let str: NSString = NSString(string: self.protectedValue as! String)
        let rect = str.boundingRect(with: CGSize(width: width, height: 9999), options: .usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.height + 2
    }
    
    func getBoldLabelWidth(_ fontSize: CGFloat, _ height: CGFloat) -> CGFloat {
        let dict = NSDictionary(object: GetBoldFont(fontSize), forKey: NSFontAttributeName as NSCopying) as! [String : AnyObject]
        let str: NSString = NSString(string: self.protectedValue as! String)
        let rect = str.boundingRect(with: CGSize(width: 9999, height: height), options: .usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width + 2
    }
}

extension UILabel {
    func autoAdaptWidth() {
        var width: CGFloat = 0
        if let text = self.text {
            if self.font.fontName.contains("bold") {
                width = text.getBoldLabelWidth(self.font.pointSize, self.height)
            }else {
                width = text.getLabelWidth(self.font.pointSize, self.height)
            }
        }
        self.width = width
    }
    
    func autoAdaptHeight() {
        var height: CGFloat = 0
        if let text = self.text {
            if self.font.fontName.contains("bold") {
                height = text.getBoldLabelHeight(self.font.pointSize, self.width)
            }else {
                height = text.getLabelHeight(self.font.pointSize, self.width)
            }
        }
        self.height = height
    }
}
