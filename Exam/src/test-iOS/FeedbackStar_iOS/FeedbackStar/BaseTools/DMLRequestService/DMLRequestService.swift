//
//  DMLRequestService.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/13.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit
import AFNetworking
import ReachabilitySwift

/*
 1、url:错误，错误码：-1002
 2、网络断开，错误码：-1009
 3、网络超时，错误码：-1001
 */

let DMLTimeoutInterval: TimeInterval = 30

//网络请求类型
enum HTTPMethed: Int {
    case GET = 0
    case POST = 1
    case PUT = 2
    case DELETE = 3
}

//错误类型
enum DMLErrorCode: Int {
    case dmlErrorCodeDefaultNone      =   600000
    case dmlNetWorkDisConnectError    =   600001
    case dmlNetWorkTimeOutError       =   600002
    case dmlServiceConnectionError    =   600003
    case dmlDataAnalysisError         =   600004
    case dmlRequestCancel             =   600005
    
    var isNetWorkError: Bool {
        switch self {
        case .dmlNetWorkDisConnectError, .dmlNetWorkTimeOutError:
            return true
        default:
            return false
        }
    }
    
    var describeTip: String {
        switch self {
        case .dmlNetWorkDisConnectError:
            return "Network connection failed!"
        case .dmlNetWorkTimeOutError:
            return "Network connection timeout!"
        case .dmlServiceConnectionError:
            return "Server connection failed!"
        case .dmlDataAnalysisError:
            return "Server connection failed!"
        case .dmlRequestCancel:
            return "Cancel network request!"
        default:
            return ""
        }
    }
    
    
    func description() {
        DPrint(self.describeTip)
    }
}

enum DMLNetWorkError {
    case dmlNetWorkDisConnectError
    case dmlNetWorkTimeOutError
}

class DMLResponse: NSObject {
    var dic: NSDictionary = NSDictionary()
    var sysCode: Int?
    var error: Error?
    var describeTip: String?
    var errorCode: DMLErrorCode = .dmlErrorCodeDefaultNone
    var isDataEmpty: Bool = true
    var isFromCache = false
    
    var jsonString: String {
        let string = DMLDataEngine.dictionaryToString(self.dic)
        if let string = string {
            return string
        }else {
            return ""
        }
    }
    
    var errorMessage: String {
        return self.errorCode.describeTip
    }
    
    func containsError(_ errorCode: Int) -> Bool {
        if let describeTip = self.describeTip {
            if describeTip.contains("(\(errorCode))") {
                return true
            }
        }
        return false
    }
    
    //正确时处理
    func sucess(_ doSomething: () -> ()) {
        if self.errorCode == .dmlErrorCodeDefaultNone {
            doSomething()
        }
    }
    
    //错误时处理
    func failure(_ doSomething: () -> ()) {
        if self.errorCode != .dmlErrorCodeDefaultNone {
            doSomething()
        }
    }

    
    override var description: String {
        get {
            return "[Description:DMLResponse]---->Start\n" + "dic:\(dic)\n" + "sysCode:\(sysCode)\n" + "errorCode:\(errorCode)\n" + "isDataEmpty:\(isDataEmpty)\n" + "isFromCache:\(isFromCache)\n" + "describeTip:\(describeTip)\n[Description:DMLResponse]---->End\n"
        }
    }
    
    func descriptionPrint() {
        DPrint(self.description)
    }
}

//fixme xu
class Request {
    
}

class DMLRequest: NSObject {
    static var requestList = [String: URLSessionDataTask]()
    static var isReachable: Bool {
        let isReachable =  Reachability()?.isReachable
        if let isReachable = isReachable, !isReachable {
            return true
        }
        return false
    }
    
    // Get
   open class func startGetRequest(_ urlStr: String, _ response: @escaping (DMLResponse) -> ()) {
        self.startGetRequest(urlStr, false, response)
    }
    
    open class func startGetRequest(_ urlStr: String, _ isNeedCache: Bool, _ response: @escaping (DMLResponse) -> ()) {
        self.startGetRequest(urlStr, isNeedCache, nil, response)
    }
    
