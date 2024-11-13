//
//  PreventionDetailVC.swift
//
//  Created by mac on 05/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class PreventionDetailVC: UIViewController {
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Des: UILabel!
    
    @IBOutlet weak var lbl_Title1: UILabel!
    
    @IBOutlet weak var lbl_Des1: UILabel!
    
    @IBOutlet weak var lbl_Title2: UILabel!
    @IBOutlet weak var lbl_Des2: UILabel!
    
    @IBOutlet weak var lbl_Title3: UILabel!
    @IBOutlet weak var lbl_Des3: UILabel!
    
    @IBOutlet weak var lbl_Title4: UILabel!
    @IBOutlet weak var lbl_Des4: UILabel!
    
    @IBOutlet weak var lbl_Title5: UILabel!
    @IBOutlet weak var lbl_Des5: UILabel!
    
    var dic:JSON!
    var strAPI:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: "", CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        if strAPI == Router.get_drugs.url() {
             lbl_Des.text =   dic["short_description"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             lbl_Title.text = dic["title"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             
             lbl_Des1.text =   dic["description_Indication"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             lbl_Title1.text = "Does and Indication"


             lbl_Des2.text =   dic["description1_Pharmacology"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             lbl_Title2.text = "Pharmacology"

             lbl_Des3.text =   dic["description2_Pregnancy"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             lbl_Title3.text = "Pregnancy and Lacation"

             lbl_Des4.text =   dic["description3_Interaction"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             lbl_Title4.text = "Interaction"

             lbl_Des5.text =   dic["description4_Warnings"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
             lbl_Title5.text = "Warnings"

        } else {
            lbl_Des.text =   dic["short_description"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            lbl_Title.text = "\(dic["title"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)) \(dic["code"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines))"
            
            lbl_Des1.text =   dic["Clinical_features"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            lbl_Title1.text = "Clinical features"


            lbl_Des2.text =   dic["Investigations"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            lbl_Title2.text = "Investigations"

            lbl_Des3.text =   dic["Management"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            lbl_Title3.text = "Management"

            lbl_Des4.text =   ""
            lbl_Title4.text = ""

            lbl_Des5.text =   ""
            lbl_Title5.text = ""

        }

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        if dic["pdf"].stringValue == "" {
//            viewMore.isHidden = true
//        }
        
    }
    @IBAction func more_Detail(_ sender: Any) {

    }
    
   

}
