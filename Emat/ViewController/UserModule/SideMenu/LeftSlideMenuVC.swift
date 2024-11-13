//
//  LeftSlideMenuVC.swift
//  F5Places
//
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import SlideMenuControllerSwift
import SDWebImage

enum LeftMenu: Int {
    case home
    case profile
    case about
    case privacy
    case web
    case yout
    case share
    case Termd
}
enum LeftMenuDoctor: Int {
    case home
    case profile
    case CLangu
    case about
    case privacy
    case website
    case youtube
    case share
    case Termd
}
class LeftSlideMenuVC: UIViewController {
    
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var tableViewOt: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblProfileName: UILabel!
    
    var menuArrImg:[UIImage?] = []
  
    var dic_Profile:JSON = []

    var menuArrName:[String] = []

    
    var homeViewController: UIViewController!
    var ChangePassViewController: UIViewController!
    var ChangeLanguageController: UIViewController!
    var AboutViewController: UIViewController!
    var PrivacyViewController: UIViewController!
    var TermsViewController: UIViewController!
    var feedbackViewController: UIViewController!
    var NotifiatViewController: UIViewController!
    var chattViewController: UIViewController!
    let strType = USER_DEFAULT.value(forKey: USER_TYPE) as! String

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
  
            menuArrImg = [
                UIImage(named: "user"),
                UIImage(named: "user"),
                UIImage(named: "question"),
                UIImage(named: "privacy"),
                UIImage(named: "website"),
                UIImage(named: "video_ic"),
                UIImage(named: "share_ic"),
                UIImage(named: "termscond"),

            ]
            
            menuArrName = [Languages.Home,
            Languages.MyProfile,
            Languages.AboutUs,
            Languages.Privacypolicy,
                           "EMAT Website",
                           "EMAT YouTube",
                           "Share Application",
            Languages.TermsConditions]
       
        GetProfile()
        
        self.tableViewOt.tableFooterView = UIView(frame: CGRect.zero)
        
        let objHomeVC = kStoryboardMain.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.homeViewController = UINavigationController(rootViewController: objHomeVC)
        

        let LeaderboardVC1 = kStoryboardMain.instantiateViewController(withIdentifier: "TermsAndCondVC") as! TermsAndCondVC
        self.TermsViewController = UINavigationController(rootViewController: LeaderboardVC1)
//////
////
////
//        let WeighttraineeVC1 = kStoryboardMain.instantiateViewController(withIdentifier: "TermsAndCondVC") as! TermsAndCondVC
//        self.WeightTraineeViewController = UINavigationController(rootViewController: WeighttraineeVC1)
////
//        let BlogVC12 = kStoryboardMain.instantiateViewController(withIdentifier: "BlogVC") as! BlogVC
//        self.blogViewController = UINavigationController(rootViewController: BlogVC12)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func changeViewControllerDoctoe(_ menu: LeftMenuDoctor) {
        
        switch menu {
        case .home:
                Switcher.updateRootVC()
        case .profile:
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
        case .CLangu:
            self.slideMenuController()?.changeMainViewController(self.ChangeLanguageController, close: true)
        case .about:
            APP_DELEGATE.strUrl = "\(Router.BASE_SERVICE_URL)get_page_aboutUs"
            APP_DELEGATE.strTitle = Languages.AboutUs
            self.slideMenuController()?.changeMainViewController(self.TermsViewController, close: true)
        case .privacy:
            APP_DELEGATE.strUrl = "\(Router.BASE_SERVICE_URL)get_page_privacy"
            APP_DELEGATE.strTitle = Languages.Privacypolicy
            self.slideMenuController()?.changeMainViewController(self.TermsViewController, close: true)
        case .Termd:
            APP_DELEGATE.strUrl = "\(Router.BASE_SERVICE_URL)get_page_terms"
            APP_DELEGATE.strTitle = Languages.TermsConditions
            self.slideMenuController()?.changeMainViewController(self.TermsViewController, close: true)
        case .website:
            if let url = URL(string: "http://www.emat.or.tz"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .youtube:
            if let url = URL(string: "https://www.youtube.com/@emergencymedicineassociati3277"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .share:
            doShare()
        }
       
    }
    func changeViewController(_ menu: LeftMenu) {
        
        switch menu {
        case .home:
                Switcher.updateRootVC()
        case .profile:
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
        case .about:
            APP_DELEGATE.strUrl = "\(Router.BASE_SERVICE_URL)get_page_aboutUs"
            APP_DELEGATE.strTitle = Languages.AboutUs
            self.slideMenuController()?.changeMainViewController(self.TermsViewController, close: true)
            
        case .privacy:
            APP_DELEGATE.strUrl = "\(Router.BASE_SERVICE_URL)get_page_privacy"
            APP_DELEGATE.strTitle = Languages.Privacypolicy
            self.slideMenuController()?.changeMainViewController(self.TermsViewController, close: true)
        case .Termd:
            APP_DELEGATE.strUrl = "\(Router.BASE_SERVICE_URL)get_page_terms"
            APP_DELEGATE.strTitle = Languages.TermsConditions
            self.slideMenuController()?.changeMainViewController(self.TermsViewController, close: true)
        case .web:
            if let url = URL(string: "http://www.emat.or.tz"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .yout:
            if let url = URL(string: "https://www.youtube.com/@emergencymedicineassociati3277"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .share:
            doShare()
        }
    }
    func doShare() {
//        if let url = URL(string: "MySpot App Check out the App at: https://play.google.com/store/apps/details?id=com.technorizen.myspot"), !url.absoluteString.isEmpty {
            let shareText = "Use this link to download EMAT App:\n https://play.google.com/store/apps/details?id=main.com.ematapp"
            let shareItems: [Any] = [shareText]
            
            let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .postToFlickr, .assignToContact, .openInIBooks]
            
            self.present(activityVC, animated: true, completion: nil)
//        }
        
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
                  Switcher.updateRootVC()
                  self.hideProgressBar()
              }
              
              
          },failureBlock: { (error : Error) in
              self.hideProgressBar()
              GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
          })
      }

    func logout() {
        let alertController = UIAlertController(title: APP_NAME, message: Languages.Areyousureyouwanttlogout, preferredStyle: .alert)
        let yesAction: UIAlertAction = UIAlertAction(title: Languages.Yes, style: .default) { action -> Void in
            UserDefaults.standard.removeObject(forKey: USERID)
            UserDefaults.standard.synchronize()
            self.WebForUpdatestatus(strStus: "OFFLINE")
            
        }
        let noAction: UIAlertAction = UIAlertAction(title: Languages.No, style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        self.logout()
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
                    self.lblProfileName.text = "\(self.dic_Profile["full_name"].stringValue)"
                    self.lbl_Email.text = self.dic_Profile["mobile"].stringValue
                    USER_DEFAULT.set(self.dic_Profile["test_done"].stringValue, forKey: TESTYESORNO)
                    self.imgProfile.sd_setImage(with: URL.init(string: (self.dic_Profile["image"].stringValue)), placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
                    APP_DELEGATE.strSpeciliat  = self.dic_Profile["type"].stringValue
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

extension LeftSlideMenuVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath) as! LeftMenuCell
        cell.img.image = menuArrImg[indexPath.row]
        cell.lbl.text = menuArrName[indexPath.row]
        return cell
    }
}

extension LeftSlideMenuVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if let menu = LeftMenu(rawValue: indexPath.row) {
                self.changeViewController(menu)
            }
        
    }
}
