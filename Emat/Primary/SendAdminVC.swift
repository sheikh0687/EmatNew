//
//  SendAdminVC.swift
//  Emat
//
//  Created by mac on 26/08/20.
//  Copyright © 2020 com.ios.emat. All rights reserved.
//

import UIKit
import SwiftyJSON

class SendAdminVC: UIViewController {
    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var text_Message: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: "", CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func Send(_ sender: Any) {
        if isValidInput() {
            CheckEmailStatus()
        }
    }
 // MARK: - Validation
 func isValidInput() -> Bool {
     var isValid : Bool = true;
     var errorMessage : String = ""
    if textTitle.text?.count == 0 {
         isValid = false
         errorMessage = "Please enter title"
         textTitle.becomeFirstResponder()
     } else  if text_Message.text?.count == 0 {
             isValid = false
             errorMessage = "Please enter message"
             text_Message.becomeFirstResponder()
         }
     if (isValid == false) {
         GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
     }
     return isValid
 }
 
 //MARK:API
 func CheckEmailStatus() {
     showProgressBar()
     var paramsDict:[String:AnyObject] = [:]
     paramsDict["user_id"]     =   self.textTitle.text! as AnyObject
     paramsDict["title"]     =   self.textTitle.text! as AnyObject
     paramsDict["message"]     =   self.text_Message.text! as AnyObject

     print(paramsDict)
     CommunicationManeger.callPostService(apiUrl: Router.mail_for_activation.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
         
         DispatchQueue.main.async {
             let swiftyJsonVar = JSON(responseData)
             print(swiftyJsonVar)
             if(swiftyJsonVar["status"] == "1") {
                 self.navigationController?.popViewController(animated: true)
             } else {
                 let message = swiftyJsonVar["result"].string
                 GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message!, on: self)
             }
             self.hideProgressBar()
         }
         
         
     },failureBlock: { (error : Error) in
         self.hideProgressBar()
         GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
     })
 }

}
