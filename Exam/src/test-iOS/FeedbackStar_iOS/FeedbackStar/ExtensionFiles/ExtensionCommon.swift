//
//  ExtensionCommon.swift
//  FeedbackStar
//
//  Created by James Xu on 16/11/24.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

extension UIApplication {
    class func resignFirstResponder()  {
    UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
