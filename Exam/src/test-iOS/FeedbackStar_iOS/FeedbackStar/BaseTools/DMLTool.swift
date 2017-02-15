//
//  DMLTool.swift
//  FeedbackStar
//
//  Created by Vin on 16/11/14.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

// 验证类型
enum ValidatedType {
    case Email
    case PhoneNumber
    case Password
}

class DMLTool: NSObject {
    // 邮箱验证
    class func validateEmail(vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.Email, validateString: vStr)
    }
    // 手机号验证
    class func validatePhoneNumber(vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.PhoneNumber, validateString: vStr)
    }

    // 密码验证
    class func validatePassword(vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.Password, validateString: vStr)
    }
    
    // 正则表达式
    class func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            if type == ValidatedType.Email {
                pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            }else if type == ValidatedType.PhoneNumber {
                pattern = "^1[0-9]{10}$"
            }else {
                pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }

}
