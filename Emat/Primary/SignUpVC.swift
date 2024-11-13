//
//  SignUpVC.swift
//  F5Places
//
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown

class SignUpVC: UIViewController {
    
    @IBOutlet weak var text_Registration: UITextField!
    @IBOutlet weak var view_Registarnumber: UIView!
    @IBOutlet weak var text_First: UITextField!
    @IBOutlet weak var text_Pass: UITextField!
    @IBOutlet weak var text_Age: UITextField!
    @IBOutlet weak var text_Mobile: UITextField!
    @IBOutlet weak var text_Email: UITextField!
    
    @IBOutlet weak var text_Institution: UITextField!
    @IBOutlet weak var text_Cadrr: UITextField!
    @IBOutlet weak var text_Country: UITextField!
    
    @IBOutlet weak var btn_User: UIButton!
    @IBOutlet weak var btn_Doctor: UIButton!
    @IBOutlet weak var btn_notfree: UIButton!
    @IBOutlet weak var btn_free: UIButton!
    @IBOutlet weak var btn_Mobile: UIButton!
    @IBOutlet weak var btn_Email: UIButton!
    
    @IBOutlet weak var view_Age: UIView!
    @IBOutlet weak var view_Mail: UIView!
    //    @IBOutlet weak var View_Healt: UIView!
    @IBOutlet weak var view_MCT: UIView!
    
    
    @IBOutlet weak var text_OTP: UITextField!
    @IBOutlet weak var trans_View: UIView!
    @IBOutlet weak var lbl_Remain: UILabel!
    
    var countryList = CountryList()
    var strLat:String! = ""
    var strLong:String! = ""
    var drop = DropDown()
    var str_FreeOrNot:String! = "Male"
    var str_OtType:String! = "Mobile"
    var strCountCode:String! = "+255"
    var strUserId:String! = ""
    var strOTP:String! = ""
    var timer: Timer?
    var totalTime = 150
    var strType:String! = "PATIENT"
    
    
    var arr_MakeName:[String] = []
    var arr_MakeID:[String] = []
    var strCtreID:String! = ""
    
    var arr_PositionName:[String] = []
    var arr_PositionNameID:[String] = []
    var strInstituID:String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        btn_User.backgroundColor = UIColor.init(named: THEME_COLOR_NAME)
        btn_Doctor.backgroundColor = UIColor.darkGray
        GetSportPosition()
        GetCountry()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        trans_View.isHidden = true
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Signup, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
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
    
