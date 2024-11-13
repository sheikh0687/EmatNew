//
//  ChatConversationVC.swift
//  HalaMotor
//
//  Created by mac on 16/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ChatConversationCell: UITableViewCell {
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Count: UILabel!
    @IBOutlet weak var img_User: UIImageView!
    @IBOutlet weak var lbl_UserBName: UILabel!
    @IBOutlet weak var lbl_TimeAgo: UILabel!
    @IBOutlet weak var lbl_Message: UILabel!
}
class ChatConversationVC: UIViewController {
    
    @IBOutlet weak var table_Chat: UITableView!
    var arr_List:[JSON] = []
    var strReason = ""
    var strReasonID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Message, CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        table_Chat.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getDataGetChatList()

    }
    override func leftClick() {
        self.navigationController?.popViewController(animated: true)
    }
    func getDataGetChatList() {
        showProgressBar()
        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject

        CommunicationManeger.callPostApi(apiUrl: Router.get_active_doctor_list.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
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
    func wsEndSendMessage(strRe:String,strFullname:String)  {
        showProgressBar()
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]   =  strRe as AnyObject
        paramDict["sender_id"]    =   kUserDefault.value(forKey: USERID)! as AnyObject

        CommunicationManeger.callPostApi(apiUrl: Router.start_chat_status.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"].stringValue == "successfull") {

                    let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "UserChat") as! UserChat
                    objVC.receiverId = strRe
                    objVC.userName = strFullname
                    objVC.strReason = self.strReason
                    objVC.strReasonID = self.strReasonID
                    self.navigationController?.pushViewController(objVC, animated: true)
                }
                self.hideProgressBar()
            }
        }, failureBlock: { (error : Error) in
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
            self.hideProgressBar()
        })
    }
    
}
extension ChatConversationVC: UITableViewDataSource {
    
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
//        cell.lbl_Message.text = "MCT_No : \(dic["MCT_No"].stringValue)"
//        cell.lbl_TimeAgo.text = dic["time_ago"].stringValue
        
        let imgLogoUrl = dic["image"].stringValue
            let urlwithPercentEscapes = imgLogoUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let urlLogo = URL(string: urlwithPercentEscapes!)
        cell.img_User.sd_setImage(with: urlLogo, placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
       
        return cell
    }
    
}

extension ChatConversationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = arr_List[indexPath.row]
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "UserChat") as! UserChat
        objVC.receiverId = dic["id"].stringValue
        objVC.userName = dic["full_name"].stringValue
        objVC.strReason = self.strReason
        objVC.strReasonID = self.strReasonID
        self.navigationController?.pushViewController(objVC, animated: true)

//        wsEndSendMessage(strRe: dic["id"].stringValue, strFullname: dic["full_name"].stringValue)
    }
}
