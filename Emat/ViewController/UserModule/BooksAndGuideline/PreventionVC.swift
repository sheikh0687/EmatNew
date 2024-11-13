//
//  PreventionVC.swift
//
//  Created by mac on 05/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class PreventionVC: UIViewController {
    
    @IBOutlet weak var table_Data: UITableView!
    
    var arr_Data:[JSON] = []
    var strTitle:String = ""
    var strAPI:String = ""
    
    var filtered:[JSON] = []
    var searchActive : Bool = false
    
    @IBOutlet weak var text_Search: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: strTitle, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
        
        table_Data.estimatedRowHeight = 140
        table_Data.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        
        text_Search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                              for: UIControl.Event.editingChanged)
        
        
        if Utility.checkNetworkConnectivityWithDisplayAlert(isShowAlert: true) {
                  WebGet()
              } else {
                  if strTitle == "Books" {
                      guard let data = UserDefaults.standard.value(forKey: BOOKS) as? Data else { return }
                      let json = JSON(data)
                      arr_Data = json["result"].arrayValue
                  } else {
                      guard let data = UserDefaults.standard.value(forKey: GUIDLINE) as? Data else { return }
                      let json = JSON(data)
                      arr_Data = json["result"].arrayValue
                  }
              }
      

    }
    override func viewWillAppear(_ animated: Bool) {
    }
    //MARK:Searchfirld delegate
       
       func textFieldDidEndEditing(_ textField: UITextField) {
           searchActive = false;
           text_Search.text = ""
           table_Data.reloadData()
           
       }
       @objc func textFieldDidChange(_ textField: UITextField) {
           
           let searchText  = textField.text!
           if searchText.count >= 1 {
               searchActive = true
               table_Data.isHidden = false//question//{$0.propietario.lowercased().contains(searchText)}
               filtered = arr_Data.filter({$0["title"].stringValue.lowercased().contains(searchText)})
           } else {
               searchActive = false;
           }
           table_Data.reloadData()
       }
    func WebGet() {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        //        paramsDict["player_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        
        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: strAPI, parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in
            
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
                    Utility.noDataFound("Not found", tableViewOt: self.table_Data, parentViewController: self)
                    
                }
                self.hideProgressBar()
            }
            
        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
    
}
extension PreventionVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
                 return  self.filtered.count
             }
        return arr_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! regionCell
        
     
        let dic:JSON!
               
               if searchActive {
                   dic = filtered[indexPath.row]
               } else {
                   dic = arr_Data[indexPath.row]
               }
        
        var strTit:String! = ""
        var str:String! = ""
        
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            strTit = dic["title"].stringValue
        } else {
            strTit = dic["title_sw"].stringValue
        }
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            str = dic["description"].stringValue
        } else {
            str = dic["description_sw"].stringValue
        }
        if strTitle == "Books" {
            cell.img_News.sd_setImage(with: URL.init(string: (dic["image"].stringValue)), placeholderImage: UIImage.init(named: "Treat"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        } else {
            cell.width_image.constant = -10
            cell.img_News.isHidden = true
        }
        cell.lbl_Descrip.text = (str.trimmingCharacters(in: .whitespacesAndNewlines))
        cell.lbl_Title.text = (strTit.trimmingCharacters(in: .whitespacesAndNewlines))
        
        cell.btn_Click.tag = indexPath.row
        cell.btn_Click.addTarget(self, action: #selector(goToNew), for: .touchUpInside)
        
        return cell
    }
    
    @objc func goToNew(butto:UIButton)  {
         let dic:JSON!
                    
                    if searchActive {
                        dic = filtered[butto.tag]
                    } else {
                        dic = arr_Data[butto.tag]
                    }
        
        let vs = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        vs.strUrl = dic["pdf"].stringValue
        self.navigationController?.pushViewController(vs, animated: true)

    }
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 180
     }*/
}

extension PreventionVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let dic:JSON!
                    
                    if searchActive {
                        dic = filtered[indexPath.row]
                    } else {
                        dic = arr_Data[indexPath.row]
                    }
        
//        let vs = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
//        vs.strUrl = dic["pdf"].stringValue
//        self.navigationController?.pushViewController(vs, animated: true)
    }
}

