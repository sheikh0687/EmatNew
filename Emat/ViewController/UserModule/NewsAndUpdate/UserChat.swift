
import UIKit
import SDWebImage
import SwiftyJSON

class UserChat: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var view_OldChat: UIView!
    @IBOutlet weak var lbl_ChatReason: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var vwMsg: UIView!
    @IBOutlet weak var tvMsg: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    
    var arrMsgs:[JSON] = []
    var receiverId = ""
    var userName = ""
    var userId = ""
    var strReason = ""
    var strReasonID = ""
    let strType = USER_DEFAULT.value(forKey: USER_TYPE) as! String
    var strRighTitle = ""
    var strOldChat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvMsg.textColor = UIColor.darkGray
        tvMsg.text = Languages.Sendmessage
        
        userId = kUserDefault.value(forKey: USERID) as! String
        wsGetChatAgain()
        NotificationCenter.default.addObserver(self, selector: #selector(ShowRequest), name: Notification.Name("NewMessage"), object: nil)
        
        if strType == PATIENT  {
            view_OldChat.isHidden = true
            strRighTitle = ""
        } else {
            if strOldChat == "YES" {
                vwMsg.isHidden = true
                strRighTitle = ""
                view_OldChat.isHidden = true
            } else {
                view_OldChat.isHidden = true
                strRighTitle = Languages.ENDCHAT
            }
        }
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: userName, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }
    
    override func rightClick() {
        // wsEndSendMessage()
    }
    
    @objc func ShowRequest (notification:NSNotification) {
        wsGetChatAgain()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SeeOldChat(_ sender: Any) {
        
    }
    
    @IBAction func SeeTest(_ sender: Any) {
        
    }
    
    @IBAction func actionSend(_ sender: Any) {
        if tvMsg.text == "Write here..." || tvMsg.text.count == 0 {
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: Languages.Pleaseentermessage, on: self)
        } else {
            wsSendMessage()
        }
    }
    
    //MARK: TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMsgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.chatLeft.isHidden = true
        cell.chatRight.isHidden = true
        
        let dict = arrMsgs[indexPath.row]
        self.strReason = dict["reason_name"].stringValue
        self.strReasonID = dict["reason_id"].stringValue
        //self.lbl_ChatReason.text = "\(dict["reason_name"].stringValue)"
        
        let strDate = dict["date_time"].stringValue
        
        if strDate != "0000-00-00 00:00:00" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: strDate)
            formatter.dateFormat = "dd MMM yyyy hh:mm a"
            cell.lblDate.text = formatter.string(from: date!)
        } else {
            cell.lblDate.text = ""
        }
        
        if dict["sender_id"].stringValue == userId {
            let strImage = dict["sender_detail"]["image"].stringValue
            cell.imgRight.sd_setImage(with: URL.init(string: strImage), placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
            cell.chatRight.isHidden = false
            cell.lblMsgRight.text = dict["chat_message"].stringValue
            cell.lblDate.textAlignment = .right
        } else {
            let strImage = dict["sender_detail"]["image"].stringValue
            cell.imgLeft.sd_setImage(with: URL.init(string: strImage), placeholderImage: UIImage.init(named: "Profile_Pla"), options: SDWebImageOptions(rawValue: 1), completed: nil)
            cell.chatLeft.isHidden = false
            cell.lblMsgLeft.text = dict["chat_message"].stringValue
            cell.lblDate.textAlignment = .left
        }
        return cell
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.arrMsgs.count-1, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    //MARK: TEXTVIEW DELEGATE
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == tvMsg {
            if tvMsg.textColor == UIColor.darkGray {
                tvMsg.textColor = UIColor.black
                tvMsg.text = ""
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == tvMsg {
            if tvMsg.text.count == 0 {
                tvMsg.textColor = UIColor.darkGray
                tvMsg.text = Languages.Sendmessage
            }
        }
    }
    
    //MARK: WS_SEND_MESSAGE
    
    func wsEndSendMessage()  {
        showProgressBar()
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]   =  receiverId as AnyObject
        paramDict["sender_id"]    =   kUserDefault.value(forKey: USERID)! as AnyObject
        
        CommunicationManeger.callPostApi(apiUrl: Router.end_chat_status.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"].stringValue == "successfull") {
                    self.navigationController?.popViewController(animated: true)
                    self.view.endEditing(true)
                }
                self.hideProgressBar()
            }
        }, failureBlock: { (error : Error) in
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
            self.hideProgressBar()
        })
    }
    func wsSendMessage()  {
        showProgressBar()
        
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        
        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]   =  receiverId as AnyObject
        paramDict["sender_id"]    =   kUserDefault.value(forKey: USERID)! as AnyObject
        paramDict["chat_message"]  =  tvMsg.text! as AnyObject
        paramDict["timezone"]  =  localTimeZoneIdentifier as AnyObject
        paramDict["reason_name"]  =  strReason as AnyObject
        paramDict["reason_id"]  =  strReasonID as AnyObject
        print(paramDict)
        //http://techimmense.com/PROJECT/EMAT/webservice/insert_chat?chat_message=hi&timezone=Asia/Kolkata&receiver_id=29&sender_id=52
        CommunicationManeger.callPostApi(apiUrl: Router.insert_chat.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"].stringValue == "successfull") {
                    self.tvMsg.text = ""
                    self.view.endEditing(true)
                    self.wsGetChatAgain()
                }
                self.hideProgressBar()
            }
        }, failureBlock: { (error : Error) in
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
            self.hideProgressBar()
        })
    }
    
    func wsGetChatAgain()  {
        
        showProgressBar()
        var paramDict : [String:AnyObject] = [:]
        paramDict["receiver_id"]  =   receiverId as AnyObject
        paramDict["sender_id"]  =   userId as AnyObject
        print(paramDict)
        CommunicationManeger.callPostApi(apiUrl: Router.get_chat_detail.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.arrMsgs  = swiftyJsonVar["result"].arrayValue
                    self.tblView.reloadData()
                    self.scrollToBottom()
                    self.lbl_ChatReason.isHidden = true
                }
                self.hideProgressBar()
            }
        }, failureBlock: { (error : Error) in
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
            self.hideProgressBar()
        })
    }
}
