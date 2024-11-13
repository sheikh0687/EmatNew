//
//  NotificationDetailVC.swift
//  Emat
//
//  Created by mac on 24/01/23.
//  Copyright © 2023 com.ios.emat. All rights reserved.
//

import UIKit

class NotificationDetailVC: UIViewController {

    @IBOutlet weak var lbl_Main: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!

    var isKey:String! = ""
    var isKeyDetail:String! = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: "", CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")
      
        lbl_Main.text = isKey
        lbl_Detail.text = isKeyDetail

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