    open class func startGetRequest(_ urlStr: String, _ isNeedCache: Bool, _ httpHeaders: [String: String]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startRequest(.GET, urlStr, nil, isNeedCache, httpHeaders, response)
    }
    
    
    // Post
    open class func startPostRequest(_ urlStr: String, _ response: @escaping (DMLResponse) -> ()) {
        self.startPostRequest(urlStr, nil, response)
    }
    
    open class func startPostRequest(_ urlStr: String, _ parameters: [String: Any]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startPostRequest(urlStr, parameters, false, nil, response)
    }
    
    open class func startPostRequest(_ urlStr: String, _ parameters: [String: Any]? , _ isNeedCache: Bool, _ httpHeaders: [String: String]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startRequest(.POST, urlStr, parameters, isNeedCache, httpHeaders, response)
    }
    
    // Put
    open class func startPutRequest(_ urlStr: String, _ response: @escaping (DMLResponse) -> ()) {
        self.startPutRequest(urlStr, nil, response)
    }
    
    open class func startPutRequest(_ urlStr: String, _ parameters: [String: Any]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startPutRequest(urlStr, parameters, false, nil, response)
    }
    
    open class func startPutRequest(_ urlStr: String, _ parameters: [String: Any]? , _ isNeedCache: Bool, _ httpHeaders: [String: String]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startRequest(.PUT, urlStr, parameters, isNeedCache, httpHeaders, response)
    }
    
    // Delete
    open class func startDeleteRequest(_ urlStr: String, _ response: @escaping (DMLResponse) -> ()) {
        self.startDeleteRequest(urlStr, nil, response)
    }
    
    open class func startDeleteRequest(_ urlStr: String, _ parameters: [String: Any]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startDeleteRequest(urlStr, parameters, false, nil, response)
    }
    
    open class func startDeleteRequest(_ urlStr: String, _ parameters: [String: Any]? , _ isNeedCache: Bool, _ httpHeaders: [String: String]?, _ response: @escaping (DMLResponse) -> ()) {
        self.startRequest(.DELETE, urlStr, parameters, isNeedCache, httpHeaders, response)
    }
    
 
     //fixme liu
    open class  func DMLuploadImages( _ urlString : String, _ images : [UIImage],_ response:@escaping(DMLResponse) ->()){
        self .upLoadImage(.POST, urlString, images,  response)
        
    }
    

    //uploadview- Request
    
    private class func upLoadImage(_ method : HTTPMethed, _ urlStr:String,_ images : [UIImage],  _ response:@escaping(DMLResponse) -> ()){
    
        guard self.requestList[urlStr] == nil else {
            return
        }
        if self.isReachable {
            let dmlResponse = DMLResponse()
            dmlResponse.isFromCache = false
            dmlResponse.isDataEmpty = true
            dmlResponse.errorCode = .dmlNetWorkDisConnectError
            response(dmlResponse)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager: AFHTTPSessionManager = AFHTTPSessionManager()
        manager.securityPolicy =  AFSecurityPolicy(pinningMode: .none)
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.responseSerializer = AFJSONResponseSerializer()

        var dataTask: URLSessionDataTask?

            dataTask = manager.post(urlStr, parameters: nil, constructingBodyWith: { (formData) in
                for image in images {
//                    let imageData = UIImagePNGRepresentation(image)
                    let imageData = UIImageJPEGRepresentation(image,0.5)
                    formData.appendPart(withFileData: imageData!, name: "file", fileName: "filename", mimeType: "imgae/jpeg")
                }
                
                }, progress: nil, success: { (dataTask, receiveObject) in
                    
                    self.responseParse(urlStr, false, nil, receiveObject, response)
                }, failure: { (dataTask, receiveError) in
                    
                    self.responseParse(urlStr, false, receiveError, nil, response)
            })

        self.requestList[urlStr] = dataTask

    }
    
    
    //MainRequest
    private class func startRequest(_ method: HTTPMethed, _ urlStr: String, _ parameters: [String: Any]?, _ isNeedCache: Bool,  _ httpHeaders: [String: String]?, _ response: @escaping (DMLResponse) -> ()) {
        
        guard self.requestList[urlStr] == nil else {
            return
        }
        
