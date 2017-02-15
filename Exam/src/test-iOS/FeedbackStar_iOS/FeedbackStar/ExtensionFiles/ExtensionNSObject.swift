//
//  ExtensionNSObject.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/29.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

extension NSObject {
    open func perform(DelayTime: TimeInterval, _ aClouser: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DelayTime) {
            aClouser()
        }
//        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: DispatchTime.now() + 2) {
//            DispatchQueue.main.sync {
//                
//            }
//        }
    }
}
