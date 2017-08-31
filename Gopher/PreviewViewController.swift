//
//  PreviewViewController.swift
//  Gopher
//
//  Created by User on 2/17/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SystemConfiguration
import AFNetworking
import Alamofire
import SDWebImage

class PreviewViewController: BaseViewController, TTTAttributedLabelDelegate {

    //MARK:- IBOutlet properties
    @IBOutlet weak var locationAdress: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var deadlinetime: UILabel!
    @IBOutlet weak var minimumFee: UILabel!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var termsText: TTTAttributedLabel!
    @IBOutlet weak var imageHolder: UIImageView!
    //MARK:- Variables
    var categorieList = NSMutableArray()
    var descriptionFromPostVC = "" 
    var categorieListFromPostVC = NSMutableArray()
    var locationFromPostVC = ""
    var deadLineFromPostVC = ""
    var paymentFromPostVC = ""
    var paymentTimeFromPostVC = ""
    var stateFromPostVC = ""
    var cityFromPostVC = ""
    var countryFromPostVC = ""
    var longitudeFromPostVC = ""
    var latFromPostVC = ""
    var location_stringFromPostVC = ""
    var paymentType = ""
    var dateAndTime = ""
    var defaultXValueforView = 5;
    var additionalNotesPostVC = ""
    var titlePostVC = ""
    var datesArray = [String]()
    var defaultCategoryScrollContentSize = 100;
    var holderImage:UIImage?
    var editedGigId=""
    var imagesArray=[UIImage]()
    var defaultImageIndex=1
    
    let imageWidth:CGFloat = 130
    let imageHeight:CGFloat = 114
    var xPosition:CGFloat = 8
    var scrollViewSize:CGFloat=0
    let margin:CGFloat=8
    
    @IBOutlet weak var imagesScrollView: UIScrollView!
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if holderImage != nil {
            //imageHolder.image = holderImage
        }
        // Do any additional setup after loading the view.
        self.hideProgressLoader()
        parentScrollView.isUserInteractionEnabled = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        parentScrollView.contentSize = CGSize(width: screenWidth, height: viewParent.frame.height+50)
        parentScrollView.keyboardDismissMode = .onDrag
        self.makeTextClickable()
        descriptionText.text = descriptionFromPostVC
        locationAdress.text = locationFromPostVC
        deadlinetime.text = deadLineFromPostVC
        categorieList = categorieListFromPostVC
        if(paymentTimeFromPostVC.isEqual("1"))
        {
          paymentType = " Daily"
        }
        else
        {
            paymentType = " Hourly"
        }
        minimumFee.text = "$ " + paymentFromPostVC + " " + paymentType
        self.addCategoriesToView()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        self.loadCurrentImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Add Categories to View
    func createViewForCatogry(name: String, heightOfParent: Int) -> UIView {
        
        let catogeryView=UIView(frame: CGRect(x:defaultXValueforView, y:5, width:100, height:30))
        catogeryView.backgroundColor = UIColorFromRGB(rgbValue: 0xdfdfdf)
        
        let categoryName: UILabel = UILabel()
        categoryName.frame = CGRect(x: 8, y:5, width:80, height:21)
        categoryName.textColor = UIColorFromRGB(rgbValue: 0x55A0BF)
        categoryName.textAlignment = NSTextAlignment.center
        categoryName.text = name
        categoryName.font = categoryName.font.withSize(10)
        catogeryView.addSubview(categoryName)
        defaultXValueforView = defaultXValueforView + 110;
        return catogeryView
    }
    
    func addCategoriesToView()
    {
        for i in 0..<categorieList.count {
            
            let catogry = categorieList[i] as! CategoryModel
            defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 90
            categoryScrollView.addSubview(self.createViewForCatogry(name: catogry.catName, heightOfParent: Int(categoryScrollView.frame.size.height)))
            categoryScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
            
        }
        defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 40
        categoryScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.showsVerticalScrollIndicator = false
    }
    
   //MARK:- IBAction Button
    
    @IBAction func menuBtn(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()
        
    }
    
    @IBAction func currentLocationBTN(_ sender: Any) {
    }
    
    @IBAction func postGigBtn(_ sender: Any) {
        if(connectedToNetwork())
        {
            if editedGigId == ""{
                MakeAPICall()
            }else{
                MakeAPICallForEdit()
            }
            
        }
        else
        {
            self.showAlert("Please check your connection","Oops", VC: self)
        }
    }
    
