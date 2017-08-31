//
//  NotificationViewController.swift
//  Gopher
//
//  Created by User on 3/13/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking
import SystemConfiguration
import SDWebImage

class NotificationViewController: BaseViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var notificationsList = NSMutableArray()
    var tableView = UITableView()
    var requestSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBarItem.badgeValue = nil;
        self.GetNotificationAPICall()
        if(Commons.connectedToNetwork())
        {
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                self.requestSelected = true
                MakeAPICall("seller_id",UserModel.getUserData().userId)
                
            case 1:
                self.requestSelected = false
                MakeAPICall("buyer_id",UserModel.getUserData().userId)
            default:
                break;
            }
            
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
        
            return 148//(-20)
            
        }else{
        
            return 148
        
        }
        
        
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)as! NotificationTableViewCell
            let contractDetail = notificationsList[indexPath.row] as! NotificationModel
            cell.name.text = contractDetail.buyer_name
            
            cell.rentalPeriodLabel.text="Period : \(contractDetail.period)"
            
            cell.rentalTotalLabel.text="Total : $\(contractDetail.gig_pay)"
            
            var picUrl = ""
            
            if (contractDetail.buyerImage ).range(of:"http") != nil{
                picUrl = String (contractDetail.buyerImage )
            }else{
                picUrl = String (Constants.PROFILEBASEURL) + String (contractDetail.buyerImage )
            }
            
            //picUrl = picUrl.appending(contractDetail.profile_img)
            cell.profilePicImg.sd_setImage(with: URL(string: picUrl), placeholderImage: UIImage(named: "placeholder.png"))
            
            let gigImageUrl = String (Constants.PROFILEBASEURL) + String (contractDetail.gig_image
            )
            
            cell.gigImage.sd_setImage(with: URL(string: gigImageUrl), placeholderImage: UIImage(named: "placeholder.png"))
            
            
            
