//
//  ImageVC.swift
//  Created by mac on 19/04/20.
//  Copyright © 2020 com.ios. All rights reserved.
//

import UIKit
import SDWebImage

class ImageVC: UIViewController {

    @IBOutlet weak var img_News: UIImageView!
   
    var str_Image:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img_News.sd_setImage(with: URL.init(string: str_Image), placeholderImage: UIImage.init(named: "placeholderB"), options: SDWebImageOptions(rawValue: 1), completed: nil)

        // Do any additional setup after loading the view.
    }
    

}
