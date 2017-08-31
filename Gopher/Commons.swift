//
//  Commons.swift
//  Gopher
//
//  Created by User on 3/4/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration

class Commons: NSObject {
    
    static func showAlert(_ error: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: "Oops", message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
    }
    static func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        //
        //        if let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        ////            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        //            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { (zeroAddress) -> in
        //              SCNetworkReachabilityCreateWithAddress(nil, zeroAddress)
        //            })
        //        }) else {
        //            return false
        //        }
        //
        //
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
   static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
   static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func changeDateFormat (dateFrom: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let  date = dateFormatter.date(from: dateFrom) as? NSDate {
            let dateFromString : NSDate = date
            let dateFormatternew = DateFormatter()
            dateFormatternew.dateFormat = "EEEE, MMM d, yyyy"
            let dateInString =  dateFormatternew.string(from: dateFromString as Date)
            return dateInString
        } else {
            return ""
        }
        

        
    }
    
    static func changeGigDateFormat (dateFrom: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateFrom) {
            let dateFromString : NSDate = date as NSDate
            let dateFormatternew = DateFormatter()
            dateFormatternew.dateFormat = "MMM d, yyyy  HH:mm:ss"
            let dateInString =  dateFormatternew.string(from: dateFromString as Date)
            return dateInString
        } else {
            return ""
        }
        
        
        
    }
    
    
    
    static func reviewDateFormat (dateFrom: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateFrom) {
            let dateFromString : NSDate = date as NSDate
            let dateFormatternew = DateFormatter()
            dateFormatternew.dateFormat = "dd/MM/yyyy"
            let dateInString =  dateFormatternew.string(from: dateFromString as Date)
            return dateInString
        } else {
            return ""
        }
        
        
        
    }

    static func changeGigDateFormatToCalender (dateFrom: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateFrom) {
            let dateFromString : NSDate = date as NSDate
            let dateFormatternew = DateFormatter()
            dateFormatternew.dateFormat = "dd-MM-yyyy  HH:mm:ss"
            let dateInString =  dateFormatternew.string(from: dateFromString as Date)
            return dateInString
        } else {
            return ""
        }
        
        
        
    }
    
    static func getTimeStringFromDate (dateFrom: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateFrom) {
            let dateFromString : NSDate = date as NSDate
            let dateFormatternew = DateFormatter()
            dateFormatternew.dateFormat = "HH"
            let dateInString =  dateFormatternew.string(from: dateFromString as Date)
            return dateInString
        } else {
            return ""
        }
        
        
        
    }


    
    
    static func getDatefromString (dateFrom: String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        
        if let date = dateFormatter.date(from: dateFrom) {
          
            return date
        }
    
        return nil
    }

    
    static func changeChatDateFormat (dateFrom: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : Date = dateFormatter.date(from: dateFrom)! as Date
        let dateFormatternew = DateFormatter()
        dateFormatternew.dateFormat = "EEEE, MMM d, yyyy"
        let dateInString =  dateFormatternew.string(from: dateFromString as Date)
        let dateFromStrng : Date = dateFormatternew.date(from: dateInString)! as Date
        return dateFromStrng
    }
}


