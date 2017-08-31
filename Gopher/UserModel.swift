//
//  swift
//  Gopher
//
//  Created by User on 2/20/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
class UserModel: NSObject {
    
    // MARK: Keys and Variables
    
    fileprivate let keyUserId = "user_id"
    fileprivate let keyEmail  = "email"
    fileprivate let keyPassword = "password"
    fileprivate let keyFirstName = "first_name"
    fileprivate let keyLastName = "last_name"
    fileprivate let keyUserProfileImg = "profile_img"
    fileprivate let keyphoneNo = "phone_no"
    fileprivate let keyAbout = "about"
    fileprivate let keyRegistrationDate = "registration_date"
    fileprivate let keyDeviceToken = "device_token"
    fileprivate let keyAvailableForGigs = "available_for_gigs"
    var msgArray = NSArray()
    var categoryList = NSMutableArray()
    var skillsList = NSMutableArray()
    var firstObject = NSDictionary()
    var userInfo = NSDictionary()
    var user = NSDictionary()
    var userId = ""
    var email = ""
    var first_name = ""
    var last_name = ""
    var phone_no = ""
    var profile_img = ""
    var registration_date = ""
    var availableForGigs = ""
    var about = ""
// MARK: Help Methods
func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
    // MARK: Get User Object
    public static func getUserData() -> UserModel {
        let userModel = UserModel.TheInstance
        
        UserModel.instance.parseSignUpResponse(UserDefaults.standard.value(forKey: Constants.USERRESPONSEKEY) as! String)

        return userModel
    }
    private override init() { }
    
    public static func Instance() -> UserModel {
        return instance
    }
    
    public static var TheInstance : UserModel {
        get { return instance }
    }
    
    // MARK: Parse Data
    
    public func parseSignUpResponse(_ response:String) {
        let dict = convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        if categoryList.count > 0 {
            categoryList.removeAllObjects()
        }
        
        if skillsList.count > 0 {
            skillsList.removeAllObjects()
        }
        print(code)
        if code == 200
        {
            
            msgArray = dict?["msg"] as! NSArray
            firstObject = msgArray[0] as! NSDictionary
            userInfo = firstObject["UserInfo"] as! NSDictionary
            user = firstObject["User"] as! NSDictionary
            userId = userInfo[keyUserId] as! String
            email = user[keyEmail] as! String
            first_name = userInfo[keyFirstName] as! String
            last_name = userInfo[keyLastName] as! String
            phone_no = userInfo[keyphoneNo] as! String

            
            if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                profile_img = String (userInfo["profile_img"] as! String)
            }else{
                profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
            }

            registration_date = Commons.changeDateFormat(dateFrom: userInfo[keyRegistrationDate] as! String)
            if( !(userInfo[keyAbout] is NSNull) && !(userInfo[keyAbout]==nil))
            {
                about = userInfo[keyAbout] as! String
            }

            print(firstObject)
            let catList = firstObject["UserCategory"] as! NSArray
            for i in 0..<catList.count {
                let catObj = catList[i] as! NSDictionary
                let catListObj = CategoryModel()
                catListObj.catID = catObj.value(forKey: "cat_id") as! String
                let catNameObj = catObj.value(forKey: "Category") as! NSDictionary
                catListObj.catName = catNameObj.value(forKey: "cat_name") as! String
                categoryList.add(catListObj)
                
            }
            
            print(userId)
            print(email)
            print(first_name)
            print(last_name)
            print(phone_no)
            print(profile_img)
            print(registration_date)
            
        }
    }
    
    static let instance : UserModel = UserModel()
    var state = 0
    
    
}


