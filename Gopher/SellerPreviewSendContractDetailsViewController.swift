//
//  SellerPreviewSendContractDetailsViewController.swift
//  Gopher
//
//  Created by User on 2/17/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SystemConfiguration
import AFNetworking

class SellerPreviewSendContractDetailsViewController: BaseViewController, TTTAttributedLabelDelegate {

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
    
    //MARK:- Variables
    
    
    var selectedGigDetail = LatLongDetail()
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
    var defaultXValueforView = 5
    var buyerId = ""
    var gigPostId = ""
    var defaultCategoryScrollContentSize = 100
    var currentDateTime = ""
    //MARK:- View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if(paymentTimeFromPostVC.isEqual("0"))
        {
          paymentType = " Flat"
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
    @IBAction func backBtn(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()

    }
    @IBAction func currentLocationBTN(_ sender: Any) {
    }
    
    @IBAction func postGigBtn(_ sender: Any) {
        if(connectedToNetwork())
        {
            MakeAPICall()
        }
        else
        {
            self.showAlert("Please check your connection","Oops", VC: self)
        }
    }
    
    @IBAction func closeBTN(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
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
    
    //MARK:- Make Api Call
    func MakeAPICall()
    {
        self.showProgressLoader()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        
        currentDateTime = formatter.string(from: date)
        
        let params = ["buyer_id":buyerId,"seller_id":UserModel.getUserData().userId,"gig_post_id":gigPostId,"datetime":currentDateTime] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.POSTAGAINSTPOSTAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseSignUpResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    
    fileprivate func parseSignUpResponse(_ response:String) {
        let dict = convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            self.showAlert("You have already applied for this gig"  ,"Oops", VC: self)
        }
        if code == 401 {
            
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 400 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        
        if(code == 200)
        {
            self.showAlertPostedGig("Your request has been submitted.","Congratulations", VC: self)
//            navigationController?.popViewController(animated: false)
//            
//            dismiss(animated: false, completion: nil)
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "postGigMapVC") as! PostGigViewController
//            nextViewController.amount = paymentFromPostVC
//            nextViewController.deadLine = deadLineFromPostVC
//            nextViewController.profilePicUrl = UserModel.getUserData().profile_img
//            nextViewController.mLatitude = latFromPostVC
//            nextViewController.mLongitutde = longitudeFromPostVC
//            self.present(nextViewController, animated:true, completion:nil)
//            
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
    func showAlertPostedGig(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: closeVC))
        VC.present(alertView, animated: true, completion: nil)
        
    }
    func closeVC(action: UIAlertAction) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
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
            dicSet = NSMutableDictionary()
            dicSet.setValue(catId, forKey: "cat_id")
            ids.add(dicSet)
        
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
    
}
