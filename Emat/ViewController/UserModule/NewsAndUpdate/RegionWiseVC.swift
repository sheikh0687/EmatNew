//
//  RegionWiseVC.swift
//
//  Created by mac on 05/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
class regionCell:UITableViewCell {
    
    @IBOutlet weak var width_image: NSLayoutConstraint!
    @IBOutlet weak var btn_Click: UIButton!
    @IBOutlet weak var lbl_Descrip: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_News: UIImageView!
}
class RegionWiseVC: UIViewController {
    @IBOutlet weak var table_Data: UITableView!
    var strTitl:String! = ""

    var arr_Data:[JSON] = []

    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle:strTitl, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
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
        CommunicationManeger.callPostService(apiUrl: Router.get_Regions_case_list.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in

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
                   Utility.noDataFound("Data not found", tableViewOt: self.table_Data, parentViewController: self)

               }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

}
extension RegionWiseVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsCell
       
        let dic = arr_Data[indexPath.row]
//        cell.lbl_Case.backgroundColor = GlobalConstant.hexStringToUIColor(dic["color_code"].stringValue)
//        cell.lbl_TotalCount.backgroundColor = GlobalConstant.hexStringToUIColor(dic["color_code"].stringValue)
        let str = dic["Region"].stringValue.removeWhitespace()
        cell.lbl_Case.text = "  \(str.replace(string: "\r\n", replacement: ""))"
        cell.lbl_TotalCount.text = "\(dic["total_case"].stringValue)"

        return cell
    }
}

extension RegionWiseVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let dic = arr_pdf[indexPath.row]
//        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "PDFDeatilVC") as! PDFDeatilVC
//        objVC.strPDF = dic["pdf_link"].stringValue
//        self.navigationController?.pushViewController(objVC, animated: true)
    }
}
