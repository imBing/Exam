//
//  DMLUserModels.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/18.
//  Copyright © 2016年 Daimler. All rights reserved.
//
import UIKit
import ObjectMapper

//MARK: ItemList
class ItemList: Mappable {
    var data: [ItemInfo]?
    var msg: String?
    var status: NSNumber?
    var time: NSNumber?
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        status <- map["status"]
        time <- map["time"]
    }
}

class ItemInfo: Mappable {
    var detailName: String?
    var commodityId: NSNumber?
    var shopPrice: NSNumber?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        detailName <- map["detailName"]
        commodityId <- map["commodityId"]
        shopPrice <- map["shopPrice"]
    }
}

class DMLUserModels: Mappable {
    var id: Int = 0
    var photoStr: String = ""
    var userName: String = ""
    var email: String = ""
    var department: String = ""
    
    var access_token:String = ""
    var country:String = ""
    var first_name = ""
    var last_name = ""
    var replied_status = ""

    required init?(map: Map) {
        
    }    
    func mapping(map: Map) {
        id <- map["id"]
        photoStr <- map["avatar"]
        userName <- map["name"]
        email <- map["email"]
        department <- map["department"]
        access_token <- map["access_token"]
        country <- map["country"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        replied_status <- map["replied_status"]
    }
  
}

class dataInfo: Mappable {
    var afterPayTip: String?
    var imGreetMessage: String?
    var rmark: [String]?
    var appAutoUpdateConfigure: UpDateModel?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        rmark <- map["rmark"]
        appAutoUpdateConfigure <- map["appAutoUpdateConfigure"]
        afterPayTip <- map["afterPayTip"]
        imGreetMessage <- map["imGreetMessage"]
    }
}

class UpDateModel: Mappable {
    var lastVersion: String?
    var forceUpdate: NSNumber?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lastVersion <- map["lastVersion"]
        forceUpdate <- map["forceUpdate"]
    }
}


//MARK: otherModel




