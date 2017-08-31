//
//  ActiveContractsViewController.swift
//  Gopher
//
//  Created by User on 2/15/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking
class ActiveContractsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    //MARK:- IBOutlet properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var backBtnOutlet: UIButton!
    
    var isMyAppSelected = false
    var unCompleteTasksList = NSMutableArray()
    var tableView = UITableView()
    var isMoreClicked = false
    var selectedButtonRow = -1
    
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if(Commons.connectedToNetwork())
        {
            
            GetActiveContractsAPICall()
            
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       // GetMyActiveContractsAPICall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBActions Methods
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
        isMyAppSelected = false
        if(Commons.connectedToNetwork())
        {
            
            GetActiveContractsAPICall()
            
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
        case 1:
        isMyAppSelected = true
        if(Commons.connectedToNetwork())
        {
            
            GetMyActiveContractsAPICall()
            
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
        default:
            break;
        }
    }
    


    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)

    }
    @IBAction func backLargeBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unCompleteTasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
//        @IBOutlet weak var userProfilePic: UIButton!
//        @IBOutlet weak var userName: UILabel!
//        @IBOutlet weak var descriptionText: UILabel!
//        @IBOutlet weak var rate: UILabel!
//        @IBOutlet weak var ratingStar1: UIImageView!
//        @IBOutlet weak var location: UILabel!
//        @IBOutlet weak var categories: UILabel!
//        @IBOutlet weak var ratingStar2: UIImageView!
//        @IBOutlet weak var deadline: UILabel!
//        @IBOutlet weak var ratingStar3: UIImageView!
//        @IBOutlet weak var ratingStar4: UIImageView!
//        @IBOutlet weak var ratingStar5: UIImageView!
//        @IBOutlet weak var readMore: UIButton!
//        @IBOutlet weak var completeAndPay: UIButton!
        
        if(isMyAppSelected)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myApplicationCell", for: indexPath)as! MyApplicationTableViewCell
            
            let markerDetails = unCompleteTasksList[indexPath.row] as! ActiveProjectModel
            if(!(markerDetails.profile_img.isEqual("")))
            {
                cell.myAppuserProfilePic.sd_setBackgroundImage(with: URL(string: markerDetails.profile_img), for: .normal)
            }
            else
            {
                
                cell.myAppuserProfilePic.setBackgroundImage( UIImage(named: "placeholder.png"), for: .normal)
            }
            
            
            // cell.gigProfileImg.sd_setImage(with: URL(string: markerDetails.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
            
            cell.myAppuserProfilePic.tag = indexPath.row + 10
            cell.myAppuserProfilePic.addTarget(self, action: #selector(buttonProfileTapped(_:)), for: .touchUpInside)
            
            
            
            if(markerDetails.type_of_payment.isEqual("0"))
            {
                cell.myApprate.text = "$ " + markerDetails.pay +  " Flat"
                
            }
            else
            {
                cell.myApprate.text = "$ " + markerDetails.pay + " Hourly"
                
            }
            cell.myAppuserName.text = markerDetails.first_name + " " + markerDetails.last_name
            cell.myAppdescriptionText.text = markerDetails.gig_description
            if isMoreClicked && selectedButtonRow == indexPath.row {
                cell.myAppdescriptionText.numberOfLines = 0
                cell.readMoreLabel.text = "show less"
            }else  {
                cell.myAppdescriptionText.numberOfLines = 2
                cell.readMoreLabel.text = "read more"
            }
            
            cell.myAppdeadline.text = Commons.changeDateFormat(dateFrom: markerDetails.deadline)
            if(markerDetails.categoryList.isEqual(""))
            {
                cell.myApplocation.text = markerDetails.city
                
            }
            else
            {
                cell.myApplocation.text = markerDetails.city + ", " + markerDetails.country
                
            }
            if(markerDetails.categoryList.count>0 && markerDetails.categoryList.count<=1)
            {
                let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
                cell.myAppcategories.text = catObj1.catName
            }
            else if(markerDetails.categoryList.count>1)
            {
                let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
                let catObj2 = markerDetails.categoryList.object(at: 1) as! CategoryModel
                cell.myAppcategories.text = catObj1.catName + "," + catObj2.catName
            }
            else if(markerDetails.categoryList.count>2)
            {
                let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
                let catObj2 = markerDetails.categoryList.object(at: 1) as! CategoryModel
                let catObj3 = markerDetails.categoryList.object(at: 2) as! CategoryModel
                cell.myAppcategories.text = catObj1.catName + "," + catObj2.catName + "," + catObj3.catName
            }
            
            cell.myAppuserProfilePic.backgroundColor = .clear
            cell.myAppuserProfilePic.layer.borderWidth=1.0
            cell.myAppuserProfilePic.layer.masksToBounds = false
            cell.myAppuserProfilePic.layer.borderColor = UIColor.white.cgColor
            cell.myAppuserProfilePic.layer.cornerRadius = 13
            cell.myAppuserProfilePic.layer.cornerRadius = cell.myAppuserProfilePic.frame.size.height/2
            cell.myAppuserProfilePic.clipsToBounds = true
            cell.myAppcompleteAndPay.tag = indexPath.row
            cell.myAppcompleteAndPay.addTarget(self, action: #selector(buttonCompleteTapped(_:)), for: .touchUpInside)
            
            cell.myAppreadMore.tag = indexPath.row + 100
            cell.myAppreadMore.addTarget(self, action: #selector(buttonSeeMoreTapped(_:)), for: .touchUpInside)
            
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "applicationCell", for: indexPath)as! ActiveProjectTableViewCell
            
            let markerDetails = unCompleteTasksList[indexPath.row] as! ActiveProjectModel
            if(!(markerDetails.profile_img.isEqual("")))
            {
                cell.userProfilePic.sd_setBackgroundImage(with: URL(string: markerDetails.profile_img), for: .normal)
            }
            else
            {
                
                cell.userProfilePic.setBackgroundImage( UIImage(named: "placeholder.png"), for: .normal)
            }
            
            
            // cell.gigProfileImg.sd_setImage(with: URL(string: markerDetails.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
            
            cell.userProfilePic.tag = indexPath.row + 10
            cell.userProfilePic.addTarget(self, action: #selector(buttonProfileTapped(_:)), for: .touchUpInside)
            
            
            
            if(markerDetails.type_of_payment.isEqual("0"))
            {
                cell.rate.text = "$ " + markerDetails.pay +  " Flat"
                
            }
            else
            {
                cell.rate.text = "$ " + markerDetails.pay + " Hourly"
                
            }
            cell.userName.text = markerDetails.first_name + " " + markerDetails.last_name
            cell.descriptionText.text = markerDetails.gig_description
          
            if isMoreClicked && selectedButtonRow == indexPath.row {
                cell.descriptionText.numberOfLines = 0
                cell.readMoreLabel.text = "show less"
            }else {
                cell.descriptionText.numberOfLines = 2
                cell.readMoreLabel.text = "read more"
            }

            
            cell.deadline.text = Commons.changeDateFormat(dateFrom: markerDetails.deadline)
            if(markerDetails.categoryList.isEqual(""))
            {
                cell.location.text = markerDetails.city
                
            }
            else
            {
                cell.location.text = markerDetails.city + ", " + markerDetails.country
                
            }
            if(markerDetails.categoryList.count>0 && markerDetails.categoryList.count<=1)
            {
                let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
                cell.categories.text = catObj1.catName
            }
            else if(markerDetails.categoryList.count>1)
            {
                let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
                let catObj2 = markerDetails.categoryList.object(at: 1) as! CategoryModel
                cell.categories.text = catObj1.catName + "," + catObj2.catName
            }
            else if(markerDetails.categoryList.count>2)
            {
                let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
                let catObj2 = markerDetails.categoryList.object(at: 1) as! CategoryModel
                let catObj3 = markerDetails.categoryList.object(at: 2) as! CategoryModel
                cell.categories.text = catObj1.catName + "," + catObj2.catName + "," + catObj3.catName
            }
            
            cell.userProfilePic.backgroundColor = .clear
            cell.userProfilePic.layer.borderWidth=1.0
            cell.userProfilePic.layer.masksToBounds = false
            cell.userProfilePic.layer.borderColor = UIColor.white.cgColor
            cell.userProfilePic.layer.cornerRadius = 13
            cell.userProfilePic.layer.cornerRadius = cell.userProfilePic.frame.size.height/2
            cell.userProfilePic.clipsToBounds = true
            cell.completeAndPay.tag = indexPath.row
            cell.completeAndPay.addTarget(self, action: #selector(buttonCompleteAndPayTapped(_:)), for: .touchUpInside)
            
            cell.readMore.tag = indexPath.row + 100
            cell.readMore.addTarget(self, action: #selector(buttonSeeMoreTapped(_:)), for: .touchUpInside)
            
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func buttonProfileTapped(_ sender : UIButton){
        let buttonRow = sender.tag - 10
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
        let markerDetails = unCompleteTasksList[buttonRow] as! ActiveProjectModel
        nextViewController.profileId = markerDetails.userId
        nextViewController.profilePicUrl = markerDetails.profile_img
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    func buttonCompleteAndPayTapped(_ sender : UIButton) {
        
        let buttonRow = sender.tag
        print(buttonRow)
        let markerDetails = unCompleteTasksList[buttonRow] as! ActiveProjectModel
        //CompleteTaskAPICall(markerDetails.orderGigPostId)
        CheckCardAPICall(markerDetails.orderGigPostId,sellerId: markerDetails.userId)
        //sellerCompleteGigPostResponseAPIURL
    }
    func buttonCompleteTapped(_ sender : UIButton) {
        
        let buttonRow = sender.tag
        print(buttonRow)
        let markerDetails = unCompleteTasksList[buttonRow] as! ActiveProjectModel
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addExpenseVC") as! AddExpenseViewController
        nextViewController.order_gig_post = markerDetails.orderGigPostId
        self.navigationController?.pushViewController(nextViewController, animated:true)
        //CompleteTaskAPICall(markerDetails.orderGigPostId)
    }
    func buttonSeeMoreTapped(_ sender : UIButton) {
        let row = sender.tag-100
        if selectedButtonRow == -1 {
            selectedButtonRow = row
        }
        
        if (row == selectedButtonRow) {
            selectedButtonRow = row
            isMoreClicked = !isMoreClicked
        } else {
            isMoreClicked = true
        }
        selectedButtonRow = sender.tag-100
      //  print(buttonRow)
       // isMoreClicked = !isMoreClicked
        
        self.tableView.reloadData()
    }
    
    //MARK:- Get Conversation Api Call
    func GetActiveContractsAPICall()
    {
        //self.showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getBuyerUnCompletedGigPostsAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseConversationsResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseConversationsResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
      //  self.hideProgressLoader()
        print(code)
        self.hideProgressLoader()
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
            unCompleteTasksList.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            for i in 0..<msgArray.count {
                let gigDetails = ActiveProjectModel ()
                let firstObject = msgArray[i] as! NSDictionary
                let userInfo = firstObject["UserInfo"] as! NSDictionary
                let orderGigPost = firstObject["OrderGigPost"] as! NSDictionary
                let gigInfo = firstObject["GigPost"] as! NSDictionary
                let locationInfo = firstObject["Location"] as! NSDictionary
                //let distance = firstObject["Distance"] as! Int
                gigDetails.userId = userInfo["user_id"] as! String
                gigDetails.orderGigPostId = orderGigPost["order_gig_post_id"] as! String
                gigDetails.first_name = userInfo["first_name"] as! String
                gigDetails.last_name = userInfo["last_name"] as! String
              //  gigDetails.phone_no = userInfo["phone_no"] as! String
                if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                    gigDetails.profile_img = String (userInfo["profile_img"] as! String)
                }else{
                    gigDetails.profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
                }
              //  gigDetails.registration_date = Commons.changeDateFormat(dateFrom: userInfo["registration_date"] as! String)
                gigDetails.gig_post_id = gigInfo["gig_post_id"] as! String
             //   gigDetails.gig_user_id = gigInfo["user_id"] as! String
                gigDetails.gig_description = gigInfo["description"] as! String
                gigDetails.deadline = gigInfo["deadline"] as! String
                gigDetails.pay = gigInfo["pay"] as! String
               // gigDetails.type_of_payment = gigInfo["type_of_payment"] as! String
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
                
                //gigDetails.distance = String(distance)
                unCompleteTasksList.add(gigDetails)
                

            }
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
    //MARK:- Get Conversation Api Call
    func GetMyActiveContractsAPICall()
    {
        //self.showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.showGigPostsOnSellerScreenAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseConversationsResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseMyConversationsResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        //  self.hideProgressLoader()
        print(code)
        self.hideProgressLoader()
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
            unCompleteTasksList.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            for i in 0..<msgArray.count {
                var gigDetails = ActiveProjectModel ()
                let firstObject = msgArray[i] as! NSDictionary
                let userInfo = firstObject["UserInfo"] as! NSDictionary
                let orderGigPost = firstObject["OrderGigPost"] as! NSDictionary
                let gigInfo = firstObject["GigPost"] as! NSDictionary
                let locationInfo = firstObject["Location"] as! NSDictionary
                //let distance = firstObject["Distance"] as! Int
                gigDetails.userId = userInfo["user_id"] as! String
                gigDetails.orderGigPostId = orderGigPost["order_gig_post_id"] as! String
                gigDetails.first_name = userInfo["first_name"] as! String
                gigDetails.last_name = userInfo["last_name"] as! String
                //  gigDetails.phone_no = userInfo["phone_no"] as! String
                if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                    gigDetails.profile_img = String (userInfo["profile_img"] as! String)
                }else{
                    gigDetails.profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
                }
                //  gigDetails.registration_date = Commons.changeDateFormat(dateFrom: userInfo["registration_date"] as! String)
                gigDetails.gig_post_id = gigInfo["gig_post_id"] as! String
                //   gigDetails.gig_user_id = gigInfo["user_id"] as! String
                gigDetails.gig_description = gigInfo["description"] as! String
                gigDetails.deadline = gigInfo["deadline"] as! String
                gigDetails.pay = gigInfo["pay"] as! String
                // gigDetails.type_of_payment = gigInfo["type_of_payment"] as! String
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
                
                //gigDetails.distance = String(distance)
                unCompleteTasksList.add(gigDetails)
                
                
            }
            self.tableView.reloadData()
        }
        
    }
    
    //MARK:- Get Conversation Api Call
    func CompleteTaskAPICall(_ orderPostId:String)
    {
        //self.showProgressLoader()
        let params = ["order_gig_post_id":orderPostId] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.sellerCompleteGigPostResponseAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseCompleteTaskResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseCompleteTaskResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        //  self.hideProgressLoader()
        print(code)
        self.hideProgressLoader()
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
            GetMyActiveContractsAPICall()
            let msgArray = dict?["msg"] as! String
            print(msgArray)
            showAlert(msgArray, VC: self)
        }
        
    }
    
    
    
    
    //MARK:- Get Conversation Api Call
    func CheckCardAPICall(_ orderPostId:String, sellerId: String)
    {
        //self.showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getUserPaymentDetailsAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.checkCardTaskResponse(result as String,orderPostId: orderPostId as String, sellerId: sellerId)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func checkCardTaskResponse(_ response:String, orderPostId:String, sellerId: String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        //  self.hideProgressLoader()
        print(code)
        self.hideProgressLoader()
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
           // GetMyActiveContractsAPICall()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)

            if(msgArray.count==0)
            {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addCardVc") as! AddCardViewController
                nextViewController.isCardExist = "0"
                self.navigationController?.pushViewController(nextViewController, animated:true)
            }
            else
            {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addTipVC") as! AddTipViewController
                nextViewController.order_gig_post = orderPostId
                nextViewController.sellerid = sellerId
                self.navigationController?.pushViewController(nextViewController, animated:true)
            }
            //showAlert(msgArray, VC: self)
        }
        
    }
    
     func showAlert(_ error: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: "Congratulations", message: "Task has been completed.", preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
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
