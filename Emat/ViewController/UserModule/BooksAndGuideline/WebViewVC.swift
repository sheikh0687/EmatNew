//
//  WebViewVC.swift
//  Autobahn
//
//  Created by mac on 07/03/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class WebViewVC: UIViewController {
  
    @IBOutlet weak var web_View: UIWebView!
    var strUrl:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressBar()

        setNavigationBarItem(LeftTitle: "", LeftImage: "backW", CenterTitle: "", CenterImage: "logosmall", RightTitle: "", RightImage: "", BackgroundColor: HEADERBGCOLOR, BackgroundImage: "", TextColor: WHITE_COLOR, TintColor: WHITE_COLOR, Menu: "")

        self.navigationController?.isNavigationBarHidden = false
        let url = URL (string: strUrl!)
        let requestObj = URLRequest(url: url!)
        web_View.loadRequest(requestObj)


        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.hideProgressBar()

    }
}
extension WebViewVC: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideProgressBar()

    }
}
