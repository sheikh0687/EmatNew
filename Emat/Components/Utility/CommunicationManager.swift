//
//  CommunicationManager.swift
//  Shipit
//
//  Created by mac on 24/09/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CommunicationManeger {
    
    //MARK: - POST API Request
    class func callPostService(apiUrl urlString: String, parameters params : [String: AnyObject]?,Method method : HTTPMethod,  parentViewController parentVC: UIViewController, successBlock success : @escaping ( _ responseData : AnyObject, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void) {
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            print("API NAME \(urlString)")
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            manager.request(urlString, method: method, parameters: params)
                .responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        if((response.result.value) != nil) {
                            success(response.result.value as AnyObject, "Successfull")
                        }
                        break
                    case .failure(let error):
                        print(error)
                        if error._code == NSURLErrorTimedOut {
                            //HANDLE TIMEOUT HERE
                            print(error.localizedDescription)
                            failure(error)
                        } else {
                            print("\n\nAuth request failed with error:\n \(error)")
                            failure(error)
                        }
                        break
                    }
            }
        } else {
            parentVC.hideProgressBar();
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: NETWORK_ERROR_MSG, delegate: nil, parentViewController: parentVC)
        }
    }
    
    //MARK: - Multipart API Request for upload multiple photos
    class func uploadImagesAndData(apiUrl urlString: String, params:[String : String]?,imageParam: [String : UIImage?]?,videoParam: [String : Data?]?, parentViewController parentVC: UIViewController, successBlock success : @escaping ( _ responseData : AnyObject, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void){
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                // "Content-type": "multipart/form-data"
                "Content-Type": "application/json"
            ]
            
            Alamofire.upload(multipartFormData: {multipartFormData in
                for (key, value) in params! {
                    if let data = value.data(using: String.Encoding(rawValue:  String.Encoding.utf8.rawValue)) {
                        //print("Filed Name : \(key), Value :\(value)")
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                for (key, image) in imageParam! {
                    if let imageData = image?.jpegData(compressionQuality: 0.5) {
                        multipartFormData.append(imageData, withName: key as String, fileName: "\(key).jpg", mimeType: "image/jpeg")
                    }
                }
                
                for (key, data) in videoParam! {
                    multipartFormData.append(data!, withName: key, fileName: "\(key).mp4", mimeType: "video/mp4")
                }
            },
                             to: urlString, headers: headers, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload
                                        .uploadProgress(closure: { (progress) in
                                            print("Progress : \(progress)")
                                        })
                                        .validate()
                                        .responseJSON { response in
                                            print(response)
                                            if(response.result.isSuccess) {
                                                success(response.result.value as AnyObject,  "Successfull")
                                            }
                                            else {
                                                failure(response.result.error! as Error)
                                            }
                                    }
                                case .failure(let error):
                                    print(error)
                                    if error._code == NSURLErrorTimedOut {
                                        //HANDLE TIMEOUT HERE
                                        failure(error)
                                    } else {
                                        failure(error)
                                    }
                                    break
                                }
            })
        } else {
            parentVC.hideProgressBar();
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: NETWORK_ERROR_MSG, delegate: nil, parentViewController: parentVC)
        }
    }
    class func uploadImagesAndDataWithArrayOfImage(apiUrl urlString: String, params:[String : String]?,imageParam: [String : Array<UIImage>?]?,videoParam: [String : Data?]?, parentViewController parentVC: UIViewController, successBlock success : @escaping ( _ responseData : AnyObject, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void){
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                // "Content-type": "multipart/form-data"
                "Content-Type": "application/json"
            ]
            
            Alamofire.upload(multipartFormData: {multipartFormData in
                for (key, value) in params! {
                    if let data = value.data(using: String.Encoding(rawValue:  String.Encoding.utf8.rawValue)) {
                        //print("Filed Name : \(key), Value :\(value)")
                        multipartFormData.append(data, withName: key)
                    }
                }
                for (key, imageArr) in imageParam! {
                    for image in imageArr! {
                        if let imageData = image.jpegData(compressionQuality: 0.5) {
                            multipartFormData.append(imageData, withName: key as String, fileName: "\(key).jpg", mimeType: "image/jpeg")
                        }
                    }
                }
//                for image in imageParam! {
//                    if let imageData = image.jpegData(compressionQuality: 0.5) {
//                        multipartFormData.append(imageData, withName: "images[]", fileName: "images[].jpg", mimeType: "image/jpeg")
//                    }
//                }
                
//                for (key, data) in videoParam! {
//                    multipartFormData.append(data!, withName: key, fileName: "\(key).mp4", mimeType: "video/mp4")
//                }
            },
                             to: urlString, headers: headers, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload
                                        .uploadProgress(closure: { (progress) in
                                            print("Progress : \(progress)")
                                        })
                                        .validate()
                                        .responseJSON { response in
                                            print(response)
                                            if(response.result.isSuccess) {
                                                success(response.result.value as AnyObject,  "Successfull")
                                            }
                                            else {
                                                failure(response.result.error! as Error)
                                            }
                                    }
                                case .failure(let error):
                                    print(error)
                                    if error._code == NSURLErrorTimedOut {
                                        //HANDLE TIMEOUT HERE
                                        failure(error)
                                    } else {
                                        failure(error)
                                    }
                                    break
                                }
            })
        } else {
            parentVC.hideProgressBar();
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: NETWORK_ERROR_MSG, delegate: nil, parentViewController: parentVC)
        }
    }
    //MARK: - Multipart API Request for upload multiple photos
    class func uploadImagesAndVideoData(apiUrl urlString: String, params:[String : String]?,imageParam: [String : Array<UIImage>?]?,videoParam: [String : Array<Any>?]?,parentViewController parentVC: UIViewController, successBlock success : @escaping ( _ responseData : AnyObject, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void){
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            let headers: HTTPHeaders = [
                /* "Authorization": "your_access_token",  in case you need authorization header */
                // "Content-type": "multipart/form-data"
                "Content-Type": "application/json"
            ]
            
            Alamofire.upload(multipartFormData: {multipartFormData in
                for (key, value) in params! {
                    if let data = value.data(using: String.Encoding(rawValue:  String.Encoding.utf8.rawValue)) {
                        //print("Filed Name : \(key), Value :\(value)")
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                for (key, imageArr) in imageParam! {
                    for image in imageArr! {
                        if let imageData = image.jpegData(compressionQuality: 0.5) {
                            multipartFormData.append(imageData, withName: key as String, fileName: "\(key).jpg", mimeType: "image/jpeg")
                        }
                    }
                }
                
                for (key, videoUrl) in videoParam! {
                    for url in videoUrl! {
                        multipartFormData.append(url as! URL, withName: key, fileName: "\(key).mp4", mimeType: "video/mp4")
                    }
                }
            },
                             to: urlString, headers: headers, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    upload
                                        .uploadProgress(closure: { (progress) in
                                            print("Progress : \(progress)")
                                        })
                                        .validate()
                                        .responseJSON { response in
                                            print(response)
                                            if(response.result.isSuccess) {
                                                success(response.result.value as AnyObject,  "Successfull")
                                            }
                                            else {
                                                failure(response.result.error! as Error)
                                            }
                                    }
                                case .failure(let error):
                                    print(error)
                                    if error._code == NSURLErrorTimedOut {
                                        //HANDLE TIMEOUT HERE
                                        failure(error)
                                    } else {
                                        failure(error)
                                    }
                                    break
                                }
            })
        } else {
            parentVC.hideProgressBar();
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: NETWORK_ERROR_MSG, delegate: nil, parentViewController: parentVC)
        }
    }
    
    
    //MARK: - POST API Request For AppDelegate
    class func callWebService(apiUrl urlString: String, parameters params : [String: AnyObject]?,Method method : HTTPMethod,   successBlock success : @escaping ( _ responseData : AnyObject, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void) {
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            manager.request(urlString, method: method, parameters: params)
                .responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        if((response.result.value) != nil) {
                            success(response.result.value as AnyObject, "Successfull")
                        }
                        break
                    case .failure(let error):
                        print(error)
                        if error._code == NSURLErrorTimedOut {
                            //HANDLE TIMEOUT HERE
                            print(error.localizedDescription)
                            failure(error)
                        } else {
                            print("\n\nAuth request failed with error:\n \(error)")
                            failure(error)
                        }
                        break
                    }
            }
        }
    }
    
    //MARK: - POST API Request
    class func callPostApi(apiUrl urlString: String, parameters params : [String: AnyObject]?,Method method : HTTPMethod,  parentViewController parentVC: UIViewController, successBlock success : @escaping ( _ responseData : Data, _  message: String) -> Void, failureBlock failure: @escaping (_ error: Error) -> Void) {
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            manager.request(urlString, method: method, parameters: params)
                .responseJSON {
                    response in
                    switch (response.result) {
                    case .success:
                        if((response.result.value) != nil) {
                            if let data = response.data {
                                success(data, "Successfull")
                            }
                        }
                        break
                    case .failure(let error):
                        print(error)
                        if error._code == NSURLErrorTimedOut {
                            //HANDLE TIMEOUT HERE
                            print(error.localizedDescription)
                            failure(error)
                        } else {
                            print("\n\nAuth request failed with error:\n \(error)")
                            failure(error)
                        }
                        break
                    }
            }
        } else {
            parentVC.hideProgressBar();
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: NETWORK_ERROR_MSG, delegate: nil, parentViewController: parentVC)
        }
    }
}
