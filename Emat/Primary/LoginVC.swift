//
//  LoginVC.swift
//  F5Places
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginVC: UIViewController {
    
    @IBOutlet weak var text_CountryCode: UITextField!
    @IBOutlet weak var text_Pass: UITextField!
    @IBOutlet weak var text_Email: UITextField!
    var strType:String! = ""
    var countryList = CountryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryList.delegate = self
        if USER_DEFAULT.value(forKey: FIRSTTIMELAUNCH) == nil {
            WebForGetFaq()
            USER_DEFAULT.set("YES", forKey: FIRSTTIMELAUNCH)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Login, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }
    
    @IBAction func clcik_On_Country(_ sender: Any) {
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if isValidInput() {
            CheckEmailStatus()
        }
    }
    
    @IBAction func btnTermsAndCond(_ sender: UIButton) {
        //        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        //        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func Admin(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "SendAdminVC") as! SendAdminVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    // MARK: - Validation
    func isValidInput() -> Bool {
        var isValid : Bool = true;
        var errorMessage : String = ""
        if (self.text_Email.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.PleaseEnterMobileNumber
            text_Email.becomeFirstResponder()
        }  else if (self.text_Pass.text?.isEmpty)!{
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
    func CheckEmailStatus() {
        showProgressBar()
        
        if USER_DEFAULT.value(forKey: IOS_TOKEN) == nil {
            USER_DEFAULT.set("IOS123", forKey: IOS_TOKEN)
        }

        var paramsDict:[String:AnyObject] = [:]
        paramsDict["mobile"]     =   self.text_Email.text! as AnyObject
        paramsDict["password"]  =   self.text_Pass.text! as AnyObject
        paramsDict["type"]  =   "" as AnyObject?
        paramsDict["lat"]   =        "" as AnyObject?
        paramsDict["lon"]  =        "" as AnyObject?
        paramsDict["ios_register_id"]  =   (USER_DEFAULT.value(forKey: IOS_TOKEN) as! String) as AnyObject
        paramsDict["register_id"]  =   "" as AnyObject?
        
        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: Router.logIn.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    
                    USER_DEFAULT.set(swiftyJsonVar["result"]["id"].stringValue, forKey: USERID)
                    USER_DEFAULT.setValue(swiftyJsonVar["result"]["type"].stringValue, forKey: USER_TYPE)
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
    func WebForGetFaq() {
          showProgressBar()
          let paramsDict:[String:AnyObject] = [:]
          
          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: Router.get_drugs.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                  if(swiftyJsonVar["message"] == "successfull") {
                    guard let rawData = try? JSON(responseData).rawData() else { return }
                    USER_DEFAULT.set(rawData, forKey: DRUGS)
                  }
                  self.WebForGetFaq2()
                  self.hideProgressBar()
              }
              
              
          },failureBlock: { (error : Error) in
              self.hideProgressBar()
              GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
          })
      }
    
    func WebForGetFaq2() {
          showProgressBar()
          let paramsDict:[String:AnyObject] = [:]
          
          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: Router.get_STG_format.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                  if(swiftyJsonVar["message"] == "successfull") {
                    guard let rawData = try? JSON(responseData).rawData() else { return }
                    USER_DEFAULT.set(rawData, forKey: STG)
                  }
                  self.WebForGetFaq3()
                  self.hideProgressBar()
              }
              
              
          },failureBlock: { (error : Error) in
              self.hideProgressBar()
              GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
          })
      }
    func WebForGetFaq3() {
          showProgressBar()
          let paramsDict:[String:AnyObject] = [:]
          
          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: Router.get_Guideline.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                  if(swiftyJsonVar["message"] == "successfull") {
                    guard let rawData = try? JSON(responseData).rawData() else { return }
                    USER_DEFAULT.set(rawData, forKey: GUIDLINE)
                  }
                  self.WebForGetFaq4()
                  self.hideProgressBar()
              }
              
              
          },failureBlock: { (error : Error) in
              self.hideProgressBar()
              GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
          })
      }
    func WebForGetFaq4() {
            showProgressBar()
            let paramsDict:[String:AnyObject] = [:]
            
            print(paramsDict)
            
            CommunicationManeger.callPostService(apiUrl: Router.get_books.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
                
                DispatchQueue.main.async {
                    let swiftyJsonVar = JSON(responseData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["message"] == "successfull") {
                      guard let rawData = try? JSON(responseData).rawData() else { return }
                      USER_DEFAULT.set(rawData, forKey: BOOKS)
                    }
                    self.WebForGetFaq5()
                    self.hideProgressBar()
                }
                
                
            },failureBlock: { (error : Error) in
                self.hideProgressBar()
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
            })
        }
      func WebForGetFaq5() {
            showProgressBar()
            let paramsDict:[String:AnyObject] = [:]
            
            print(paramsDict)
            
            CommunicationManeger.callPostService(apiUrl: Router.get_Regions_list.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
                
                DispatchQueue.main.async {
                    let swiftyJsonVar = JSON(responseData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["status"] == "1") {
                      guard let rawData = try? JSON(responseData).rawData() else { return }
                      USER_DEFAULT.set(rawData, forKey: RESGION)
                    }
                    self.WebForGetFaq6()
                    self.hideProgressBar()
                }
                
                
            },failureBlock: { (error : Error) in
                self.hideProgressBar()
                GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
            })
        }
     func WebForGetFaq6() {
          showProgressBar()
          let paramsDict:[String:AnyObject] = [:]
          
          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: Router.get_Region_conferences.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                  if(swiftyJsonVar["status"] == "1") {
                    guard let rawData = try? JSON(responseData).rawData() else { return }
                    USER_DEFAULT.set(rawData, forKey: CONFERENCE)
                  }
                  self.WebForGetFaq7()
                  self.hideProgressBar()
              }
              
              
          },failureBlock: { (error : Error) in
              self.hideProgressBar()
              GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
          })
      }
    func WebForGetFaq7() {
         showProgressBar()
         let paramsDict:[String:AnyObject] = [:]
         
         print(paramsDict)
         
         CommunicationManeger.callPostService(apiUrl: Router.get_Region_training.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
             
             DispatchQueue.main.async {
                 let swiftyJsonVar = JSON(responseData)
                 print(swiftyJsonVar)
                 if(swiftyJsonVar["status"] == "1") {
                   guard let rawData = try? JSON(responseData).rawData() else { return }
                   USER_DEFAULT.set(rawData, forKey: TRAINING)
                 }
                 self.hideProgressBar()
             }
             
             
         },failureBlock: { (error : Error) in
             self.hideProgressBar()
             GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
         })
     }

}
extension LoginVC:  CountryListDelegate {
    
    func selectedCountry(country: Country) {
        print(country.name)
        print(country.flag)
        print(country.countryCode)
        print(country.phoneExtension)
        //                WebGetCasebyCountry(strcoun: country.name!)
        text_CountryCode.text = country.name!
        text_CountryCode.text = "\(country.flag!) (\(country.countryCode)) +\(country.phoneExtension)"
    }
}
