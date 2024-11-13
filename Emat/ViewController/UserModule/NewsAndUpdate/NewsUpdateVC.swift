//
//  NewsUpdateVC.swift
//
//  Created by mac on 05/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class NewsCell:UITableViewCell {
    @IBOutlet weak var lbl_Case: UILabel!
    @IBOutlet weak var lbl_TotalCount: UILabel!
    
}
class NewsUpdateVC: UIViewController {
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var table_Data: UITableView!
    @IBOutlet weak var height_Table: NSLayoutConstraint!
    
    var arr_Data:[JSON] = []

    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.NEWSUPDATES, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        lbl_Date.text = GlobalConstant.getStringDateFromDateWithFormat(strFormate: "MM/dd/yyyy HH:mm:ss", date: date)

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
        CommunicationManeger.callPostService(apiUrl: Router.get_news_latest_list.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1" ) {
                    self.arr_Data = swiftyJsonVar["result"].arrayValue
                    self.table_Data.backgroundView = UIView()
                    self.height_Table.constant = CGFloat(self.arr_Data.count * 70)
                    self.table_Data.reloadData()
                } else {
                   self.arr_Data  = []
                   self.table_Data.backgroundView = UIView()
                   self.table_Data.reloadData()
                   Utility.noDataFound("Data not found", tableViewOt: self.table_Data, parentViewController: self)

               }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    @IBAction func Region(_ sender: UIButton) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "RegionWiseVC") as! RegionWiseVC
        objVC.strTitl = sender.titleLabel?.text!
        self.navigationController?.pushViewController(objVC, animated: true)

    }
    
    @IBAction func highLights(_ sender: UIButton) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "HighlightVC") as! HighlightVC
        objVC.strTitl = sender.titleLabel?.text!
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    @IBAction func OtherNews(_ sender: Any) {
        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "OtherNewsVC") as! OtherNewsVC
        self.navigationController?.pushViewController(objVC, animated: true)

    }
}
extension NewsUpdateVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
       
        let dic = arr_Data[indexPath.row]
        cell.lbl_Case.backgroundColor = GlobalConstant.hexStringToUIColor(dic["color_code"].stringValue)
        cell.lbl_TotalCount.backgroundColor = GlobalConstant.hexStringToUIColor(dic["color_code"].stringValue)
       
        var strTit:String! = ""

        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            strTit = dic["title"].stringValue
        } else {
            strTit = dic["title_sw"].stringValue
        }
        

        
        cell.lbl_Case.text = "  \(strTit.replace(string: "\r\n", replacement: ""))"
        cell.lbl_TotalCount.text = "\(dic["total_case"].stringValue)"
        let date_time = dic["date_time"].stringValue

        if indexPath.row == 0 {
            let dateD = GlobalConstant.getDateFromStringWithFormat(strFormate: "yyyy-MM-dd HH:mm:ss", date: date_time)
            lbl_Date.text = GlobalConstant.getStringDateFromDateWithFormat(strFormate: "dd/MM/yyyy HH:mm:ss", date: dateD)
        }

        return cell
    }
}

extension NewsUpdateVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dic = arr_pdf[indexPath.row]
//        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "PDFDeatilVC") as! PDFDeatilVC
//        objVC.strPDF = dic["pdf_link"].stringValue
//        self.navigationController?.pushViewController(objVC, animated: true)
    }
}
extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }

