//
//  ForgotPasswordVC.swift
//  F5Places
//
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var text_Email: UITextField!
    
    @IBOutlet weak var text_OTP: UITextField!
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var lbl_Remain: UILabel!
   
    var strCountCode:String! = "+255"
    var strUserId:String! = ""
    var strOTP:String! = ""
    var timer: Timer?
    var totalTime = 150
    var strPass:String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trans_View.isHidden = true

        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Forgotpassword, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        if isValidInput() {
            CheckEmailStatus()
        }
    }
    @IBAction func Confirm(_ sender: Any) {
        if text_OTP.text?.count != 0 {
            print(strOTP as Any)
            if strOTP == text_OTP.text! {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Your password is \(strPass!)", on: self)
                trans_View.isHidden = true
                text_Email.text = ""
                text_OTP.text = ""
                timer?.invalidate()

            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: Languages.EnterWrongOTP, on: self)
            }
        } else {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: Languages.PleaseEnteOTP, on: self)
        }
    }
    @IBAction func Cancel(_ sender: Any) {
        trans_View.isHidden = true
    }
    
    @IBAction func ResendOTP(_ sender: Any) {
        trans_View.isHidden = true
        if text_Email.text?.count != 0 {
            WebSendOTP()
        }
    }

    private func startOtpTimer() {
        self.totalTime = 150
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        self.lbl_Remain.text = "Remaining \(self.timeFormatted(self.totalTime) )"// will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.trans_View.isHidden = true
            }
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

     // MARK: - Validation
        func isValidInput() -> Bool {
            var isValid : Bool = true;
            var errorMessage : String = ""
            if text_Email.text!.count == 0 {
                isValid = false
                errorMessage = Languages.PleaseEnterMobileNumber
                text_Email.becomeFirstResponder()
            }
            if (isValid == false) {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
            }
            return isValid
        }
        
        //MARK:API
    
    func WebSendOTP() {
        showProgressBar()
        var paramsDict:[String:String] = [:]
        paramsDict["mobile"]     =   "\(strCountCode!)\(self.text_Email.text!)"
        
        print(paramsDict)
        
        CommunicationManeger.uploadImagesAndData(apiUrl: Router.verify_number.url(), params: (paramsDict ) , imageParam: [:], videoParam: [:], parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.strOTP =  swiftyJsonVar["result"]["code"].stringValue
                    self.startOtpTimer()
                    self.trans_View.isHidden = false
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

        func CheckEmailStatus() {
            showProgressBar()
            var paramsDict:[String:AnyObject] = [:]
            paramsDict["mobile"]     =   self.text_Email.text! as AnyObject
            print(paramsDict)
            CommunicationManeger.callPostService(apiUrl: Router.get_user_details.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
                
                DispatchQueue.main.async {
                    let swiftyJsonVar = JSON(responseData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["status"] == "1") {
                        self.strPass =  swiftyJsonVar["result"]["password"].stringValue
                        self.WebSendOTP()
                    } else {
                        GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Not exist phone number", on: self)
                    }
                    self.hideProgressBar()
                }
                
                
            },failureBlock: { (error : Error) in
                self.hideProgressBar()
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
            })
        }
}
