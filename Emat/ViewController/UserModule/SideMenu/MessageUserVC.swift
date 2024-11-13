//
//  MessageUserVC.swift
//
//  Created by mac on 10/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MessageUserVC: UIViewController {
        
        @IBOutlet weak var table_Chat: UITableView!
        var arr_List:[JSON] = []
        var strReason = ""
        var strReasonID = ""
        var strOldChat = ""
        var strReviverID = ""

        override func viewDidLoad() {
            super.viewDidLoad()
            
            setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Message, CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

            table_Chat.tableFooterView = UIView()
            getDataGetChatList()
            // Do any additional setup after loading the view.
        }
        override func leftClick() {
            if strOldChat == "YES" {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.toggleLeft()
            }
        }
        func getDataGetChatList() {
            showProgressBar()
            var paramDict : [String:AnyObject] = [:]
           
            var strAPI:String! = ""
            
            if strOldChat == "YES" {
                strAPI = Router.get_conversation_history_detail.url()
                paramDict["receiver_id"]  =   strReviverID as AnyObject

            } else {
                strAPI = Router.get_conversation_detail.url()
                paramDict["receiver_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject

            }
            
            CommunicationManeger.callPostApi(apiUrl: strAPI, parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
                DispatchQueue.main.async {
                    let swiftyJsonVar = JSON(responseData)
                    print(swiftyJsonVar)
                    if(swiftyJsonVar["status"].stringValue == "1") {
                        self.arr_List  = swiftyJsonVar["result"].arrayValue
                        self.table_Chat.reloadData()
                    }
                    self.hideProgressBar()
                }
            }, failureBlock: { (error : Error) in
                Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
                self.hideProgressBar()
            })
        }
        
        
    }
    extension MessageUserVC: UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arr_List.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatConversationCell
            let dic = self.arr_List[indexPath.row]
            
            cell.lbl_UserBName.text = dic["full_name"].stringValue
            cell.lbl_Message.text = "\(dic["last_message"].stringValue)"
            cell.lbl_TimeAgo.text = dic["date"].stringValue
            
            let imgLogoUrl = dic["image"].stringValue
                let urlwithPercentEscapes = imgLogoUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
            let urlLogo = URL(string: urlwithPercentEscapes!)
            cell.img_User.sd_setImage(with: urlLogo, placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
           
            return cell
        }
        
    }

    extension MessageUserVC: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let dic = arr_List[indexPath.row]
            let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "UserChat") as! UserChat
            
            if strOldChat == "YES" {
                if  dic["sender_id"].stringValue != kUserDefault.value(forKey: USERID)! as! String {
                    objVC.receiverId = dic["sender_id"].stringValue
                } else {
                    objVC.receiverId = dic["receiver_id"].stringValue
                }
            } else {
                objVC.receiverId = dic["id"].stringValue
            }
            objVC.userName = dic["full_name"].stringValue
            objVC.strReason = strReason
            objVC.strReasonID = strReasonID
            objVC.strOldChat = strOldChat

            self.navigationController?.pushViewController(objVC, animated: true)    }

    }
