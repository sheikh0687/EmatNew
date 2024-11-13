//
//  SelectResgionVC.swift
//  Emat
//
//  Created by mac on 17/01/23.
//  Copyright © 2023 com.ios.emat. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectResgionVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var text_Search: UITextField!
    @IBOutlet weak var table_Perform: UITableView!
    var arr_Peform:[JSON] = []
    var filtered:[JSON] = []
    var strAPI:String = ""

    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: "", CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
        text_Search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                              for: UIControl.Event.editingChanged)
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
            WebForGetFaq()
        } else {
                guard let data = UserDefaults.standard.value(forKey: RESGION) as? Data else { return }
                let json = JSON(data)
                arr_Peform = json["result"].arrayValue
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
            filtered = arr_Peform.filter({($0["Region"].stringValue).range(of: searchText, options: .caseInsensitive) != nil})
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
        cell.lbl_Heading.text = dic!["Region"].stringValue

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
        let vs = self.storyboard?.instantiateViewController(withIdentifier: "ResgionDetailVC") as! ResgionDetailVC
        vs.strId = dic!["id"].stringValue
        self.navigationController?.pushViewController(vs, animated: true)

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
