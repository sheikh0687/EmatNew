//
//  ChatuserlistVC.swift
//  Emat
//
//  Created by mac on 15/09/20.
//  Copyright © 2020 com.ios.emat. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class ChatuserlistVC: UIViewController  {
    
    @IBOutlet weak var table_Chat: UITableView!
    var arr_List:[JSON] = []
    var strReason = ""
    var strReasonID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Message, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        table_Chat.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getDataGetChatList()
        table_Chat.estimatedRowHeight = 120
        table_Chat.rowHeight = UITableView.automaticDimension
    }
    override func leftClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func getDataGetChatList() {
        showProgressBar()
        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject

        CommunicationManeger.callPostApi(apiUrl: Router.get_conversation_detail.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
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
    func wsEndSendMessage(strRe:String)  {
        showProgressBar()
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]   =  strRe as AnyObject
        paramDict["sender_id"]    =   kUserDefault.value(forKey: USERID)! as AnyObject

        CommunicationManeger.callPostApi(apiUrl: Router.delete_conversation.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["result"].stringValue == "successful") {
                    self.getDataGetChatList()
                }
                self.hideProgressBar()
            }
        }, failureBlock: { (error : Error) in
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
            self.hideProgressBar()
        })
    }
    
}
extension ChatuserlistVC: UITableViewDataSource {
    
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
        cell.lbl_Message.text = dic["last_message"].stringValue
        cell.lbl_Date.text = dic["time_ago"].stringValue
        cell.lbl_Count.text = dic["no_of_message"].stringValue

        let imgLogoUrl = dic["image"].stringValue
            let urlwithPercentEscapes = imgLogoUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let urlLogo = URL(string: urlwithPercentEscapes!)
        cell.img_User.sd_setImage(with: urlLogo, placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
       
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(goToNew), for: .touchUpInside)
                   
        return cell
    }
               
    @objc func goToNew(butto:UIButton)  {
        let dic = self.arr_List[butto.tag]
        wsEndSendMessage(strRe: dic["receiver_id"].stringValue)
    }
    
}

extension ChatuserlistVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = arr_List[indexPath.row]
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "UserChat") as! UserChat
        objVC.receiverId = dic["sender_id"].stringValue
        objVC.userName = dic["full_name"].stringValue
        objVC.strReason = self.strReason
        objVC.strReasonID = self.strReasonID
        self.navigationController?.pushViewController(objVC, animated: true)

//        wsEndSendMessage(strRe: dic["id"].stringValue, strFullname: dic["full_name"].stringValue)
    }
}
