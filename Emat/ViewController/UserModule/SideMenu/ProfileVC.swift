//
//  ProfileVC.swift
//  DB10
//
//  Created by mac on 02/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var text_First: UITextField!
    @IBOutlet weak var text_Mobile: UITextField!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var text_Mail: UITextField!
    
    var countryList = CountryList()
    var strLat:String! = ""
    var strLong:String! = ""

    var dic_Profile:JSON!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetProfile()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBarItem(LeftTitle: "", LeftImage: "menu", CenterTitle: Languages.MyAccount, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
    }
    override func leftClick() {
        toggleLeft()
    }
    func setUserlocation(_ cookie: String, strLat: String, strlong: String) {
//        text_Location.text = cookie
        self.strLat = strLat
        self.strLong = strlong
    }

    @IBAction func clcik_On_Profile(_ sender: Any) {
        CameraHandler.sharedInstance.showActionSheet(vc: self)
        CameraHandler.sharedInstance.imagePickedBlock = { (image) in
            self.img_profile.image = image
        }
    }
    @IBAction func Country(_ sender: UIButton) {

    }
    @IBAction func btnSignup(_ sender: UIButton) {
        if isValidInput() {
            WebSignUp()
        }
    }
    
    // MARK: - Validation
    func isValidInput() -> Bool {
        var isValid : Bool = true;
        var errorMessage : String = ""
        if (self.text_First.text?.isEmpty)!{
            isValid = false
            errorMessage = Languages.PleaseEnterName
        } else if (self.text_Mobile.text?.isEmpty)! {
            isValid = false
            errorMessage = Languages.PleaseEnterMobileNumber
        }
        if (isValid == false) {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: errorMessage, on: self)
        }
        return isValid
    }
    
    //MARK:API
    
        func GetProfile() {
              showProgressBar()

              var paramsDict:[String:AnyObject] = [:]
              paramsDict["user_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
              print(paramsDict)
              
              CommunicationManeger.callPostService(apiUrl: Router.get_profile.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
                  
                  DispatchQueue.main.async {
                      let swiftyJsonVar = JSON(responseData)
                      print(swiftyJsonVar)
                      if(swiftyJsonVar["status"].stringValue == "1") {
                        self.dic_Profile = swiftyJsonVar["result"]
                        self.text_First.text = "\(self.dic_Profile["full_name"].stringValue)"
                        self.text_Mail.text = "\(self.dic_Profile["email"].stringValue)"
                        self.text_Mobile.text = "\(self.dic_Profile["mobile"].stringValue) "
                        self.img_profile.sd_setImage(with: URL.init(string: (self.dic_Profile?["image"].stringValue)!), placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
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
        
        showProgressBar()
        var paramsDict:[String:String] = [:]
        paramsDict["email"]     =   self.text_Mail.text ?? ""
        paramsDict["full_name"]  =   self.text_First.text!
        paramsDict["mobile"]     =   self.text_Mobile.text!
        paramsDict["lat"]   =        strLat
        paramsDict["lon"]  =        strLong
        paramsDict["ios_register_id"]  =   (USER_DEFAULT.value(forKey: IOS_TOKEN) as! String)
        paramsDict["register_id"]  =   ""
        paramsDict["type"]  =   "PATIENT"
        paramsDict["user_id"]  =   (USER_DEFAULT.value(forKey: USERID) as! String)

        print(paramsDict)
        
        CommunicationManeger.uploadImagesAndData(apiUrl: Router.update_profile.url(), params: (paramsDict ) , imageParam: ["image":img_profile.image], videoParam: [:], parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    USER_DEFAULT.set(swiftyJsonVar["result"]["id"].stringValue, forKey: USERID)
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
