//
//  ChangePassVC.swift
//  24Hour User
//
//  Created by mac on 16/07/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangePassVC: UIViewController {

    @IBOutlet weak var text_confirm: UITextField!
    @IBOutlet weak var text_Old: UITextField!
    @IBOutlet weak var text_new: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem(LeftTitle: "", LeftImage: "menu", CenterTitle: Languages.ChangePassword, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")


    }
    override func leftClick() {
        toggleLeft()
    }
    @IBAction func submit(_ sender: Any) {
        
        if isValidInput() {
           CheckEmailStatus()
        }
    }

    //MARK: FUNCTIONS
    func isValidInput() -> Bool {
        var isValid : Bool = true;
        var errorMessage : String = ""
        if text_Old.text?.count == 0 {
            isValid = false
            errorMessage = Languages.PleaseEnterPassword
        } else if (text_new.text?.count == 0) {
            errorMessage =  Languages.PleaseEnterPassword
        } else if (text_confirm.text?.count == 0) {
            isValid = false
            errorMessage = Languages.Pleaseenterconfirmpassword
        } else if text_confirm.text! != text_new.text!{
            isValid = false
            errorMessage = Languages.Pleaseentersamepassword
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
        paramsDict["old_password"]     =   self.text_Old.text! as AnyObject
        paramsDict["password"]         =   self.text_new.text! as AnyObject
        paramsDict["password"]         =   self.text_confirm.text! as AnyObject
        paramsDict["user_id"]          =   USER_DEFAULT.value(forKey: USERID) as AnyObject?

        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: Router.changepass.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    Switcher.updateRootVC()
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
