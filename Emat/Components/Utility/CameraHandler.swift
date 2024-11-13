//
//  CameraHandler.swift
//  Shipit
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import Foundation
import UIKit


class CameraHandler: NSObject{
    
    fileprivate var currentVC: UIViewController!
    
    var media = [String]()
    
    static let sharedInstance:CameraHandler = {
        let instance = CameraHandler()
        return instance
    }()
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    var videoPickedBlock: ((URL) -> Void)?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }

    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.allowsEditing = true

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else {
                   print("Something went wrong")
        }
        if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            self.videoPickedBlock?(video)
        }
        currentVC.dismiss(animated: true, completion: nil)
    }    
}
