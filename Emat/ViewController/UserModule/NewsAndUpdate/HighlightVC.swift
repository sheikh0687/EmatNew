//
//  HighlightVC.swift
//
//  Created by mac on 15/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class HighlightVC: UIViewController {
    
    @IBOutlet weak var table_Data: UITableView!
    var strTitl:String! = ""
    var arr_Data:[JSON] = []
    
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: strTitl, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
        // table_Data.estimatedRowHeight = 170
        // table_Data.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        WebGet()
    }
    
    func WebGet() {
        showProgressBar()
        let paramsDict:[String:AnyObject] = [:]
        //        paramsDict["player_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.get_news_press_list.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            
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
                    Utility.noDataFound("News press not found", tableViewOt: self.table_Data, parentViewController: self)
                    
                }
                self.hideProgressBar()
            }
            
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    
}
extension HighlightVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! regionCell
        
        let dic = arr_Data[indexPath.row]
        let strImage = dic["image"].stringValue
        let date = dic["date_time"].stringValue
        cell.img_News.sd_setImage(with: URL.init(string: strImage), placeholderImage: UIImage.init(named: "placeholderB"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        
        let strNew  = Utility.getStringDateFromStringDate(withAMPM: date, outputFormate: "dd/MM/yyyy HH:mm:ss")
        cell.lbl_Date.text = "\(strNew)"
        
        return cell
    }
}

extension HighlightVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = arr_Data[indexPath.row]
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
        objVC.str_Image = dic["image"].stringValue
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}