//            cell.profilePicImg.layer.borderWidth=1.0
//            cell.profilePicImg.layer.masksToBounds = false
//            cell.profilePicImg.layer.borderColor = UIColor.white.cgColor
//            cell.profilePicImg.layer.cornerRadius = 13
//            cell.profilePicImg.layer.cornerRadius = cell.profilePicImg.frame.size.height/2
            cell.profilePicImg.clipsToBounds = true
            cell.acceptBtn.tag = indexPath.row
            cell.acceptBtn.addTarget(self,action:#selector(acceptClicked(sender:)), for: .touchUpInside)
            cell.ignoreBtn.tag = indexPath.row
            cell.ignoreBtn.addTarget(self,action:#selector(cancelContractClicked(sender:)), for: .touchUpInside)
            if( !(contractDetail.currentDateTime.isEqual("")))
            {
                //cell.dateTime.text = contractDetail.currentDateTime
            }
            if(self.requestSelected==true)
            {
                cell.ignoreBtn.isHidden = false
                cell.acceptBtn.isHidden = false
                //cell.descriptionText.text = "has send you a request"
            }
            else
            {
                cell.ignoreBtn.isHidden = true
                cell.acceptBtn.isHidden = true
                
                if(contractDetail.request.isEqual("0")) {
                    //cell.descriptionText.text = "has not responded to your request"
                    
                }else if(contractDetail.request.isEqual("1")) {
                    //cell.descriptionText.text = "has accept your request"
                    
                }else if(contractDetail.request.isEqual("2")) {
                    //cell.descriptionText.text = "has not accept your request"
                    
                }
                
            }
            
            return cell
        
        }else{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rentalNotifCell", for: indexPath)as! NotificationTableViewCell
        let contractDetail = notificationsList[indexPath.row] as! NotificationModel
        //cell.name.text = contractDetail.first_name + " " + contractDetail.last_name
            
        let fullName=contractDetail.first_name + " " + contractDetail.last_name
            
            cell.rentalPeriodLabel.text="Period : \(contractDetail.period)"
            
            cell.rentalTotalLabel.text="Total : $\(contractDetail.gig_pay)"
            
            var picUrl = ""
            
            if (contractDetail.profile_img ).range(of:"http") != nil{
                picUrl = String (contractDetail.profile_img )
            }else{
                picUrl = String (Constants.PROFILEBASEURL) + String (contractDetail.profile_img )
            }
            
            //picUrl = picUrl.appending(contractDetail.profile_img)
            cell.profilePicImg.sd_setImage(with: URL(string: picUrl), placeholderImage: UIImage(named: "placeholder.png"))
            
            let gigImageUrl = String (Constants.PROFILEBASEURL) + String (contractDetail.gig_image
            )
            
            cell.gigImage.sd_setImage(with: URL(string: gigImageUrl), placeholderImage: UIImage(named: "placeholder.png"))
            

//        if( !(contractDetail.currentDateTime.isEqual("")))
//        {
//            cell.dateTime.text = contractDetail.currentDateTime
//        }
        if(self.requestSelected==true)
        {
            //cell.ignoreBtn.isHidden = false
            //cell.acceptBtn.isHidden = false
            //cell.requestLabel.text = fullName + "has send you a request"
        }
        else
        {
            //cell.ignoreBtn.isHidden = true
            //cell.acceptBtn.isHidden = true
            
            if(contractDetail.request.isEqual("0")) {
                cell.requestLabel.text = fullName + "has not responded to your request"
                
                cell.termsBtn.isHidden=true

            }else if(contractDetail.request.isEqual("1")) {
                cell.requestLabel.text = fullName + "has accept your request"
                
                cell.termsBtn.tag=indexPath.row
                
                cell.termsBtn.isHidden=false
                
                cell.termsBtn.addTarget(self,action:#selector(completeThisOrder(sender:)), for: .touchUpInside)

            }else if(contractDetail.request.isEqual("2")) {
                cell.requestLabel.text = fullName + "has not accept your request"
                
                cell.termsBtn.isHidden=true
 
            }

        }
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contractDetail = notificationsList[indexPath.row] as! NotificationModel
        let gig_gig_post_id = contractDetail.gig_gig_post_id
        if  gig_gig_post_id != ""  {
            self.MakeGetDetailPostAPICall(gig_gig_post_id)
        }
        //         let contractDetail = notificationsList[indexPath.row] as! NotificationModel
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sendContractDetailVC") as! PreviewSendContractDetailsViewController
//        nextViewController.descriptionFromPostVC = contractDetail.gig_gig_description
//        nextViewController.categorieListFromPostVC = contractDetail.categoryList
//        nextViewController.locationFromPostVC = contractDetail.gig_location_string
//        nextViewController.deadLineFromPostVC = contractDetail.gig_deadline
//        nextViewController.paymentFromPostVC = contractDetail.gig_pay
//        nextViewController.paymentTimeFromPostVC = contractDetail.gig_deadline
//        nextViewController.stateFromPostVC = contractDetail.gig_state
//        nextViewController.cityFromPostVC = contractDetail.gig_city
//        nextViewController.countryFromPostVC = contractDetail.gig_country
//        nextViewController.longitudeFromPostVC = contractDetail.gig_long
//        nextViewController.latFromPostVC = contractDetail.gig_lat
//        nextViewController.location_stringFromPostVC = contractDetail.gig_location_string
//        nextViewController.paymentType = contractDetail.gig_type_of_payment
//        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK:- Table view Buttons Click Mtehods
    func acceptClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        let contractDetail = notificationsList[buttonRow] as! NotificationModel

        self.MakeResponseAPICall(String(contractDetail.order_gig_post_id),responseId: "1",indexSelected: buttonRow)
        print(buttonRow)
    }
    
    func cancelContractClicked(sender:UIButton) {
        
        let buttonRow = sender.tag
        let contractDetail = notificationsList[buttonRow] as! NotificationModel
        
        self.MakeResponseAPICall(String(contractDetail.order_gig_post_id),responseId: "2",indexSelected: buttonRow)
        
        print(buttonRow)
    }
    
    
    @IBAction func completeThisOrder(sender:UIButton) {
        
        let buttonRow = sender.tag
        
        let contractDetail = notificationsList[buttonRow] as! NotificationModel
        
        MakeCompleteAPICall(contractDetail.order_gig_post_id, contractDetail.buyer_id)
    }
    
    // MARK: IBActions
    @IBAction func openMenu(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    
    func MakeCompleteAPICall(_ order_gig_post_id:String,_ buyer_id:String)
    {
        showProgressLoader()
        
        
        let params = ["order_gig_post_id":order_gig_post_id,"buyer_id":buyer_id] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.CompleteAndPayAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseRESPONSE(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    
    
    fileprivate func parseRESPONSE(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            //Commons.showAlert(dict?["msg"] as! String, VC: self)
            
            let alertView = UIAlertController(title: "Oops", message: dict?["msg"] as! String?, preferredStyle:
                UIAlertControllerStyle.alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addCardDetailVc") as! AddCardDetailViewController
                
                self.present(nextViewController, animated: true, completion: nil)
                
            }))
            present(alertView, animated: true, completion: nil)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
            
            let alertView = UIAlertController(title: "Success", message: "Order Completed Successfully", preferredStyle:
                UIAlertControllerStyle.alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alertView, animated: true, completion: nil)
            //print(response)
        }
    }
    
    //MARK:- Make Api Call
    func MakeAPICall(_ userKey:String,_ userId:String)
    {
        showProgressLoader()

        let params = [userKey:userId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.ShOWALLNOTIFICATIONAPIURL, parameters: params, success:
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
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
            notificationsList.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            
            for i in 0..<msgArray.count {
                let notificationDetail = NotificationModel()
                let firstObject = msgArray[i] as! NSDictionary
                let contract = firstObject["OrderGigPost"] as! NSDictionary
                let userinfo = firstObject["UserInfo"] as! NSDictionary
                let gigDetails = firstObject["GigPost"] as! NSDictionary
                let buyer = firstObject["Buyer"] as! NSDictionary
                
                
                if let calender = firstObject["OrderGigPostCalender"] as? NSArray{
                
                    notificationDetail.period="\(calender.count)"
                
                }else{
                
                    notificationDetail.period="0"
                    
                }
                
                
                
                
                if let profile_img = buyer["profile_img"] as? String {
                    
                    
                    
                    notificationDetail.buyerImage = profile_img
                }
                
                
                if let first_name = buyer["first_name"] as? String {
                    
                    let last_Name=buyer["last_name"] as! String
                    notificationDetail.buyer_name = first_name.uppercaseFirst + " " + last_Name.uppercaseFirst
                }
                
                if let first_name = userinfo["first_name"] as? String {
                    notificationDetail.first_name = first_name
                }
                
                if let last_name = userinfo["last_name"] as? String {
                    notificationDetail.last_name = last_name
                }
                if let profile_img = userinfo["profile_img"] as? String {
                    
                    
                    
                    notificationDetail.profile_img = profile_img
                }
                
                if let phone_no = userinfo["phone_no"] as? String {
                    notificationDetail.phone_no = phone_no
                }
                

                if( !(userinfo["registration_date"] is NSNull)) {
                    notificationDetail.registration_date = Commons.changeDateFormat(dateFrom: userinfo["registration_date"] as! String)
                }
                else {
                    notificationDetail.registration_date = ""
                }
                
                if let order_gig_post_id = contract["order_gig_post_id"] as? String {
                    notificationDetail.order_gig_post_id = order_gig_post_id
                }
                
                if let request = contract["request"] as? String {
                    notificationDetail.request = request
                }
                
                if let buyer_id = contract["buyer_id"] as? String {
                    notificationDetail.buyer_id = buyer_id
                }
                
                if let seller_id = contract["seller_id"] as? String {
                     notificationDetail.seller_id = seller_id
                }
                
                if( !(contract["datetime"] is NSNull)){
                   notificationDetail.currentDateTime = Commons.changeDateFormat(dateFrom: contract["datetime"] as! String)
                }
                else {
                  notificationDetail.currentDateTime = ""
                }
                
                if let gig_post_id = gigDetails["gig_post_id"] as? String {
                     notificationDetail.gig_gig_post_id = gig_post_id
                }
                
                if let gig_pay = gigDetails["pay"] as? String {
                
                     notificationDetail.gig_pay = gig_pay
                }

                if let gigImage = gigDetails["image"] as? String {
                    
                    notificationDetail.gig_image = gigImage
                }

                
                if let gig_gig_description = gigDetails["description"] as? String {
                    
                    notificationDetail.gig_gig_description = gig_gig_description
                }
                
                if let gig_gig_user_id = gigDetails["user_id"] as? String {
                    
                    notificationDetail.gig_gig_user_id = gig_gig_user_id
                }
                
                if let gig_type_of_payment = gigDetails["type_of_payment"] as? String {
                    
                    notificationDetail.gig_type_of_payment = gig_type_of_payment
                    
                    if gig_type_of_payment == "1"{
                        
                        notificationDetail.period.append(" Day/s")
                        
                    }else{
                    
                        notificationDetail.period.append(" Hour/s")
                    }
                    
                }

                if( !(gigDetails["deadline"] is NSNull)) {
                    if let deadLine = gigDetails["deadline"] {
                        notificationDetail.gig_deadline = deadLine as! String
                        notificationDetail.gig_deadline = Commons.changeDateFormat(dateFrom: deadLine as! String)

                    }
                }
                else {
                    notificationDetail.gig_deadline = ""
                }
                
//                notificationDetail.gig_gig_post_id = gigDetails["gig_post_id"] as! String
//                notificationDetail.gig_gig_description = gigDetails["description"] as! String
//                notificationDetail.categoryList = gigDetails["request"] as! String
//                notificationDetail.gig_location_string = gigDetails["request"] as! String
//                notificationDetail.gig_deadline = gigDetails["deadline"] as! String
//                notificationDetail.gig_pay = gigDetails["pay"] as! String
//                notificationDetail.gig_deadline = gigDetails["request"] as! String
//                notificationDetail.gig_state = gigDetails["request"] as! String
//                notificationDetail.gig_city = gigDetails["request"] as! String
//                notificationDetail.gig_country = gigDetails["request"] as! String
//                notificationDetail.gig_long = gigDetails["request"] as! String
//                notificationDetail.gig_lat = gigDetails["request"] as! String
//                notificationDetail.gig_location_string = gigDetails["request"] as! String
//                notificationDetail.gig_type_of_payment = gigDetails["type_of_payment"] as! String
                
                notificationsList.add(notificationDetail)
                print(contract)
               
                
            }
            self.tableView.reloadData()

        }
    }
    
    
    func MakeResponseAPICall(_ contractId:String, responseId:String, indexSelected:Int )
    {
        showProgressLoader()
        
        let params = ["order_gig_post_id":contractId, "response":responseId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.CONTACTRESPONSEAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseResponse(result as String, indexSelected: indexSelected)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseResponse(_ response:String, indexSelected:Int) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
            notificationsList.removeObject(at: indexSelected)
            self.tableView.reloadData()
            
        }
    }
    
    
    //MARK:- Make Get Gig Detail Api Call
    func MakeGetDetailPostAPICall(_ gigPostId:String)
    {
        showProgressLoader()
        
        let params = ["gig_post_id":gigPostId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.showGigPostDetailAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseDetailResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseDetailResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
        print(code)
        
        if code == 201 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
            var gigDetails = LatLongDetail()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            let firstObject = msgArray[0] as! NSDictionary
            let userInfo = firstObject["UserInfo"] as! NSDictionary
            let user = firstObject["User"] as! NSDictionary
            let gigInfo = firstObject["GigPost"] as! NSDictionary
            let locationInfo = firstObject["Location"] as! NSDictionary
           // let distance = firstObject["Distance"] as! Int
            
            if let userID = userInfo["user_id"] as? String {
                gigDetails.userId = userID
            }
            if let first_name = userInfo["first_name"] as? String {
                gigDetails.first_name = first_name
            }
            if let last_name = userInfo["last_name"] as? String {
                gigDetails.last_name = last_name
            }
            if let email = user["email"] as? String {
                gigDetails.email = email
            }
            if let phone_no = userInfo["phone_no"] as? String {
                gigDetails.phone_no = phone_no
            }
            
            if let profile_img = userInfo["profile_img"] as? String {
                if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                    gigDetails.profile_img = String (userInfo["profile_img"] as! String)
                }else{
                    gigDetails.profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
                }


            }
            
            if( !(gigInfo["image"] is NSNull))
            {
                gigDetails.gigImage =  String (Constants.PROFILEBASEURL) + String (gigInfo["image"] as! String)
                
                
                
            }
            
            if( !(userInfo["registration_date"] is NSNull))
            {
                gigDetails.registration_date = Commons.changeDateFormat(dateFrom: userInfo["registration_date"] as! String)
            }
            else
            {
                gigDetails.registration_date = ""
            }
            
            if let gig_post_id = gigInfo["gig_post_id"] as? String {
                gigDetails.gig_post_id = gig_post_id
            }
            
            if let user_id = gigInfo["user_id"] as? String {
                gigDetails.gig_user_id = user_id
            }

            if let description = gigInfo["description"] as? String {
                gigDetails.gig_description = description
            }

            
            //if( !(gigInfo["deadline"] is NSNull))
            //{
                //gigDetails.deadline = Commons.changeDateFormat(dateFrom: gigInfo["deadline"] as! String)
            //}
            //else
            //{
                gigDetails.deadline = ""
            //}
            gigDetails.pay = gigInfo["pay"] as! String
            gigDetails.type_of_payment = gigInfo["type_of_payment"] as! String
            let catObjectList = firstObject["GigPostAndCategory"] as! NSArray
            print(catObjectList)
            var categoryModel = CategoryModel()
            for i in 0..<catObjectList.count {
                let firstObject = catObjectList[i] as! NSDictionary
                var objectval = NSDictionary()
                if( !(firstObject["Category"] is NSNull))
                {
                    objectval = firstObject["Category"] as! NSDictionary
                }
                categoryModel = CategoryModel()
                if( !(firstObject["cat_id"] is NSNull))
                {
                    categoryModel.catID = firstObject["cat_id"] as! String
                }
                if( !(objectval["cat_name"] is NSNull))
                {
                    categoryModel.catName = objectval["cat_name"] as! String
                }
                categoryModel.isSelected = false
                gigDetails.categoryList.add(categoryModel as CategoryModel)
                print(categoryModel.catID)
                print(categoryModel.catName)
            }
            
            
            
            if( !(locationInfo["lat"] is NSNull))
            {
                gigDetails.lat = locationInfo["lat"] as! String
            }
            if(!(locationInfo["long"] is NSNull))
            {
                gigDetails.long = locationInfo["long"] as! String
            }
            if( !(locationInfo["city"] is NSNull))
            {
                gigDetails.city = locationInfo["city"] as! String
            }
            if( !(locationInfo["state"] is NSNull))
            {
                gigDetails.state = locationInfo["state"] as! String
            }
            if( !(locationInfo["country"] is NSNull))
            {
                gigDetails.country = locationInfo["country"] as! String
            }
            if( !(locationInfo["location_string"] is NSNull))
            {
                gigDetails.location_string = locationInfo["location_string"] as! String
            }
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sendContractDetailVC") as! PreviewSendContractDetailsViewController
            nextViewController.descriptionFromPostVC = gigDetails.gig_description
            nextViewController.categorieListFromPostVC = gigDetails.categoryList
            nextViewController.locationFromPostVC = gigDetails.location_string
            nextViewController.deadLineFromPostVC = gigDetails.deadline
            nextViewController.paymentFromPostVC = gigDetails.pay
            nextViewController.paymentTimeFromPostVC = gigDetails.registration_date
            nextViewController.stateFromPostVC = gigDetails.state
            nextViewController.cityFromPostVC = gigDetails.city
            nextViewController.countryFromPostVC = gigDetails.country
            nextViewController.longitudeFromPostVC = gigDetails.long
            nextViewController.latFromPostVC = gigDetails.lat
            nextViewController.location_stringFromPostVC = gigDetails.location_string
            nextViewController.paymentType = gigDetails.type_of_payment
            nextViewController.gigImage = gigDetails.gigImage
            nextViewController.fromNotificationVC = "1"
            self.present(nextViewController, animated:true, completion:nil)
        }
    
    }
    
    //MARK:- Get Notification Count Api Call
    func GetNotificationAPICall()
    {
        
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.SETREADNOTIFICATIONSAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseNotificationResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseNotificationResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
        print(code)
        
        if code == 201 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
             self.tabBarController?.tabBar.items?[4].badgeValue = nil
            //print(msgArray)

        }
        
    }
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.requestSelected = true
             MakeAPICall("seller_id",UserModel.getUserData().userId)
            
        case 1:
            self.requestSelected = false
             MakeAPICall("buyer_id",UserModel.getUserData().userId)
        default:
            break;
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
