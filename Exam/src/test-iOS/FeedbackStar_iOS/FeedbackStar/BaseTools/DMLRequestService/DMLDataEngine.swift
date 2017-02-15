//
//  DMLDataEngine.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/14.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

class DMLDataEngine: NSObject {
    class func dataToDictionary(_ data: Data) -> NSDictionary? {
        do {
            let dic =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if dic is NSDictionary {
                return dic as? NSDictionary
            }else {
                print("Data is not a dictionary, check it!")
                return nil
            }
        } catch (let error) {
            print("error:\(error)")
            return nil
        }
    }
    
    class func dictionaryToData(_ dic: NSDictionary) -> Data? {
        do {
            let data =  try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            return data
        } catch (let error) {
            print("error:\(error)")
            return nil
        }
    }

    
    class func dictionaryToString(_ dic: NSDictionary) -> String? {
        let data = self.dictionaryToData(dic)
        if let data = data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    class func nsDictionaryWith(dic: [String: String]) -> NSDictionary {
        let ret = NSMutableDictionary()
        for key in dic.keys {
            let dicValue: NSString = dic[key]! as NSString
            let dicKey: NSString = key as NSString
            ret.setObject(dicValue, forKey: dicKey)
        }
        return ret
    }

    
    class func stringToDictionary(_ json: String) -> NSDictionary? {
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return self.dataToDictionary(data)
        } catch (let error) {
            print("error:\(error)")
            return nil
        }
    }
    
    class func getRowCount(_ itemsCount: Int, _ maxColumnCount: Int) -> Int {
        var rowCount: Int = 0
        if itemsCount > 0 {
            rowCount = (itemsCount - 1) / maxColumnCount + 1
        }
        return rowCount
    }
    
    class func getLastRowItemsCount(_ itemsCount: Int, _ maxColumnCount: Int) -> Int {
        var count: Int = 0
        if itemsCount > 0 {
            count = (itemsCount - 1) % maxColumnCount + 1
        }
        return count
    }
    
}
