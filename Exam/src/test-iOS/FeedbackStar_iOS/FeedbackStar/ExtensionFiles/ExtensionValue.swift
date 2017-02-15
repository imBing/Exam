//
//  ExtensionValue.swift
//  bailumei
//
//  Created by xuqingqing on 16/7/22.
//  Copyright © 2016年 LKZ. All rights reserved.
//

import Foundation
import UIKit

//数据类型转换
extension NSObject {
    var protectedValue: NSObject {
        if self is NSNull {
            return "" as NSObject
        }else if self is String {
            if (self as! String).isBlank {
                return "" as NSObject
            }
        }
        return self
    }
}

extension String {
    var numValue: NSNumber {
        if self.isBlank {
            return 0
        }
        return NSNumber(value: Double(self)! as Double)
    }
    
    var intValue: Int {
        if self.isBlank {
            return 0
        }
        return Int(Double(self)!)
    }
    
    var floatValue: CGFloat {
        if self.isBlank {
            return 0
        }
        return CGFloat(Double(self)!)
    }
    
    var isBlank: Bool {
        if self.isEmpty {
            return true
        }
        if self == "(null)" || self == "" {
            return true
        }
        return false
    }
    
    var isValid: Bool {
        return !self.isBlank
    }
    
    var MD5: String {
        let cString = self.cString(using: String.Encoding.utf8)
        let length = CUnsignedInt(
            self.lengthOfBytes(using: String.Encoding.utf8)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(
            capacity: Int(CC_MD5_DIGEST_LENGTH)
        )
        
        CC_MD5(cString!, length, result)
        
        return String(format:
            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15])
    }
}

extension NSNumber {
    var IntValue: Int {
        return Int(self)
    }
}

extension Int {
    // 下标[n]会返回十进制数字从右向左第n个数字
    subscript(index: Int) -> Int {
        var decimalBase = 1
        for _ in 1...index {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

extension Double {
    //接口中价格为Double类型时需要标准化处理
    var moneyVlaue: String {
        //负数时的处理
        var symbol = ""
        if self < 0 {
            symbol = "-"
        }
        var money = fabs(self)
        if money != 0 {
            money += 0.001;
        }
        
        let rem1 = (Int(money * 10)) % 10
        let rem2 = (Int(money * 100)) % 10
        
        if rem2 > 0 {
            return symbol +  String(format: "%.2f", money)
        }else if rem1 > 0 {
            return symbol +  String(format: "%.1f", money)
        }else {
            return symbol +  String(format: "%d", Int(money))
        }
    }
}

//适配
extension Int {
    var s: CGFloat {
        return SPH(CGFloat(self))
    }
    
    var f: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    var s: CGFloat {
        return SPH(self)
    }
}

extension Double {
    var s: CGFloat {
        return SPH(CGFloat(self))
    }
}