        if isNeedCache && self.isLocalDataExisted(urlStr) {
            let data = self.getLocalData(urlStr)
            let dmlResponse = DMLResponse()
            dmlResponse.isFromCache = true
            
            if let data = data, let dic = DMLDataEngine.dataToDictionary(data) {
                dmlResponse.dic = dic
                dmlResponse.isDataEmpty = false
                response(dmlResponse)
            }
        }
        
        if self.isReachable {
            let dmlResponse = DMLResponse()
            dmlResponse.isFromCache = false
            dmlResponse.isDataEmpty = true
            dmlResponse.errorCode = .dmlNetWorkDisConnectError
            response(dmlResponse)
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let manager: AFHTTPSessionManager = AFHTTPSessionManager()
        manager.securityPolicy =  AFSecurityPolicy(pinningMode: .none)

        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.timeoutInterval = DMLTimeoutInterval

        manager.responseSerializer = AFJSONResponseSerializer()

        //httpheaders set
        if let httpHeaders = httpHeaders {
            for key in httpHeaders.keys {
                manager.requestSerializer.setValue(httpHeaders[key], forHTTPHeaderField: key)
            }
        }
        
        //fixme xu
        //access_token
        if manager.requestSerializer.value(forHTTPHeaderField: "Authorization") == nil {
            if let token = UserDefaults.standard.value(forKey: userTokenKey), let email = UserDefaults.standard.value(forKey: emailNameKey) {
                let tokenStr = "\(email)" + ":" + "\(token)"
                let utf8EncodeData = tokenStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
                // 将NSData进行Base64编码
                let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
                let Authorization = "Basic" + " " + base64String!
                
//                print(Authorization)
                manager.requestSerializer.setValue(Authorization, forHTTPHeaderField: "Authorization")
            }
        }

        var dataTask: URLSessionDataTask?
        
        switch method {
        case .GET:
            
            dataTask = manager.get(urlStr, parameters: parameters, progress: nil, success: { (task, receiveObject) in
                self.responseParse(urlStr, isNeedCache, nil, receiveObject, response)
                }, failure: { (task, receiveError) in
                    self.responseParse(urlStr, isNeedCache, receiveError, nil, response)
            })
            
        case .POST:
            
            dataTask = manager.post(urlStr, parameters: parameters, progress: nil, success: { (task, receiveObject) in
                self.responseParse(urlStr, isNeedCache, nil, receiveObject, response)
                }, failure: { (task, receiveError) in
                    self.responseParse(urlStr, isNeedCache, receiveError, nil, response)
            })
            
            
        case .PUT:
            
            dataTask = manager.put(urlStr, parameters: parameters, success: { (task, receiveObject) in
                self.responseParse(urlStr, isNeedCache, nil, receiveObject, response)
                }, failure: { (task, receiveError) in
                    self.responseParse(urlStr, isNeedCache, receiveError, nil, response)
            })
            
        case .DELETE:
            
            dataTask = manager.delete(urlStr, parameters: parameters, success: { (task, receiveObject) in
                self.responseParse(urlStr, isNeedCache, nil, receiveObject, response)
                }, failure: { (task, receiveError) in
                    self.responseParse(urlStr, isNeedCache, receiveError, nil, response)
            })
        }
        
        self.requestList[urlStr] = dataTask
    }
    