    @IBAction func closeBTN(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Make Text Clickable
    func makeTextClickable() {
        let termsAndContionsText : NSString = "I agree to the terms in this contract"
        termsText.delegate = self
        termsText.text = termsAndContionsText as String
        termsText.textColor = UIColor.white
        let range : NSRange = termsAndContionsText.range(of: "terms")
        termsText.addLink(to: NSURL(string: "http://google.com/")! as URL!, with: range)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
        
    }
    
    
    func loadCurrentImages(){
        
        imagesScrollView.subviews.forEach({ $0.removeFromSuperview() })
        xPosition = 0
        scrollViewSize=0
        
        var c=0
        for image in imagesArray {
            let myImage:UIImage = image
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            
            myImageView.frame.size.width = imageWidth-16
            myImageView.frame.size.height = imageHeight-16
            myImageView.frame.origin.x = xPosition+8
            myImageView.frame.origin.y = 16
            
            //myImageView.inset
            
            let frame=CGRect(x: xPosition, y: 8, width: imageWidth, height: imageHeight)
            
            let btn=UIButton.init(frame: frame)
            
            //btn.addTarget(self, action: #selector(editThisImage(_:)), for: .touchUpInside)
            
            btn.tag=c+1
            
            if defaultImageIndex==c+1 {
                
                btn.layer.borderWidth = 2
                btn.layer.borderColor = UIColor.red.cgColor
                
            }
            
            imagesScrollView.addSubview(myImageView)
            imagesScrollView.addSubview(btn)
            xPosition += (imageWidth + margin)
            scrollViewSize += (imageWidth + margin)
            
            c+=1
        }
        
        
        scrollViewSize += imageWidth
        
        imagesScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
        
    }
    
    //MARK:- Make Api Call
    
    func MakeAPICallForEdit()
    {
//        self.showProgressLoader()
//        let params = ["gig_post_id":editedGigId,"user_id":UserModel.getUserData().userId,"title":titlePostVC,"description":descriptionFromPostVC, "notes":additionalNotesPostVC, "pay":paymentFromPostVC,"type_of_payment":paymentTimeFromPostVC,"categories":self.getCatIdArray(), "long":longitudeFromPostVC, "lat":latFromPostVC,"state":stateFromPostVC,"city":cityFromPostVC,"country":countryFromPostVC,"location_string":location_stringFromPostVC,"datetime" : dateAndTime, "calender": self.getdatesArray(), "image":["content_type": "image/png", "filename":"test.png", "file_data": base64StringOfImage(holderImage!)],"device_token":"asdsadas" ] as [String : Any]
//        
//        print(params)
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer()
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        manager.post(Constants.UpdateGigURL, parameters: params, success:
//            {
//                requestOperation, response in
//                
//                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
//                
//                print(result)
//                self.parseEditUpResponse(result as String)
//        },
//                     failure:
//            {
//                requestOperation, error in
//                self.hideProgressLoader()
//                print(error.localizedDescription)
//        })
        
        self.showProgressLoader()
        
        //        var imagesPostArray = [[String:Any]]()
        //
        //        for i in 0..<imagesArray.count{
        //
        //            var item=[String:Any]()
        //
        //            item["content_type"]="image/png"
        //            item["filename"]="test\(i).png"
        //            item["file_data"]=base64StringOfImage(imagesArray[i])
        //
        //            var completeItem=[String:Any]()
        //
        //            completeItem["image"]=item
        //
        //            if defaultImageIndex==i+1{
        //
        //                completeItem["default"]="1"
        //
        //            }else{
        //
        //                completeItem["default"]="0"
        //            }
        //
        //
        //            imagesPostArray.append(completeItem)
        //
        //        }
        
        //        let params = ["user_id":UserModel.getUserData().userId,"title":titlePostVC,"description":descriptionFromPostVC, "notes":additionalNotesPostVC, "pay":paymentFromPostVC,"type_of_payment":paymentTimeFromPostVC,"categories":self.getCatIdArray(), "long":longitudeFromPostVC, "lat":latFromPostVC,"state":stateFromPostVC,"city":cityFromPostVC,"country":countryFromPostVC,"location_string":location_stringFromPostVC,"datetime" : dateAndTime, "calender": self.getdatesArray(), "image":["content_type": "image/png", "filename":"test.png", "file_data": base64StringOfImage(holderImage!)],"device_token":"asdsadas" ] as [String : Any]
        
        let params = ["gig_post_id":editedGigId,"user_id":UserModel.getUserData().userId,"title":titlePostVC,"default_img":"\(defaultImageIndex)","description":descriptionFromPostVC, "notes":additionalNotesPostVC, "pay":paymentFromPostVC,"type_of_payment":paymentTimeFromPostVC, "long":longitudeFromPostVC, "lat":latFromPostVC,"state":stateFromPostVC,"city":cityFromPostVC,"country":countryFromPostVC,"location_string":location_stringFromPostVC,"datetime" : dateAndTime,"device_token":"asdsadas" ] as [String : Any]
        
        //print(params)
        //        let manager = AFHTTPSessionManager()
        //        manager.requestSerializer = AFJSONRequestSerializer()
        //        manager.responseSerializer = AFHTTPResponseSerializer()
        //        manager.post(Constants.POSTGIGAPIURL, parameters: params, success:
        //            {
        //                requestOperation, response in
        //
        //                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
        //
        //                print(result)
        //                self.parseSignUpResponse(result as String)
        //        },
        //                     failure:
        //            {
        //                requestOperation, error in
        //                self.hideProgressLoader()
        //                print(error.localizedDescription)
        //        })
        
        //let newParams = ["user_id":UserModel.getUserData().userId]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in params {
                if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            
            for i in 0..<self.imagesArray.count{
                
                
//                multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.6)!, withName: "files[\(i)]", fileName: "image.jpg", mimeType: "image/jpeg")
                
                if (self.defaultImageIndex-1) == i {
                    multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.5)!, withName: "files[\(i)]", fileName: "default.jpg", mimeType: "image/jpeg")
                } else {
                    multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.5)!, withName: "files[\(i)]", fileName: "\(String.randomString(length: 6)).jpg", mimeType: "image/jpeg")
                    
                    print("\(String.randomString(length: 6)).jpg)")
                }

                
            }//"calender": self.getdatesArray()
            
            let calenderArray=self.getdatesArray()
            
            for i in 0..<calenderArray.count{
                
                let str=calenderArray[i] as! String
                
                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: "calender[\(i)]")
                
            }
            
            let cat=self.getCatIdArray()
            
            for i in 0..<cat.count{
                
                let str=cat[i] as! String
                
                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: "categories[\(i)]")
                
            }
            
        },
                         to: Constants.EDITGIGAPIURL/*"http://54.174.109.228/gopher/api/addNewGigPost"*/, encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload
                                    .validate(statusCode: 200..<600)
                                    .responseString { response in
                                        switch response.result {
                                        case .success(let value):
                                            self.parseEditUpResponse(value)
                                            print("responseObject: \(value)")
                                        case .failure(let responseError):
                                            print("responseError: \(responseError)")
                                        }
                                }
                            case .failure(let encodingError):
                                print("encodingError: \(encodingError)")
                            }
        })
        
        
        //func post(_ URLString: String, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Swift.Void)?, failure: ((URLSessionDataTask?, Error) -> Swift.Void)? = nil) -> URLSessionDataTask?
        
    }
    
    func MakeAPICall()
    {
        self.showProgressLoader()
        

        
        let params = ["user_id":UserModel.getUserData().userId,"title":titlePostVC,"default_img":"\(defaultImageIndex)","description":descriptionFromPostVC, "notes":additionalNotesPostVC, "pay":paymentFromPostVC,"type_of_payment":paymentTimeFromPostVC, "long":longitudeFromPostVC, "lat":latFromPostVC,"state":stateFromPostVC,"city":cityFromPostVC,"country":countryFromPostVC,"location_string":location_stringFromPostVC,"datetime" : dateAndTime,"device_token":"asdsadas" ] as [String : Any]

        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in params {
                if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            
            for i in 0..<self.imagesArray.count{
            
//                if self.defaultImageIndex == i {
//                    multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.5)!, withName: "files[\(i)]", fileName: "default.jpg", mimeType: "image/jpeg")
//                } else {
//                    multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.5)!, withName: "files[\(i)]", fileName: "\(String.randomString(length: 6)).jpg", mimeType: "image/jpeg")
//                }
                
                if (self.defaultImageIndex-1) == i {
                    multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.5)!, withName: "files[\(i)]", fileName: "default.jpg", mimeType: "image/jpeg")
                } else {
                    multipartFormData.append(UIImageJPEGRepresentation(self.imagesArray[i],0.5)!, withName: "files[\(i)]", fileName: "\(String.randomString(length: 6)).jpg", mimeType: "image/jpeg")
                    
                    print("\(String.randomString(length: 6)).jpg)")
                }

                
                
            }//"calender": self.getdatesArray()
            
            let calenderArray=self.getdatesArray() 
            
            for i in 0..<calenderArray.count{
                
                let str=calenderArray[i] as! String
                
                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: "calender[\(i)]")
                
            }
            
            let cat=self.getCatIdArray()
            
            for i in 0..<cat.count{
                
                let str=cat[i] as! String
                
                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: "categories[\(i)]")
                
            }
            
        },
                         to: Constants.POSTGIGAPIURL/*"http://54.174.109.228/gopher/api/addNewGigPost"*/, encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload
                                    .validate()
                                    .responseString { response in
                                        switch response.result {
                                        case .success(let value):
                                            print("responseObject: \(value)")
                                            
                                            self.parseSignUpResponse(value)
                                        case .failure(let responseError):
                                            print("responseError: \(responseError)")
                                        }
                                }
                            case .failure(let encodingError):
                                print("encodingError: \(encodingError)")
                            }
        })
        
        
        //func post(_ URLString: String, parameters: Any?, success: ((URLSessionDataTask, Any?) -> Swift.Void)?, failure: ((URLSessionDataTask?, Error) -> Swift.Void)? = nil) -> URLSessionDataTask?
        
    }
    
    fileprivate func parseEditUpResponse(_ response:String) {
        let dict = convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 401 {
            
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 400 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        
        if(code == 200)
        {
            //            navigationController?.popViewController(animated: false)
            //
            //            dismiss(animated: false, completion: nil)
            
            //self.showAlert("Gig has been Updated successfully","Congratulations", VC: self)
            let alertView = UIAlertController(title: "Congratulations ", message: "Gig has been Updated successfully", preferredStyle:
                UIAlertControllerStyle.alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                SDImageCache.shared().clearMemory()
                SDImageCache.shared().clearDisk()
                _ = self.navigationController?.popToRootViewController(animated: true)
                
            }))
            self.present(alertView, animated: true, completion: nil)
            
            
        }
    }
    
    fileprivate func parseSignUpResponse(_ response:String) {
        let dict = convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 401 {
            
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 400 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        
        if(code == 200)
        {
//            navigationController?.popViewController(animated: false)
//            
//            dismiss(animated: false, completion: nil)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "postGigMapVC") as! PostGigViewController
            nextViewController.amount = paymentFromPostVC
            nextViewController.deadLine = deadLineFromPostVC
            nextViewController.profilePicUrl = UserModel.getUserData().profile_img
            nextViewController.holderImage=imagesArray[0]
            nextViewController.mLatitude = latFromPostVC
            nextViewController.mLongitutde = longitudeFromPostVC
            //self.navigationController?.pushViewController(nextViewController, animated:true)
            present(nextViewController, animated: true, completion: nil)
            
           // self.showAlert("Gig has been posted successfully","Congratulations", VC: self)
        }
    }
    
    //MARK:- Help Methods
    
    func connectedToNetwork() -> Bool {
        
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
    
    
    func showAlert(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
    }
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
    
    func getCatIdArray () -> NSMutableArray
    {
        let ids = NSMutableArray()
        var dicSet = NSMutableDictionary()

        for i in 0..<categorieList.count {
            
            let catogry = categorieList[i] as! CategoryModel
            let catId = catogry.catID
            //dicSet = NSMutableDictionary()
            //dicSet.setValue(catId, forKey: "cat_id")
            ids.add(catId)
        
        }
        
        return ids
    }
    
    
    func getdatesArray () -> NSMutableArray
    {
        let ids = NSMutableArray()
        var dicSet = NSMutableDictionary()
        
        for i in 0..<datesArray.count {
            
            
            if datesArray[i].range(of:":") == nil{
                datesArray[i]="\(datesArray[i]) 00:00:00"
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss" //Your date format
            let date = dateFormatter.date(from: datesArray[i])
            let dateFormatterNew = DateFormatter()
            dateFormatterNew.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let postDate =  dateFormatterNew.string(from: date! as Date)
            
            //dicSet = NSMutableDictionary()
            //dicSet.setValue(postDate, forKey: "date")
            ids.add(postDate)
            
        }
        
        return ids
    }
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func base64StringOfImage(_ image:UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let base64String = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }

}
