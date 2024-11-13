//
//  YourSelfTestVC.swift
//
//  Created by mac on 06/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class selTestCell:UITableViewCell {
    @IBOutlet weak var lbl_Question: UILabel!
    @IBOutlet weak var lbl_Answer: UILabel!
}
class YourSelfTestVC: UIViewController {
    
    @IBOutlet weak var table_List: UITableView!
    
    var arrList:[JSON] = []
    var strType:String! = ""
    var receiverId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem(LeftTitle: "", LeftImage: "menu", CenterTitle: Languages.Yourselftest, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
    }
    override func leftClick() {
        if strType == "YES" {
            self.navigationController?.popViewController(animated: true)
        } else {
            toggleLeft()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         getDealer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    func getDealer() {
        
        showProgressBar()
        
        var paramDict : [String:AnyObject] = [:]
        
        if strType == "YES" {
            paramDict["user_id"]  =    receiverId as AnyObject
        } else {
            paramDict["user_id"]  =    USER_DEFAULT.value(forKey: USERID) as AnyObject
        }

        
        CommunicationManeger.callPostApi(apiUrl: Router.get_user_test_list.url(), parameters: paramDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"].stringValue == "1") {
                    self.arrList  = swiftyJsonVar["result"].arrayValue
                    self.table_List.reloadData()
                }
                self.hideProgressBar()
            }
        }, failureBlock: { (error : Error) in
            Utility.showAlertMessage(withTitle: EMPTY_STRING, message: (error.localizedDescription), delegate: nil,parentViewController: self)
            self.hideProgressBar()
        })
    }
    
}
extension YourSelfTestVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return arrList[section]["test_question_details"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! selTestCell
        
        let dic = arrList[indexPath.section]["test_question_details"][indexPath.row]
        
        let dicQuestio = dic["question"]
        cell.lbl_Answer.text = dic["answer"].stringValue
        cell.lbl_Question.text = dicQuestio["question"].stringValue
   
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let dic = arrList[section]
        let dicRisk = dic["risk_details"]
        let customInfoWindow1 = Bundle.main.loadNibNamed("SelfTest", owner: self, options: nil)?[0] as! SelfTest
        customInfoWindow1.lbl_TestNumber.text = "TEST\(section + 1)"
        
        let dateD = GlobalConstant.getDateFromStringWithFormat(strFormate: "yyyy-MM-dd HH:mm:ss", date: dic["date_time"].stringValue)
        let convertDa = GlobalConstant.getStringDateFromDateWithFormat(strFormate: "dd/MM/yyyy HH:mm:ss", date: dateD)

        customInfoWindow1.lbl_Date.text = convertDa
        customInfoWindow1.lbl_Result.text = dicRisk["test_result"].stringValue
        customInfoWindow1.lbl_ResultDescri.text = dicRisk["title"].stringValue

        return customInfoWindow1

    }
}

extension YourSelfTestVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
