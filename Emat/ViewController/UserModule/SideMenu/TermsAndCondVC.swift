//
//  TermsAndCondVC.swift
//  HalaMotor
//
//  Created by mac on 09/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class TermsAndCondVC: UIViewController {
    
    var strTitle:String! = ""
    
    @IBOutlet weak var lbl_Desc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        /* let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
         self.view.addSubview(webView)
         let url = URL(string: APP_DELEGATE.strUrl)
         webView.load(URLRequest(url: url!))*/
        GetProfile()
        lbl_Desc.text = ""
        setNavigationBarItem(LeftTitle: "", LeftImage: "menu", CenterTitle: APP_DELEGATE.strTitle, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }
    override func leftClick() {
        toggleLeft()
    }
    func GetProfile() {
          showProgressBar()

          var paramsDict:[String:AnyObject] = [:]
          paramsDict["user_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: APP_DELEGATE.strUrl, parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                  if(swiftyJsonVar["status"].stringValue == "1") {
                      self.lbl_Desc.text  = swiftyJsonVar["result"]["description"].stringValue
                  } else {
                  }
                  self.hideProgressBar()
              }
              
              
          },failureBlock: { (error : Error) in
              self.hideProgressBar()
              GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
          })
      }

}
