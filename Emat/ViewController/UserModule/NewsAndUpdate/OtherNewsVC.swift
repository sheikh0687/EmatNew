//
//  OtherNewsVC.swift
//
//  Created by mac on 05/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class OtherNewsVC: UIViewController {
    
    @IBOutlet weak var table_Data: UITableView!
    
    var arr_Data:[JSON] = []
    
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.OTHERNEWS, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
        table_Data.estimatedRowHeight = 170
        table_Data.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        WebGet()
    }
    
    func WebGet() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        //        paramsDict["player_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_news_list.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1" ) {
                    self.arr_Data = swiftyJsonVar["result"].arrayValue
                    self.table_Data.backgroundView = UIView()
                    self.table_Data.reloadData()
                } else {
                    self.arr_Data  = []
                    self.table_Data.backgroundView = UIView()
                    self.table_Data.reloadData()
                    Utility.noDataFound("News not found", tableViewOt: self.table_Data, parentViewController: self)
                    
                }
                self.hideProgressBar()
            }
            
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    
}
extension OtherNewsVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! regionCell
        
        let dic = arr_Data[indexPath.row]
        
        var strTit:String! = ""
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            strTit = dic["title"].stringValue
        } else {
            strTit = dic["title_sw"].stringValue
        }
        
        var strdescription:String! = ""
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            strdescription = dic["description"].stringValue
        } else {
            strdescription = dic["description_sw"].stringValue
        }
        
        
        cell.lbl_Descrip.text = "\(strdescription.trimmingCharacters(in: .whitespacesAndNewlines))"
        cell.lbl_Title.text = "\(strTit.trimmingCharacters(in: .whitespacesAndNewlines))"
        let date = dic["date_time"].stringValue
        let strNew  = Utility.getStringDateFromStringDate(withAMPM: date, outputFormate: "dd/MM/yyyy HH:mm:ss")
        cell.lbl_Date.text = "\(strNew)"
        
        return cell
    }
}

extension OtherNewsVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

