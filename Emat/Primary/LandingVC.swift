//
//  ViewController.swift
//  F5Places
//
//  Created by mac on 22/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


class LandingVC: UIViewController {

    @IBOutlet weak var btn_En: UIButton!
    @IBOutlet weak var btn_K: UIButton!
    var strLang:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //strLang = LanguageIdEnum.english.rawValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if USER_DEFAULT.value(forKey: LanguageUser) as! String == LanguageIdEnum.english.rawValue {
            btn_En.setImage(UIImage.init(named: "check"), for: .normal)
            btn_K.setImage(UIImage.init(named: "uncheck"), for: .normal)
        } else {
            btn_K.setImage(UIImage.init(named: "check"), for: .normal)
            btn_En.setImage(UIImage.init(named: "uncheck"), for: .normal)
        }
    }
    
    @IBAction func English(_ sender: Any) {
        strLang = LanguageIdEnum.english.rawValue
        LLanguage.appleLanguage = strLang
        UserDefaults.standard.set(strLang, forKey: LanguageUser)
        LLocalizer.doBaseInternationalization()
        Switcher.updateRootVC()
        btn_En.setImage(UIImage.init(named: "check"), for: .normal)
        btn_K.setImage(UIImage.init(named: "uncheck"), for: .normal)
    }
    
    @IBAction func Kiswahilo(_ sender: Any) {
        strLang = LanguageIdEnum.tanzania.rawValue
        LLanguage.appleLanguage = LanguageIdEnum.tanzania.rawValue
        UserDefaults.standard.set(strLang, forKey: LanguageUser)
        LLocalizer.doBaseInternationalization()
        Switcher.updateRootVC()
        btn_K.setImage(UIImage.init(named: "check"), for: .normal)
        btn_En.setImage(UIImage.init(named: "uncheck"), for: .normal)
    }
    
    @IBAction func Next(_ sender: UIButton) {
      

        let objVC = kStoryboardMain.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
   
}
