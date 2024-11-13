//
//  Utility.swift
//  Shipit
//
//  Created by mac on 24/09/18.
//  Copyright © 2018 Technorizen. All rights reserved.
//

import UIKit
import MapKit
import Photos

class Utility {
    
    class func isValidMobileNumber(_ mobileNo: String) -> Bool {
        let mobileNumberPattern: String = "^([0-9])[0-9]{7,9}$"
        print(mobileNumberPattern)
        //@"^[7-9][0-9]{9}$";
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
        let isValid: Bool = mobileNumberPred.evaluate(with: mobileNo)
        print(isValid)
        return isValid
    }
    
    class func isValidPassword(_ password: String) -> Bool {
        let mobileNumberPattern: String = "^[0-9]{4}$"
        //@"^[7-9][0-9]{9}$";
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
        let isValid: Bool = mobileNumberPred.evaluate(with: password)
        return isValid
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid: Bool = emailPred.evaluate(with: email)
        return isValid
    }
    
    class func isValidPinCode(_ pincode: String) -> Bool {
        let pinRegex: String = "^[0-9]{6}$"
        let pinTest = NSPredicate(format: "SELF MATCHES %@", pinRegex)
        let pinValidates: Bool = pinTest.evaluate(with: pincode)
        return pinValidates
    }
    
    class func getDateFrom(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        return date!
    }
    
    class func getDateString(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "EEEE, MMM dd"
        let dateAMPM: String = dateFormatterAMPM.string(from: date!)
        return dateAMPM
    }
    
    class func getDateStringString(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "hh:mm a"
        let dateAMPM: String = dateFormatterAMPM.string(from: date!)
        return dateAMPM
    }
    
    class func getDateTimeString(withAMPM dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = "dd-MMM-yyyy hh:mm a"
        var dateAMPM:String = ""
        if let dateS = date {
            dateAMPM = dateFormatterAMPM.string(from: dateS)
        }
        return dateAMPM
    }
    
    class func getStringDateFromStringDate(withAMPM dateString: String, outputFormate: String) -> String {
        //2020-04-03 19:06:53
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date? = dateFormatter.date(from: dateString)
        let dateFormatterAMPM = DateFormatter()
        dateFormatterAMPM.dateFormat = outputFormate
        var dateAMPM:String = ""
        if let dateS = date {
            dateAMPM = dateFormatterAMPM.string(from: dateS)
        }
        return dateAMPM
    }
    
    class func showAlertMessage(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        //You can use a block here to handle a press on this button
        alertController.addAction(actionOk)
        parentVC.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithAction(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    
    class func showAlertYesNoAction(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(false)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    
    class func isUserLogin ()-> Bool {
        if (UserDefaults.standard.bool(forKey: "user_login_status")) {
            return true
        }
        return false
    }
    
    class func checkNetworkConnectivityWithDisplayAlert( isShowAlert : Bool) -> Bool{
        let isNetworkAvaiable = InternetUtilClass.sharedInstance.hasConnectivity()
        return isNetworkAvaiable;
    }
    
    class func getStringFromDate(_ date: Date, outputFormate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormate
        let newDate = dateFormatter.string(from: date) //pass Date here
        return newDate
    }
    
    class func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    class func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    class func noDataFound(_ message: String, tableViewOt: UITableView, parentViewController parentVC: UIViewController) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableViewOt.bounds.size.width, height: tableViewOt.bounds.size.height))
      
        let center = (tableViewOt.bounds.size.width/2)
        let center_y = (tableViewOt.bounds.size.height/2)
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "search (1)"))
        imageView.frame = CGRect(x: center - 50, y: center_y - 150, width: 100, height: 100)
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: center_y - 25, width: tableViewOt.bounds.size.width, height: 20))
        label.font = label.font.withSize(17.0)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = message
//        label.textColor = parentVC.hexStringToUIColor(hex: "#5A5C63")
        label.textColor = UIColor(red: CGFloat(90)/255, green: CGFloat(92)/255, blue: CGFloat(99)/255, alpha :1)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        
        let label2: UILabel = UILabel(frame: CGRect(x: 0, y: center_y, width: tableViewOt.bounds.size.width, height: 20))
        label2.font = label.font.withSize(13.0)
        label2.text = "No data available to show"
//        label2.textColor = UIColor(red: CGFloat(150)/255, green: CGFloat(150)/255, blue: CGFloat(150)/255, alpha :1)
        label2.textColor = parentVC.hexStringToUIColor(hex: "#95979B")
        label2.textAlignment = NSTextAlignment.center
        label2.numberOfLines = 0
        
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(label2)
        tableViewOt.backgroundView = view
    }
    
    class func getLocationByCoordinates (location: CLLocation, successBlock success: @escaping (_ address: String) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                let address = (formattedAddress.joined(separator: ", "))
                success(address)
            }
        })
    }
    
    class func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = LocationManager.sharedInstance.lastLocation {
            let geocoder = CLGeocoder()
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        } else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    class func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
