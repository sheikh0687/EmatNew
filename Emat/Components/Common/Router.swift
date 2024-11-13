//
//  Router.swift
//  HalaMotor
//
//  Created by mac on 22/08/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

let strType = USER_DEFAULT.value(forKey: USER_TYPE) as! String

enum Router: String {
    
    static let BASE_SERVICE_URL = "http://techimmense.com/PROJECT/EMAT/webservice/"
    static let BASE_IMAGE_URL = "http://techimmense.com/PROJECT/EMAT/webservice/"
    
    case logIn
    case signUp
    case category_list
    case forgot_password
    case get_profile
    case update_profile
    case changepass
    case updateprofile
    case get_news_latest_list
    case get_Regions_case_list
    case get_news_list
    case get_question_list
    case add_user_test
    case get_test_starting
    case get_preventions_list
    case get_books
    case get_faq_list
    case verify_number
    case get_user_test_list
    case get_reasons_list
    case get_conversation_detail
    case insert_chat
    case get_chat_detail
    case get_active_doctor_list
    case get_conversation_history_detail
    case get_news_press_list
    case end_chat_status
    case start_chat_status
    case get_cadre
    case get_Institution
    case get_drugs
    case get_STG_format
    case get_Guideline
    case mail_for_activation
    case update_available_status
    case delete_conversation
    case get_user_details
    case get_Regions_list
    case get_Region_hotline
    case get_Region_conferences
    case get_Region_training
    
    public func url() -> String {
        switch self {
        case .logIn:
            return Router.oAuthRoute(path: "login?")
        case .signUp:
            return Router.oAuthRoute(path: "signup?")
        case .category_list:
            return Router.oAuthRoute(path: "category_list")
        case .forgot_password:
            return Router.oAuthRoute(path: "forgot_password")
        case .get_profile:
            return Router.oAuthRoute(path: "get_profile")
        case .update_profile:
            return Router.oAuthRoute(path: "update_profile")
        case .changepass:
            return Router.oAuthRoute(path: "change_password?")
        case .updateprofile:
            return Router.oAuthRoute(path: "updateprofile")
        case .get_news_latest_list:
            return Router.oAuthRoute(path: "get_news_latest_list?")
        case .get_Regions_case_list:
            return Router.oAuthRoute(path: "get_Regions_case_list?")
        case .get_news_list:
            return Router.oAuthRoute(path: "get_news_list?")
        case .get_question_list:
            return Router.oAuthRoute(path: "get_question_list?")
        case .add_user_test:
            return Router.oAuthRoute(path: "add_user_test?")
        case .get_test_starting:
            return Router.oAuthRoute(path: "get_test_starting?")
        case .get_preventions_list:
            if USER_DEFAULT.value(forKey: USER_TYPE) as! String == PATIENT {
                return Router.oAuthRoute(path: "get_preventions_list?")
            } else {
                return Router.oAuthRoute(path: "get_doctor_preventions_list?")
            }
        case .get_books:
            return Router.oAuthRoute(path: "get_books?")
        case .get_faq_list:
            if USER_DEFAULT.value(forKey: USER_TYPE) as! String == PATIENT {
                return Router.oAuthRoute(path: "get_faq_list?")
            } else {
                return Router.oAuthRoute(path: "get_doctor_faq_list?")
            }
        case .verify_number:
            return Router.oAuthRoute(path: "verify_number?")
        case .get_user_test_list:
            return Router.oAuthRoute(path: "get_user_test_list?")
        case .get_reasons_list:
            return Router.oAuthRoute(path: "get_reasons_list?")
        case .get_conversation_detail:
            return Router.oAuthRoute(path: "get_conversation_detail?")
        case .insert_chat:
            return Router.oAuthRoute(path: "insert_chat?")
        case .get_chat_detail:
            return Router.oAuthRoute(path: "get_chat_detail?")
        case .get_active_doctor_list:
            return Router.oAuthRoute(path: "get_online_specialist_list?")
        case .get_conversation_history_detail:
            return Router.oAuthRoute(path: "get_conversation_history_detail?")
        case .get_news_press_list:
            return Router.oAuthRoute(path: "get_news_press_list?")
        case .end_chat_status:
            return Router.oAuthRoute(path: "end_chat_status?")
        case .start_chat_status:
            return Router.oAuthRoute(path: "start_chat_status?")
        case .get_cadre:
            return Router.oAuthRoute(path: "get_cadre?")
        case .get_Institution:
            return Router.oAuthRoute(path: "get_Institution?")
        case .get_drugs:
            return Router.oAuthRoute(path: "get_drugs?")
        case .get_STG_format:
            return Router.oAuthRoute(path: "get_STG_format?")
        case .get_Guideline:
            return Router.oAuthRoute(path: "get_Guideline?")
        case .mail_for_activation:
            return Router.oAuthRoute(path: "mail_for_activation?")
        case .update_available_status:
            return Router.oAuthRoute(path: "update_available_status?")
        case .delete_conversation:
            return Router.oAuthRoute(path: "delete_conversation?")
        case .get_user_details:
            return Router.oAuthRoute(path: "get_user_details?")
        case .get_Regions_list:
            return Router.oAuthRoute(path: "get_Regions_list_new?")
        case .get_Region_hotline:
            return Router.oAuthRoute(path: "get_Region_hotline?")
        case .get_Region_conferences:
            return Router.oAuthRoute(path: "get_Region_conferences?")
        case .get_Region_training:
            return Router.oAuthRoute(path: "get_Region_training?")
        }
    }
    
    private static func oAuthRoute(path: String) -> String {
        return Router.BASE_SERVICE_URL + path
    }
    
}
