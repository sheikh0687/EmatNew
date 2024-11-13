//
//  ScreeningVC.swift
//
//  Created by mac on 05/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class LandingCell: UICollectionViewCell {
    @IBOutlet weak var img_Corona: UIImageView!
    @IBOutlet weak var btn_yes: UIButton!
    @IBOutlet weak var btn_No: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
}

class ScreeningVC: UIViewController {

    @IBOutlet weak var lbl_popDescri: UILabel!
    @IBOutlet weak var lbl_popTitle: UILabel!
    @IBOutlet weak var img_Pop: UIImageView!
    @IBOutlet weak var view_TranView: UIView!
    @IBOutlet weak var img_Result: UIImageView!
    @IBOutlet weak var lbl_Result: UILabel!
    @IBOutlet weak var lbl_Answer: UILabel!
    @IBOutlet weak var view_Result: UIView!
    @IBOutlet weak var collectionViewOt: UICollectionView!
//    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var lbl_Digno: UILabel!
    
    var arr_id: [String] = []
    var arr_Answer: [String] = []
    var arr_Point: [String] = []

    var arr_Ques:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: Languages.Screening, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

    }
    override func viewWillAppear(_ animated: Bool) {
            WebGetPopUp()
            WebGet()
        view_TranView.isHidden = true
        view_Result.isHidden = true
    }
    
    @IBAction func RestartTest(_ sender: Any) {
        view_Result.isHidden = true
        self.collectionViewOt.isHidden = false
        self.collectionViewOt.scrollToItem(at:IndexPath(item: 0, section: 0), at: .left, animated: true)

        self.WebGet()

    }
    
    @IBAction func proceed(_ sender: Any) {
        self.view_TranView.isHidden = true
    }
    func WebGetPopUp() {
           showProgressBar()
          let paramsDict:[String:AnyObject] = [:]
           print(paramsDict)
           CommunicationManeger.callPostService(apiUrl: Router.get_test_starting.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in

               DispatchQueue.main.async {
                   let swiftyJsonVar = JSON(responseData)
                   print(swiftyJsonVar)
                   if(swiftyJsonVar["status"] == "1" ) {
                       let dic = swiftyJsonVar["result"]
                    
                        var strTit:String! = ""
                       
                       if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
                           strTit = "\(dic["title"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines))"
                       } else {
                           strTit = "\(dic["title_sw"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines))"
                       }
                       
                       var strdescription:String! = ""
                       
                       if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
                           strdescription = "\(dic["description"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines))"
                       } else {
                           strdescription = "\(dic["description_sw"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines))"
                       }
                    
                        self.lbl_popTitle.text = strTit
                        self.lbl_popDescri.text = strdescription
                        self.img_Pop.sd_setImage(with: URL.init(string: (dic["image"].stringValue)), placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions(rawValue: 1), completed: nil)
                        self.view_TranView.isHidden = false
                   }
                   self.hideProgressBar()
               }

           },failureBlock: { (error : Error) in
               self.hideProgressBar()
               GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
           })
       }
      func GetProfile() {
          showProgressBar()

          var paramsDict:[String:AnyObject] = [:]
          paramsDict["user_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
          print(paramsDict)
          
          CommunicationManeger.callPostService(apiUrl: Router.get_profile.url(), parameters: paramsDict, Method: .post, parentViewController: self, successBlock: { (responseData, message) in
              
              DispatchQueue.main.async {
                  let swiftyJsonVar = JSON(responseData)
                  print(swiftyJsonVar)
                  if(swiftyJsonVar["status"].stringValue == "1") {
                      let dic_Profile = swiftyJsonVar["result"]
                      USER_DEFAULT.set(dic_Profile["test_done"].stringValue, forKey: TESTYESORNO)
                      
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
    func WebGet() {
         showProgressBar()
        let paramsDict:[String:AnyObject] = [:]

         print(paramsDict)
         CommunicationManeger.callPostService(apiUrl: Router.get_question_list.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in

             DispatchQueue.main.async {
                 let swiftyJsonVar = JSON(responseData)
                 print(swiftyJsonVar)
                 if(swiftyJsonVar["status"] == "1" ) {
                     self.arr_Ques = []
                     self.arr_id = []
                     self.arr_Answer = []
                     self.arr_Point = []
                     self.arr_Ques = swiftyJsonVar["result"].arrayValue
                     self.collectionViewOt.backgroundView = UIView()
                     self.collectionViewOt.reloadData()

                 } else {
                    self.arr_Ques  = []
                    self.collectionViewOt.backgroundView = UIView()
                    self.collectionViewOt.reloadData()
                }
                 self.hideProgressBar()
             }

         },failureBlock: { (error : Error) in
             self.hideProgressBar()
             GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
         })
     }
    func WebGetAnswer(strId:String,strPoint:String,strAnswer:String) {
        showProgressBar()
        var paramsDict:[String:AnyObject] = [:]
        paramsDict["user_id"]  =   USER_DEFAULT.value(forKey: USERID) as AnyObject
        paramsDict["question_id"]  =   strId as AnyObject
        paramsDict["answer"]  =   strAnswer as AnyObject
        paramsDict["point"]  =   strPoint as AnyObject

        print(paramsDict)
        CommunicationManeger.callPostService(apiUrl: Router.add_user_test.url(), parameters: paramsDict, Method: .get, parentViewController: self, successBlock: { (responseData, message) in

            DispatchQueue.main.async {
                let swiftyJsonVar = JSON(responseData)
                print(swiftyJsonVar)
                if(swiftyJsonVar["status"] == "1" ) {
                    let dic = swiftyJsonVar["result"]
                    self.lbl_Answer.text = dic["title"].stringValue
                    self.lbl_Result.text = dic["test_result"].stringValue
                    self.lbl_Digno.text = dic["severe"].stringValue
                    self.img_Result.sd_setImage(with: URL.init(string: (dic["image"].stringValue)), placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions(rawValue: 1), completed: nil)
                    self.GetProfile()
                    self.collectionViewOt.isHidden = true
                    self.view_Result.isHidden = false

                } else {
               }
                self.hideProgressBar()
            }

        },failureBlock: { (error : Error) in
            self.hideProgressBar()
            GlobalConstant.showAlertMessage(withOkButtonAndTitle: APPNAME, andMessage: (error.localizedDescription), on: self)
        })
    }
}

extension ScreeningVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_Ques.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingCell", for: indexPath) as! LandingCell
       
        let dic = arr_Ques[indexPath.row]

        cell.img_Corona.sd_setImage(with: URL.init(string: (dic["image"].stringValue)), placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions(rawValue: 1), completed: nil)
        
        var strTit:String! = ""
        
        if LanguageIdEnum.english.rawValue ==  USER_DEFAULT.value(forKey: LanguageUser) as! String {
            strTit = dic["question"].stringValue
        } else {
            strTit = dic["question_sw"].stringValue
        }

        cell.lbl_title.text = strTit

        cell.btn_No.tag = indexPath.row
        cell.btn_No.addTarget(self, action: #selector(clcikOnNo), for: .touchUpInside)
        
        cell.btn_yes.tag = indexPath.row
        cell.btn_yes.addTarget(self, action: #selector(clcikOnYes), for: .touchUpInside)

        return cell
    }
    @objc func clcikOnNo(button:UIButton)  {
        let dic = arr_Ques[button.tag]
        answerByUser(strYesorNo: "NO", strId: dic["id"].stringValue, indexNumber: button.tag, strpoint: "0")

    }
    @objc func clcikOnYes(button:UIButton)  {
        let dic = arr_Ques[button.tag]
        answerByUser(strYesorNo: "YES", strId: dic["id"].stringValue, indexNumber: button.tag, strpoint: "1")
    }
    func answerByUser(strYesorNo:String,strId:String,indexNumber:Int,strpoint:String)  {
        
        self.arr_id.append(strId)
        self.arr_Point.append(strpoint)
        self.arr_Answer.append(strYesorNo)

        print(indexNumber)
        print(arr_Ques.count)

        if arr_Ques.count != indexNumber + 1 {
            self.collectionViewOt.scrollToItem(at:IndexPath(item: indexNumber + 1, section: 0), at: .right, animated: true)
        } else {
            
            WebGetAnswer(strId: self.arr_id.joined(separator: ","), strPoint: self.arr_Point.joined(separator: ","), strAnswer: self.arr_Answer.joined(separator: ","))
            print("Yeese please result")
        }

    }
}

extension ScreeningVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widths = UIScreen.main.bounds.width // 414
        return CGSize(width: self.collectionViewOt.frame.width, height: self.collectionViewOt.frame.height)
    }
}
