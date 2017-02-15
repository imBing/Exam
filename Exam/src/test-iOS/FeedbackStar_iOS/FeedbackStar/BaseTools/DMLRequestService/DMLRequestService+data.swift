//
//  DMLRequestService+data.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/14.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit

//Data Cache
extension DMLRequest {
    class func writeToCache(_ relativeUrlPath: String?, responseData: Data) -> Bool {
        guard let urlPath = relativeUrlPath , urlPath.isValid else {
            return false
        }
        let fullPath = self.getAbsoluteCachePathWithUrl(urlPath)
        guard let path = fullPath else {
            return false
        }
        
        let bResult = (try? responseData.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        if !bResult {
            print("write failed...")
        }
        return bResult
    }
    
    class func getAbsoluteCachePathWithUrl(_ relativeUrlPath: String) -> String? {
        let dirPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let dirPathUrl = URL(string: dirPath)
        let cacheUrlPath = dirPathUrl?.appendingPathComponent("cacheUrlData")
        guard let urlPath = cacheUrlPath else {
            return nil
        }
        
        let fileMgr = FileManager.default
        var isSuccess = true
        if !fileMgr.fileExists(atPath: urlPath.absoluteString) {
            do {
                try fileMgr.createDirectory(atPath: urlPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch (let error) {
                isSuccess = false
                print(error)
            }
        }
        
        if isSuccess {
            return urlPath.absoluteString + "/" + relativeUrlPath.MD5 + ".ms"
        }
        return nil
    }
    
    class func isLocalDataExisted(_ relativeUrlPath: String) -> Bool {
        if relativeUrlPath.isValid {
            let fullPath = self.getAbsoluteCachePathWithUrl(relativeUrlPath)
            if let fullPath = fullPath {
                if FileManager.default.fileExists(atPath: fullPath) {
                    return true
                }
            }
        }
        return false
    }
    
    class func getLocalData(_ relativeUrlPath: String) -> Data? {
        let fullPath = self.getAbsoluteCachePathWithUrl(relativeUrlPath)

        if self.isLocalDataExisted(relativeUrlPath), let fullPath = fullPath {
            do {
               return try Data(contentsOf: URL(fileURLWithPath: fullPath), options: .mappedIfSafe)
            } catch (let error) {
                print(error)
            }
        }
        return nil
    }
}
