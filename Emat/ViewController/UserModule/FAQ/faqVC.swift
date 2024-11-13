//
//  faqVC.swift
//  Autobahn
//
//  Created by mac on 15/02/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SwiftyJSON

class performTableCell:UITableViewCell {
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Heading: UILabel!
    @IBOutlet weak var img_Drop: UIImageView!
    @IBOutlet weak var lbl_Subtitle: UILabel!
}
class faqVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var table_Perform: UITableView!
    
    var arr_Peform:[JSON] = []
    var filtered:[JSON] = []

    var isInteger:Int! = -1
    var arr_Contan:NSMutableArray! = []
    var searchActive : Bool = false

    var strTitle:String = ""
    var strAPI:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        WebForGetFaq()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: strTitle, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        table_Perform.estimatedRowHeight = 200
        table_Perform.rowHeight = UITableView.automaticDimension
        
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let searchText  = textField.text!
        if searchText.count >= 1 {
            searchActive = true
            table_Perform.isHidden = false//question//{$0.propietario.lowercased().contains(searchText)}
            filtered = arr_Peform.filter({$0["question"].stringValue.lowercased().contains(searchText)})
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
        
        
        var strTit:String! = ""
        var str:String! = ""
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            strTit = dic!["question"].stringValue
        } else {
            strTit = dic!["question_sw"].stringValue
        }
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            str = dic!["answer"].stringValue
        } else {
            str = dic!["answer_sw"].stringValue
        }

        cell.lbl_Heading.text =   (strTit.trimmingCharacters(in: .whitespacesAndNewlines))
        cell.lbl_Subtitle.text =   (str.trimmingCharacters(in: .whitespacesAndNewlines))

        if arr_Contan.contains(indexPath.row)  {
            cell.img_Drop.image = UIImage.init(named: "up")
        } else {
            cell.img_Drop.image = UIImage.init(named: "down")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if arr_Contan.contains(indexPath.row) {
            return tableView.rowHeight
        } else {
            
            if indexPath.row == 6 {
                 return 100
            }
            return 80
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isInteger = indexPath.row
        if arr_Contan.contains(indexPath.row)  {
            arr_Contan.remove(indexPath.row)
        } else {
            arr_Contan.add(indexPath.row)
        }
        self.table_Perform.reloadData()
    }
    //MARK:API
    func WebForGetFaq() {
        
        showProgressBar()
        let paramsDict:[String:AnyObject] = [:]
        
        print(paramsDict)
        
        CommunicationManeger.callPostService(apiUrl: strAPI, parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
            
            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["message"] == "successfull") {
                    self.arr_Peform = swiftyJsonVar["result"].arrayValue
                    self.table_Perform.reloadData()
                } else {
                    let message = swiftyJsonVar["result"].string
                    GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: message!, on: self)
                }
                self.hideProgressBar()
            }
            
            
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
}
