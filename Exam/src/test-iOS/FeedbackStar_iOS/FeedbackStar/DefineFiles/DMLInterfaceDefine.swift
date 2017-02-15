//
//  DMLInterfaceDefine.swift
//  FeedbackStar
//
//  Created by James Xu on 16/12/1.
//  Copyright © 2016年 Daimler. All rights reserved.
//

///////接口的定义///////

//接口类型：0、测试服务器接口  1、线上服务器接口 《请在此切换线上或测试接口》
/************************************/
private let INTERFACE_TYPE = 0
/************************************/

//域名定义
//线下
let TestBaseMainUrl = ""
let TestLoginMainUrl = "//add host here"

//线上
let OnLineBaseMainUrl = ""
let OnLineLoginMainUrl = ""

//测试版本名称定义
var testVersion: String? = {
    switch (INTERFACE_TYPE) {
    case 0:
        return "T000001—sevice.api"
    default:
        return nil
    }
}()

// 其他接口baseUrl
private var MAIN_URL_BASE: String = {
    switch (INTERFACE_TYPE) {
    case 0:
        return TestBaseMainUrl
    case 1:
        return OnLineBaseMainUrl
    default:
        return ""
    }
}()

// 登录相关baseUrl
private var MAIN_URL_LOGIN: String = {
    switch (INTERFACE_TYPE) {
    case 0:
        return TestLoginMainUrl
    case 1:
        return OnLineLoginMainUrl
    default:
        return ""
    }
}()


///详细接口定义
//Feedback纬度列表
let FBS_API_FEEDBACK_MOMENTS = MAIN_URL_BASE + "moments"
let FBS_API_FEEDBACK_MOMENTS_DETAIL = MAIN_URL_BASE + "moments/"
let FBS_API_DIMENSION_LIST = MAIN_URL_BASE + "evaluative_dimensions"
let FBS_API_FEEDBACK_REQUESTS = MAIN_URL_BASE + "feedback_requests"
let UPLOAD_IMAGES = MAIN_URL_BASE + "images"
let FBS_API_FEEDBACK_REQUESTS_DETAIL = MAIN_URL_BASE + "feedback_requests/"
let FBS_API_FEEDBACK_COMMENT = MAIN_URL_BASE + "feedback"
let FBS_API_FEEDBACK_MESSAGES = MAIN_URL_BASE + "messages"
let FBS_API_FEEDBACK_MESSAGES_DETAIL = MAIN_URL_BASE + "messages/"
let FBS_API_FEEDBACK_MESSAGES_POPUP = MAIN_URL_BASE + "messages/pop_up?detail=true"

let FBS_API_UNREAD_MESSAGES = MAIN_URL_BASE + "messages/unread_quantity"

//niceoneShow
let FBS_API_NICEONE_SHOW = MAIN_URL_BASE + "messages/pop_up?type=unread_nice_one"

// 登录注册
let ONE_AUTH_API_USER = MAIN_URL_LOGIN + "user"
let ONE_AUTH_API_VALIDATION_CODE = MAIN_URL_LOGIN + "validation_code"
//uploadimage
let UPLOAD_IMAGE = MAIN_URL_LOGIN + "images"
//updateprofile
let ONE_AUTH_API_PROFILE =  MAIN_URL_LOGIN + "user/profile"
//me-profile
let FBS_API_USER = MAIN_URL_BASE + "user"
//login
let ONE_AUTH_API_ACCESS_TOKENS = MAIN_URL_LOGIN + "access_tokens"
let ONE_AUTH_API_ACCESS_TOKENS_LOGOUT = MAIN_URL_BASE + "access_tokens"


// Colleage
let FBS_API_NICE_ONE_LABELS = MAIN_URL_BASE + "nice_one_labels"
let FBS_API_NICE_ONE = MAIN_URL_BASE + "nice_one"
let FBS_API_USERS = MAIN_URL_BASE + "users"
let FBS_API_COLLEAGUES = MAIN_URL_BASE + "colleagues"

// GIVE A FEEDBACK
let FBS_API_FEEDBACK = MAIN_URL_BASE + "feedback"

//jinshuju_FeedbackUrl
let DML_API_COMMON_JINSHUJU = "https://jinshuju.net/f/PLIW6E"






