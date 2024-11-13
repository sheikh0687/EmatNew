//
//  ChangeLanguageVC.swift
//  DB10
//
//  Created by mac on 03/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit

class changeCell:UITableViewCell {
    @IBOutlet weak var img_Check: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    
}
class ChangeLanguageVC: UIViewController {
    var strLang:String! = ""

    @IBOutlet weak var table_Lang: UITableView!
    var isIndex:Int! = 0
    var arrLan:[String] = ["English","Kiswahili"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarItem(LeftTitle: "", LeftImage: "menu", CenterTitle: Languages.ChangeLanguage, CenterImage: "", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        // Do any additional setup after loading the view.
    }
    
    override func leftClick() {
        toggleLeft()
    }
    @IBAction func Submit(_ sender: Any) {
        LLanguage.appleLanguage = strLang
        UserDefaults.standard.set(strLang, forKey: LanguageUser)
        LLocalizer.doBaseInternationalization()
        Switcher.updateRootVC()
    }
    
  
}
extension ChangeLanguageVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! changeCell
        cell.lbl_Name.text = arrLan[indexPath.row]
        
        if indexPath.row == isIndex {
            cell.img_Check.image = UIImage.init(named: "check")
        } else {
            cell.img_Check.image = UIImage.init(named: "uncheck")
        }
        return cell
    }
}

extension ChangeLanguageVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isIndex = indexPath.row
        if indexPath.row == 0 {
            strLang = LanguageIdEnum.english.rawValue
        } else {
            strLang = LanguageIdEnum.tanzania.rawValue

        }
        table_Lang.reloadData()
    }
}
