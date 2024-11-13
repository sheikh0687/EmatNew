//
//  cpdVC.swift
//  Emat
//
//  Created by mac on 17/01/23.
//  Copyright © 2023 com.ios.emat. All rights reserved.
//

import UIKit
import SwiftyJSON

class cpdVC: UIViewController , UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var text_Search: UITextField!
    @IBOutlet weak var table_Perform: UITableView!
    var arr_Peform:[JSON] = []
    var filtered:[JSON] = []
    var strAPI:String = ""
    var strId:String = "1"
    @IBOutlet weak var btn_User: UIButton!
    @IBOutlet weak var btn_Doctor: UIButton!
    var strType:String! = "PATIENT"

    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table_Perform.estimatedRowHeight = 100
        table_Perform.rowHeight = UITableView.automaticDimension
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: "", CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
        text_Search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                              for: UIControl.Event.editingChanged)
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
        
            WebForGetFaq(strAPI: Router.get_Region_training.url())
            
        } else {
            
                guard let data = UserDefaults.standard.value(forKey: TRAINING) as? Data else { return }
                let json = JSON(data)
                arr_Peform = json["result"].arrayValue
            
        }
        
    }
    @IBAction func User(_ sender: Any) {
      
        strType = "DOCTOR"
        table_Perform.isHidden = true
        
        btn_User.backgroundColor = UIColor.init(named: THEME_COLOR_NAME)
        btn_Doctor.backgroundColor = UIColor.darkGray
       
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            WebForGetFaq(strAPI: Router.get_Region_conferences.url())
        } else {
           
            guard let data = UserDefaults.standard.value(forKey: CONFERENCE) as? Data else { return }
            let json = JSON(data)
            arr_Peform = []
            arr_Peform = json["result"].arrayValue
            print(arr_Peform)
            table_Perform.reloadData()
            table_Perform.isHidden = false

        }

    }
    @IBAction func Doctor(_ sender: Any) {
       
        strType = "PATIENT"
        table_Perform.isHidden = true
        
        btn_Doctor.backgroundColor = UIColor.init(named: THEME_COLOR_NAME)
        btn_User.backgroundColor = UIColor.darkGray
   
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
       
            WebForGetFaq(strAPI: Router.get_Region_training.url())
            
        } else {
          
            guard let data = UserDefaults.standard.value(forKey: TRAINING) as? Data else { return }
            let json = JSON(data)
            arr_Peform = []
            arr_Peform = json["result"].arrayValue
            print(arr_Peform)
            table_Perform.reloadData()
            table_Perform.isHidden = false

        }

    }

    //MARK:Searchfirld delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchActive = false;
        text_Search.text = ""
        table_Perform.reloadData()
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let searchText  = textField.text!
        if searchText.count >= 1 {
            searchActive = true
            table_Perform.isHidden = false//question//{$0.propietario.lowercased().contains(searchText)}
            filtered = arr_Peform.filter({($0["title"].stringValue).range(of: searchText, options: .caseInsensitive) != nil})
//            filtered = arr_AllCat.filter({($0["ads_details"]["title"].stringValue).range(of: searchText, options: .caseInsensitive) != nil})

        } else {
            searchActive = false;
        }
        table_Perform.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive {
            return  self.filtered.count
        }
            return arr_Peform.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! performTableCell
        
        let dic:JSON?
        
        if searchActive {
            dic = filtered[indexPath.row]
        } else {
            dic = arr_Peform[indexPath.row]
        }
        
        if strType == "DOCTOR" {
            cell.lbl_Heading.halfTextColorChange(fullText: "\(dic!["title"].stringValue), \(dic!["region_name"].stringValue), \(dic!["address"].stringValue), from \(dic!["date"].stringValue)", changeText: "\(dic!["title"].stringValue)")

        } else {
            cell.lbl_Heading.halfTextColorChange(fullText: "\(dic!["title"].stringValue), in \(dic!["location"].stringValue), \(dic!["region_name"].stringValue), \(dic!["address"].stringValue), from \(dic!["date"].stringValue)", changeText: "\(dic!["title"].stringValue)")


        }

      //  cell.lbl_Heading.text = "\(dic!["title"].stringValue), \(dic!["region_name"].stringValue), \(dic!["address"].stringValue), from \(dic!["date"].stringValue)"
//        cell.lbl_Subtitle.text = dic!["address"].stringValue
//        cell.lbl_Date.text = dic!["date"].stringValue

      //cell.lbl_Subtitle.text = "Model Year \(dic!["model_year"].stringValue)"

        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic:JSON?
        
        if searchActive {
            dic = filtered[indexPath.row]
        } else {
            dic = arr_Peform[indexPath.row]
        }
        if let url = URL(string: dic!["detail_link"].stringValue), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }

    }
    //MARK:API
    func WebForGetFaq(strAPI:String) {
        
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["region_id"]  =   strId as AnyObject

        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: strAPI, parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1") {
                    self.table_Perform.isHidden = false
                    self.arr_Peform = swiftyJsonVar["result"].arrayValue
                    self.table_Perform.reloadData()
                } else {
                    self.arr_Peform = []
                    self.table_Perform.reloadData()
                    let message = swiftyJsonVar["result"].string
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message ?? "", on: self)
                }
                self.hideProgressBar()
            }
            
            
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }

}
extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 18.0) , range: range)
//        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)! ]

        self.attributedText = attribute
    }
}
