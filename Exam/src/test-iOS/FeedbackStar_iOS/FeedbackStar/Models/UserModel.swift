//
//  UserModel.swift
//  FeedbackStar
//
//  Created by ya Liu on 2016/12/27.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit
import ObjectMapper
class UserModel: Mappable {
    var dict:UserProfile?
    var token:String = ""
    required init?(map: Map) {
    }
    func mapping(map: Map) {
     token <- map["access_token"]
    }
}

class UserProfile: Mappable {
    var avatar:String = ""
    var country:String = ""
    var department:String = ""
    var email:String = ""
    var firstName:String = ""
    var lastName:String = ""
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        avatar <- map["avatar"]
        country <- map["country"]
        department <- map["department"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
    }
}
