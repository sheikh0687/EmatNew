//
//  HomeVC.swift
//  DB10
//
//  Created by mac on 31/03/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import DropDown

class HomeVC: UIViewController {
    @IBOutlet weak var lbl_Reason: UILabel!
    
    @IBOutlet weak var view_Message: UIView!
    @IBOutlet weak var view_EmreConsult: UIView!
    @IBOutlet weak var lbl_OnlineOffline: UILabel!
    @IBOutlet weak var lbl_CountMesa: UILabel!
    @IBOutlet weak var view_Special: UIView!
    var arr_Reason:[String] = []
    var arr_ReasonID:[String] = []
    var strReasonID:String = ""
    var arr_ReasonSW:[String] = []

    var drop = DropDown()

    @IBOutlet weak var view_Hot: UIView!
    @IBOutlet weak var view_Emergency: UIView!
    @IBOutlet weak var lbl_TakToDoc: UILabel!
    @IBOutlet weak var trans_View: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // WebGetReason()
        setNavigationBarItem(LeftTitle: "", LeftImage: "menu", CenterTitle: "", CenterImage: "logosmall", RightTitle: "Sync Data offline", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
          GetProfile()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        trans_View.isHidden = true
        
        
//        if strType == PATIENT {
//            lbl_TakToDoc.text  = Languages.TALKTOADOCTOR
//            lbl_Treatment.text = Languages.SYMPTOMSMANAGEMENT
//        } else {
//            lbl_TakToDoc.text  = Languages.TALKTOACLIENT
//            lbl_Treatment.text = Languages.TREATMENT
//        }
    }
    override func rightClick() {
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            WebForGetFaq()
        } else {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: "Now you offline", on: self)
        }
    }
    override func leftClick() {
         toggleLeft()
    }
    @IBAction func hotliness(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "SelectResgionVC") as! SelectResgionVC
        objVC.strAPI = Router.get_Regions_list.url()
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func cpdD(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "cpdVC") as! cpdVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    @IBAction func Message(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ChatuserlistVC") as! ChatuserlistVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    @IBAction func Switch(_ sender: UISwitch) {
        if sender.isOn {
            lbl_OnlineOffline.text = "Go Offline"
            WebForUpdatestatus(strStus: "ONLINE")
        } else {
            lbl_OnlineOffline.text = "Go Online"
            WebForUpdatestatus(strStus: "OFFLINE")
        }
    }
    @IBAction func Next(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ChatConversationVC") as! ChatConversationVC
        objVC.strReason = lbl_Reason.text!
        objVC.strReasonID = strReasonID
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    @IBAction func Position(_ sender: UIButton) {
          drop.anchorView = sender
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            drop.dataSource = arr_Reason
        } else {
            drop.dataSource = arr_ReasonSW
        }
          drop.bottomOffset = CGPoint(x: 0, y: 50)
          self.drop.show()
          drop.selectionAction = { [unowned self] (index: Int, item: String) in
              self.lbl_Reason.text = item
              self.strReasonID = self.arr_ReasonID[index]
              self.view.endEditing(true)
          }
   }
    @IBAction func Doctor(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "DrugsAndTanzVC") as! DrugsAndTanzVC
        objVC.strAPI = Router.get_drugs.url()
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func NewsUpdate(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "PreventionVC") as! PreventionVC
        objVC.strAPI = Router.get_books.url()
        objVC.strTitle = "Books"
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    @IBAction func Screen(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "PreventionVC") as! PreventionVC
        objVC.strAPI = Router.get_Guideline.url()
        objVC.strTitle = "Guidelines"
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    @IBAction func Prevention(_ sender: Any) {
        
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "DrugsAndTanzVC") as! DrugsAndTanzVC
        objVC.strAPI = Router.get_STG_format.url()
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func EmergencyConusl(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ChatConversationVC") as! ChatConversationVC
        self.navigationController?.pushViewController(objVC, animated: true)

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
                     let dic = swiftyJsonVar["result"]
                   
                     self.view_Special.isHidden = true
                     self.view_Message.isHidden = true
                     self.view_EmreConsult.isHidden = true
                    self.view_Emergency.isHidden = false

                     self.lbl_CountMesa.text = dic["unseen_count"].stringValue
                    
                    if dic["type"].stringValue == "SPECIALIST" {
                        self.view_Special.isHidden = false
                        self.view_Message.isHidden = true
                        self.view_EmreConsult.isHidden = false
                        self.view_Emergency.isHidden = false

                     } else if dic["type"].stringValue == "PATIENT" {
                        self.view_Special.isHidden = true
                        self.view_Message.isHidden = true
                        self.view_EmreConsult.isHidden = true
                         self.view_Emergency.isHidden = false

                    } else if dic["type"].stringValue == "DOCTOR" {
                        self.view_Emergency.isHidden = false
                    }
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

    func WebForUpdatestatus(strStus:String) {
          showProgressBar()
          var paramsDict:[String:AnyObject] = [:]
          paramsDict["user_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
          paramsDict["available_status"]  =   strStus as AnyObject

          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: Router.update_available_status.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                 
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