    //Deal responds
   fileprivate class func responseParse(_ urlStr: String, _ isNeedCache: Bool, _ error: Error?, _ receiveObject: Any? ,_ response: @escaping (DMLResponse) -> ()) {
        let dmlResponse = DMLResponse()
    if error is NSError {
        let err: NSError = error as! NSError
        dmlResponse.sysCode = err.code
        dmlResponse.describeTip = error?.localizedDescription
    }

    
        if let error = error {
            let key = AFNetworkingOperationFailingURLResponseDataErrorKey
            let dic: NSDictionary = error._userInfo as! NSDictionary
            let obj = dic.object(forKey: key)
            if let obj = obj, obj is Data {
                let data: Data = obj as! Data
                let responseObj = DMLDataEngine.dataToDictionary(data)
                if let responseObj = responseObj {
                    dmlResponse.isDataEmpty = false
                    dmlResponse.dic = responseObj
                }
            }

            dmlResponse.error = error
            if dmlResponse.sysCode ==  NSURLErrorTimedOut {
                dmlResponse.errorCode = .dmlNetWorkTimeOutError
            } else if dmlResponse.sysCode ==  NSURLErrorNetworkConnectionLost{
                dmlResponse.errorCode = .dmlNetWorkDisConnectError
            }else {
                dmlResponse.errorCode = .dmlServiceConnectionError
            }
        }else {
            if let dic = receiveObject, receiveObject is NSDictionary {
                dmlResponse.isDataEmpty = false
                dmlResponse.dic = dic as! NSDictionary
                
                let data = DMLDataEngine.dictionaryToData(dmlResponse.dic)
                
                if isNeedCache, let data = data {
                    let _ = self.writeToCache(urlStr, responseData: data)
                }
            }else {
                dmlResponse.errorCode = .dmlDataAnalysisError
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        if let _ = self.requestList[urlStr] {
            //reload account
            if dmlResponse.containsError(ERROR_CODE_401) {
                if urlStr.contains(ONE_AUTH_API_USER) ||
                   urlStr.contains(ONE_AUTH_API_VALIDATION_CODE) ||
                   urlStr.contains(ONE_AUTH_API_VALIDATION_CODE) {
                }else {
                    if APP_IS_LOGIN {
                        APPManager.logOut()
                        self.requestList.removeValue(forKey: urlStr)
                        return
                    }
                }
            }
            self.requestList.removeValue(forKey: urlStr)
            response(dmlResponse)
        }else {
            dmlResponse.errorCode = .dmlRequestCancel
        }
    }
    
    class func CancelRequest(_ urlStr: String) {
        let request = self.requestList[urlStr]
        request?.cancel()
        self.requestList.removeValue(forKey: urlStr)
    }
    
    class func CancelAllRequest() {
        for key in self.requestList.keys {
            self.CancelRequest(key)
        }
    }
}


//MARK: 全局方法
//Get
func DMLRequestGetService(_ urlStr: String,  isNeedCache: Bool = false, _ response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startGetRequest(urlStr, isNeedCache, response)
}

func DMLRequestGetService(_ urlStr: String, isNeedCache: Bool = false, _ httpHeaders: [String: String], _ response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startGetRequest(urlStr, isNeedCache, httpHeaders, response)
}

//Post
func DMLRequestPostService(_ urlStr: String, response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startPostRequest(urlStr, response)
}

func DMLRequestPostService(_ urlStr: String,  _ parameters: [String: Any]?, _ response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startPostRequest(urlStr, parameters, response)
}

func DMLRequestPostService(_ urlStr: String, _ parameters: [String: Any]?,  isNeedCache: Bool = false, _ httpHeaders: [String: String]? ,  response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startPostRequest(urlStr, parameters, isNeedCache, httpHeaders, response)
}

//上传图片
func DMLRequestUpLoadImages( _ urlString : String, _ images : [UIImage],_ response:@escaping(DMLResponse) ->()){
    DMLRequest.DMLuploadImages(urlString, images, response)
}



//Put
func DMLRequestPutService(_ urlStr: String, response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startPutRequest(urlStr, response)
}

func DMLRequestPutService(_ urlStr: String,  _ parameters: [String: Any]?, _ response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startPutRequest(urlStr, parameters, response)
}

func DMLRequestPutService(_ urlStr: String, _ parameters: [String: Any]?, isNeedCache: Bool = false, _ httpHeaders: [String: String]? ,  response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startPutRequest(urlStr, parameters, isNeedCache, httpHeaders, response)
}


//Delete
func DMLRequestDeleteService(_ urlStr: String, response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startDeleteRequest(urlStr, response)
}

func DMLRequestDeleteService(_ urlStr: String,  _ parameters: [String: Any]?, _ response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startDeleteRequest(urlStr, parameters, response)
}

func DMLRequestDeleteService(_ urlStr: String, _ parameters: [String: Any]?, isNeedCache: Bool = false, _ httpHeaders: [String: String]? ,  response: @escaping (DMLResponse) -> ()) {
    DMLRequest.startDeleteRequest(urlStr, parameters, isNeedCache, httpHeaders, response)
}

//Cancel
func DMLRequestServiceCancel(_ urlStr: String) {
    DMLRequest.CancelRequest(urlStr)
}

func DMLRequestServiceAllCancel() {
    DMLRequest.CancelAllRequest()
}





