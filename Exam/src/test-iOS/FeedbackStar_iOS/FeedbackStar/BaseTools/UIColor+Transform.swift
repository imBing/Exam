//
//  UIColor+Transform.swift
//  FeedbackStar
//
//  Created by James Xu on 16/10/11.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

//String-Color
func HEXCOLOR(_ string: String) -> UIColor {
    if string.characters.count == 6 {
        var red: CUnsignedInt? = 0, green: CUnsignedInt? = 0, blue: CUnsignedInt? = 0
        
        let range1 = string.startIndex..<string.characters.index(string.startIndex, offsetBy: 2)
        let range2 = string.characters.index(string.startIndex, offsetBy: 2)..<string.characters.index(string.startIndex, offsetBy: 4)
        let range3 = string.characters.index(string.startIndex, offsetBy: 4)..<string.characters.index(string.startIndex, offsetBy: 6)
        
        let _ = (Scanner.localizedScanner(with: string.substring(with: range1)) as AnyObject).scanHexInt32(&red!)
        let _ = (Scanner.localizedScanner(with: string.substring(with: range2)) as AnyObject).scanHexInt32(&green!)
        let _ = (Scanner.localizedScanner(with: string.substring(with: range3)) as AnyObject).scanHexInt32(&blue!)
        
        return RGB(CGFloat(red!), CGFloat(green!), CGFloat(blue!))
    }
    return UIColor.clear
}
