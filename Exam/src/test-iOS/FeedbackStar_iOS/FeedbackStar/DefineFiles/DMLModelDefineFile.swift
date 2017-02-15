//
//  DMLModelDefineFile.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/22.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit
import ObjectMapper

extension Mappable {
    public init?(dic: NSDictionary) {
        if let json = DMLDataEngine.dictionaryToString(dic) {
            if let obj: Self = Mapper(context: nil).map(JSONString: json) {
                self = obj
            } else {
                return nil
            }
        }else {
            return nil
        }
    }
}