    func setUserlocation(_ cookie: String, strLat: String, strlong: String) {
        //        text_Location.text = cookie
        self.strLat = strLat
        self.strLong = strlong
    }
    @IBAction func Confirm(_ sender: Any) {
        if text_OTP.text?.count != 0 {
            
            if strOTP == text_OTP.text! {
                timer?.invalidate()
              WebSignUp()
            } else {
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: Languages.EnterWrongOTP, on: self)
            }
        } else {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: Languages.PleaseEnteOTP, on: self)
        }
    }
    
    @IBAction func CADRE(_ sender: UIButton) {
        drop.anchorView = sender
        drop.dataSource = arr_MakeName
        drop.bottomOffset = CGPoint(x: 0, y: 50)
        self.drop.show()
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.text_Cadrr.text = item
            self.strCtreID = self.arr_MakeID[index]
            self.view.endEditing(true)
        }
    }
    
    @IBAction func INSTITUTUIN(_ sender: UIButton) {
        drop.anchorView = sender
        drop.dataSource = arr_PositionName
        drop.bottomOffset = CGPoint(x: 0, y: 50)
        self.drop.show()
        drop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.text_Institution.text = item
            self.strInstituID = self.arr_PositionNameID[index]
            self.view.endEditing(true)
        }
    }
    
    @IBAction func Cancel(_ sender: Any) {
        timer?.invalidate()
        trans_View.isHidden = true
    }
    
    @IBAction func ResendOTP(_ sender: Any) {
        timer?.invalidate()
        trans_View.isHidden = true
        if text_Mobile.text?.count != 0 {
            WebSendOTP()
        }
    }
    
    @IBAction func User(_ sender: Any) {
        view_MCT.isHidden = true
        view_Registarnumber.isHidden = true
        view_Age.isHidden = false
        view_Mail.isHidden = false
        strType = "PATIENT"
        btn_User.backgroundColor = UIColor.init(named: THEME_COLOR_NAME)
        btn_Doctor.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func Doctor(_ sender: Any) {
        view_MCT.isHidden = false
        view_Registarnumber.isHidden = false
        view_Age.isHidden = false
        view_Mail.isHidden = false
        strType = "DOCTOR"
        btn_Doctor.backgroundColor = UIColor.init(named: THEME_COLOR_NAME)
        btn_User.backgroundColor = UIColor.darkGray
        
    }
    @IBAction func Country(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    @IBAction func Free(_ sender: UIButton) {
        if sender.tag == 0 {
            str_FreeOrNot = "Male"
            btn_free.setImage(UIImage.init(named: "check"), for: .normal)
            btn_notfree.setImage(UIImage.init(named: "uncheck"), for: .normal)
        } else {
            btn_notfree.setImage(UIImage.init(named: "check"), for: .normal)
            btn_free.setImage(UIImage.init(named: "uncheck"), for: .normal)
            str_FreeOrNot = "Female"
        }
    }
    
    @IBAction func otp_Type(_ sender: UIButton) {
        if sender.tag == 0 {
            str_OtType = "Mobile"
            btn_Mobile.setImage(UIImage.init(named: "check"), for: .normal)
            btn_Email.setImage(UIImage.init(named: "uncheck"), for: .normal)
            print(str_OtType ?? "")
        } else {
            btn_Email.setImage(UIImage.init(named: "check"), for: .normal)
            btn_Mobile.setImage(UIImage.init(named: "uncheck"), for: .normal)
            str_OtType = "Email"
            print(str_OtType ?? "")
        }
    }
    
    
    @IBAction func btnSignup(_ sender: UIButton) {
        if strType == "PATIENT" {
               if isValidInput() {
                   if let mobileNumber = self.text_Mobile.text, mobileNumber.count >= 9 {
                       WebSendOTP()
                   } else {
                       GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Minimum mobile number should be 9 digits", on: self)
                   }
               }
           } else {
               if isValidInputDoctor() {
                   if let mobileNumber = self.text_Mobile.text, mobileNumber.count >= 9 {
                       WebSendOTP()
                   } else {
                       GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Minimum mobile number should be 9 digits", on: self)
                   }
               }
           }
//        if strType == "PATIENT" {
//            if isValidInput() {
//                if Utility.isValidMobileNumber(self.text_Mobile.text ?? "") {
//                    WebSendOTP()
//                } else {
//                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Minimum mobile number should be in 9 digits", on: self)
//                }
//            }
//        } else {
//            if isValidInputDoctor() {
//                if Utility.isValidMobileNumber(self.text_Mobile.text ?? "") {
//                    WebSendOTP()
//                } else {
//                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Minimum mobile number should be in 9 digits", on: self)
//                }
//            }
//        }
    }
    
    // MARK: - Validation
    func isValidInput() -> Bool {
        var isValid: Bool = true
        var errorMessage: String = ""
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        if (self.text_First.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.PleaseEnterName
        } else if (self.text_Age.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.Pleaseenterage
            text_Age.becomeFirstResponder()
        } else if (self.text_Institution.text?.isEmpty)! {
            isValid = false
            errorMessage = "Please select Institution"
        } else if (self.text_Email.text?.isEmpty)! {
            isValid = false
            errorMessage = "Please enter the email"
        } else if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self.text_Email.text) {
            isValid = false
            errorMessage = "Please enter a valid email"
        } else if (self.text_Mobile.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.PleaseEnterMobileNumber
        } else if (self.text_Pass.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.PleaseEnterPassword
            text_Pass.becomeFirstResponder()
        }

        if (isValid == false) {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
        }
        return isValid
    }

//    func isValidInput() -> Bool {
//        var isValid : Bool = true;
//        var errorMessage : String = ""
//        if (self.text_First.text?.isEmpty)!{
//            isValid = false
//            errorMessage = Languages.PleaseEnterName
//        } else if (self.text_Age.text?.isEmpty)!{
//            isValid = false
//            errorMessage = Languages.Pleaseenterage
//            text_Age.becomeFirstResponder()
//        }  else if (self.text_Institution.text?.isEmpty)!{
//            isValid = false
//            errorMessage = "Please select Institution"
//        } else if (self.text_Email.text?.isEmpty)! {
//            isValid = false
//            errorMessage = "Please enter the email"
//        } else if (self.text_Mobile.text?.isEmpty)! {
//            isValid = false
//            errorMessage = Languages.PleaseEnterMobileNumber
//        }
//        else if (self.text_Pass.text?.isEmpty)!{
//            isValid = false
//            errorMessage = Languages.PleaseEnterPassword
//            text_Pass.becomeFirstResponder()
//        }
//        if (isValid == false) {
//            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
//        }
//        return isValid
//    }
    
    
    func isValidInputDoctor() -> Bool {
        var isValid : Bool = true;
        var errorMessage : String = ""
        if (self.text_First.text?.isEmpty)!{
            isValid = false
            errorMessage = Languages.PleaseEnterName
        }
        else if (self.text_Registration.text?.isEmpty)!{
            isValid = false
            errorMessage = "Please enter registration number"
            text_Age.becomeFirstResponder()
        }
        else if (self.text_Age.text?.isEmpty)!{
            isValid = false
            errorMessage = Languages.Pleaseenterage
            text_Age.becomeFirstResponder()
        }
        else if (self.text_Cadrr.text?.isEmpty)!{
            isValid = false
            errorMessage = "Please select cadre"
        }
        else if (self.text_Institution.text?.isEmpty)!{
            isValid = false
            errorMessage = "Please select Institution"
        }
        else if (self.text_Email.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.Pleaseentertheemail
        }
        else if (self.text_Mobile.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.PleaseEnterMobileNumber
        } else if (self.text_Pass.text?.isEmpty)!{
            isValid = false
            errorMessage = Languages.PleaseEnterPassword
            text_Pass.becomeFirstResponder()
        }
        if (isValid == false) {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
        }
        return isValid
    }
    
    //MARK:API
    //MARK:API
    
    func GetCountry() {
        showProgressBar()
        let paramsDict:[String:AnyObject] = [:]
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_cadre.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    self.arr_MakeName = swiftyJsonVar["result"].arrayValue.map({ $0["name"].string! })
                    self.arr_MakeID = swiftyJsonVar["result"].arrayValue.map({ $0["id"].string! })
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
    func GetSportPosition() {
        showProgressBar()
        let paramsDict:[String:AnyObject] = [:]
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_Institution.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1") {
                    self.arr_PositionName = swiftyJsonVar["result"].arrayValue.map({ $0["name"].string! })
                    self.arr_PositionNameID = swiftyJsonVar["result"].arrayValue.map({ $0["id"].string! })
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
    func WebSignUp() {
        
        if USER_DEFAULT.value(forKey: IOS_TOKEN) == nil {
            USER_DEFAULT.set("IOS123", forKey: IOS_TOKEN)
        }
        
        showProgressBar()
        var paramsDict:[String:String] = [:]
        paramsDict["full_name"]  =   self.text_First.text!
        paramsDict["password"]  =   self.text_Pass.text!
        paramsDict["mobile"]     =   "\(self.text_Mobile.text!)"
        paramsDict["lat"]   =        strLat
        paramsDict["lon"]  =        strLong
        paramsDict["ios_register_id"]  =   (USER_DEFAULT.value(forKey: IOS_TOKEN) as! String)
        paramsDict["register_id"]  =   ""
        paramsDict["age"]  =   self.text_Age.text!
        paramsDict["country"]  =   strCountCode!
        paramsDict["type"]  =   strType!
        paramsDict["address"]  =   ""
        paramsDict["GPS"]  =   ""
        paramsDict["District"]  =   ""
        paramsDict["status"]  =   ""
        paramsDict["Location"]  =   ""
        paramsDict["email"]  =   self.text_Email.text!
        paramsDict["MCT_No"]  =   ""
        paramsDict["Health_Facility"]  =   ""
        paramsDict["gender"]  =   str_FreeOrNot!
        paramsDict["institution_id"]  =   strInstituID!
        paramsDict["institution_name"]  =   text_Institution.text!
        paramsDict["cadre_id"]  =   strCtreID!
        paramsDict["cadre_name"]  =   text_Cadrr.text!
        
        print(paramsDict)
        //        Call<ResponseBody> SignupCall(@Query("full_name") String full_name, @Query("mobile") String phone, @Query("email") String email, @Query("password") String password, @Query("register_id") String register_id, @Query("ios_register_id") String ios_register_id, @Query("lat") String lat, @Query("lon") String lon, @Query("type") String type, @Query("address") String address, @Query("age") String age, @Query("GPS") String GPS, @Query("Location") String Location, @Query("District") String District, @Query("MCT_No") String MCT_No,@Query("Health_Facility") String Health_Facility,@Query("gender") String gender,@Query("institution_id") String institution_id,@Query("institution_name") String institution_name,@Query("cadre_id") String cadre_id,@Query("cadre_name") String cadre_name) ;
        CommunicationManeger.uploadImagesAndData(apiUrl: Router.signUp.url(), params: (paramsDict ) , imageParam: [:], videoParam: [:], parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.strUserId = swiftyJsonVar["result"]["id"].stringValue
                    USER_DEFAULT.set(self.strUserId, forKey: USERID)
                    USER_DEFAULT.setValue(self.strType, forKey: USER_TYPE)
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
    
    func WebSendOTP() {
        showProgressBar()
        var paramsDict:[String:String] = [:]
        paramsDict["mobile"]     =   "\(strCountCode!)\(self.text_Mobile.text!)"
        paramsDict["email"]      =   self.text_Email.text!
        paramsDict["type"]       =   self.str_OtType
        
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
    
}
extension SignUpVC:  CountryListDelegate {
    
    func selectedCountry(country: Country) {
        print(country.name)
        print(country.flag)
        print(country.countryCode)
        print(country.phoneExtension)
        //                WebGetCasebyCountry(strcoun: country.name!)
        //                text_Country.text = country.name!
        strCountCode = "+\(country.phoneExtension)"
        text_Country.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
    }
}
