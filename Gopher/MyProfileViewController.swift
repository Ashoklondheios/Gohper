//
//  MyProfileViewController.swift
//  Gopher
//
//  Created by User on 2/10/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking

class MyProfileViewController: BaseViewController, UIPopoverPresentationControllerDelegate,MyProtocol,MySkillsProtocol
 {
   // MARK: IBOutlet Properties
    var window: UIWindow?
    @IBOutlet weak var worldRankLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var totalEarnings: UILabel!
    @IBOutlet weak var availableForGigsLabel: UISwitch!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overAllRatingBasedLabel: UILabel!
    @IBOutlet weak var star1Image: UIImageView!
    @IBOutlet weak var star2Image: UIImageView!
    @IBOutlet weak var star3Image: UIImageView!
    @IBOutlet weak var star4Image: UIImageView!
    @IBOutlet weak var star5Image: UIImageView!
    @IBOutlet weak var catogriesScrollView: UIScrollView!
    @IBOutlet weak var skillsScrollView: UIScrollView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var activeContractProfileImageView: UIImageView!
    @IBOutlet weak var activeContractProfileImageView2: UIImageView!
    @IBOutlet weak var activeContractTaskTypeLabel: UILabel!
    @IBOutlet weak var activeContractTaskPriceLabel: UILabel!
    @IBOutlet weak var activeContractTaskType2: UILabel!
    @IBOutlet weak var activeContractTaskPriceLabel2: UILabel!
    @IBOutlet weak var activePostsProfileImageView: UIImageView!
    @IBOutlet weak var activePostsProfileImageView2: UIImageView!
    @IBOutlet weak var activePostsTaskTypeLabel: UILabel!
    @IBOutlet weak var activePostsTaskTypeLabel2: UILabel!
    @IBOutlet weak var activePostsTaskPriceLabel: UILabel!
    @IBOutlet weak var activePostsTaskPriceLabel2: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var indicatir: UIActivityIndicatorView!
    
    // MARK: Variables
    var userModel = UserModel.Instance()
    var defaultXValueforView = 5;
    var defaultCategoryScrollContentSize = 100;
    var defaultXValueforSkillsView = 5;
    var defaultSkillsScrollContentSize = 100;
    var categoryList = NSMutableArray()
    var skillsList = NSMutableArray()
    var availableForGigs = "0"
    var stars="0"
    var counts="0"
    // MARK: Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.hideProgressLoader()
        // Do any additional setup after loading the view.
        parentScrollView.isUserInteractionEnabled = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        parentScrollView.contentSize = CGSize(width: screenWidth, height: 800)
        self.setValuesToFields()
        
        self.addCategoriesToView()
        //self.addSkillsToView()
        profilePicImageView.layer.borderWidth=1.0
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.borderColor = UIColor.white.cgColor
        profilePicImageView.layer.cornerRadius = 13
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.height/2
        profilePicImageView.clipsToBounds = true
        
        self.MakeAPICall()
        
        //availableForGigsLabel.addTarget(self, action: #selector(deferSwitchToggled(_:)), for: UIControlEvents.valueChanged)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setting Values
    func setValuesToFields()
    {
        self.skillsList.removeAllObjects()
        self.categoryList.removeAllObjects()
        userModel = UserModel.getUserData()
        //let url = NSURL(string: userModel.profile_img)
        //        profilePicImg.setImageWith(url as! URL)
        profilePicImageView.sd_setImage(with: URL(string: userModel.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        // profilePicImg.setImageWith.sd_setImage(with: URL(string: userModel.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        personNameLabel.text = userModel.first_name.uppercased() + " " + userModel.last_name.uppercased()
        let city = UserDefaults.standard.object(forKey: "city") as? String ?? ""
        let country = UserDefaults.standard.object(forKey: "country") as? String ?? ""
        
        
        if city != "" {
        
            countryNameLabel.text="\(city), \(country)"
        
        }else{
        
            countryNameLabel.text=""
            
        }
        
        
        categoryList = userModel.categoryList
        skillsList = userModel.skillsList
        print(skillsList.count)
        if(userModel.availableForGigs.isEqual("0"))
        {
            //self.availableForGigsLabel.setOn(false, animated: false)
            
        }
        else
        {
            //self.availableForGigsLabel.setOn(true, animated: false)

        }
        //        lastNameTextField.text =
        //        emailTextField.text = userModel.email
        //        phoneNoTextField.text = userModel.phone_no
    }
    
    // MARK: IBAction methodss
    func deferSwitchToggled(_ mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        if(value)
        {
            //On
            availableForGigs = "1"
            if Commons.connectedToNetwork() {
                self.MakeAvialableForGigsAPICall()

            }
            else {
                Commons.showAlert("Network Error", VC: self)
            }
        }
        else
        {
            //off
            availableForGigs = "0"
            if Commons.connectedToNetwork() {
                self.MakeAvialableForGigsAPICall()
                
            }
            else {
                Commons.showAlert("Network Error", VC: self)
            }
            
        }
    }

    @IBAction func availableforGigs(_ sender: Any) {
       
    }
    @IBAction func menuLargeBTN(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()

    }
    @IBAction func menuBTN(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()

    }
    @IBAction func viewAllReviewBTN(_ sender: Any) {
        performSegue(withIdentifier: "segueToAllReview", sender: nil)
        
    }
    
    
    
    @IBAction func addCategoriesBTN(_ sender: Any) {
        self.addCategory()
    }
    
    @IBAction func addSkillsBTN(_ sender: Any) {
        self.addSkills()
    }
    
    @IBAction func seeMoreContracts(_ sender: Any) {
        //activeContractVC
       //postGigMapVC
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "activeContractVC") as! ActiveContractsViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    
    @IBAction func openSettings(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
//        self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func seeMorePosts(_ sender: Any) {
    }
    
    // MARK: Add Categories To View
    
    func addCategoriesToView()
    {
        
        for i in 0..<categoryList.count {
            
            let catogry = categoryList[i] as! CategoryModel
            defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 90
            catogriesScrollView.addSubview(self.createViewForCatogry(name: catogry.catName, heightOfParent: Int(catogriesScrollView.frame.size.height)))
            catogriesScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
            
        }
        defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 100
        catogriesScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
        catogriesScrollView.showsHorizontalScrollIndicator = false
        catogriesScrollView.showsVerticalScrollIndicator = false
    }
    
    func createViewForCatogry(name: String, heightOfParent: Int) -> UIView {
        
        let catogeryView=UIView(frame: CGRect(x:defaultXValueforView, y:5, width:100, height:30))
        catogeryView.backgroundColor = Commons.UIColorFromRGB(rgbValue: 0xdfdfdf)
        
        let categoryName: UILabel = UILabel()
        categoryName.frame = CGRect(x: 8, y:5, width:80, height:21)
        categoryName.textColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        categoryName.textAlignment = NSTextAlignment.center
        categoryName.text = name
        categoryName.font = categoryName.font.withSize(10)
        catogeryView.addSubview(categoryName)
        defaultXValueforView = defaultXValueforView + 110;
        return catogeryView
    }
    
     // MARK: Add Skills To View
    
    func addSkillsToView()
    {
//        for i in 0..<skillsList.count {
//            
//            let skills = skillsList[i] as! SkillsModel
//            
//            //defaultXValueforSkillsView
//            defaultSkillsScrollContentSize = defaultSkillsScrollContentSize + 90
//            skillsScrollView.addSubview(self.createViewForSkill(name: skills.skillName, heightOfParent: Int(skillsScrollView.frame.size.height)))
//            skillsScrollView.contentSize = CGSize(width: defaultSkillsScrollContentSize, height:40)
//            
//        }
//        defaultSkillsScrollContentSize = defaultSkillsScrollContentSize + 100
//        skillsScrollView.contentSize = CGSize(width: defaultSkillsScrollContentSize, height:40)
//        skillsScrollView.showsHorizontalScrollIndicator = false
//        skillsScrollView.showsVerticalScrollIndicator = false
    }
    
    func createViewForSkill(name: String, heightOfParent: Int) -> UIView {
        
        let skillsView=UIView(frame: CGRect(x:defaultXValueforSkillsView, y:5, width:100, height:30))
        skillsView.backgroundColor=Commons.UIColorFromRGB(rgbValue: 0xdfdfdf)
        
        let skillName: UILabel = UILabel()
        skillName.frame = CGRect(x: 8, y:5, width:80, height:21)
        skillName.textColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        skillName.textAlignment = NSTextAlignment.center
        skillName.text = name
        skillName.font = skillName.font.withSize(10)
        skillsView.addSubview(skillName)
        defaultXValueforSkillsView = defaultXValueforSkillsView + 110;
        return skillsView
    }
    
    // MARK: Popover View Controller for Skills and Category
    
    func addSkills() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "skillsVC") as! SkillsPopoverViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width:500,height:400)
        popoverContent.mSkillsDelegate = self
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x:screenWidth/2-90,y:screenHeight/2,width:0,height:0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
    func addCategory() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "categoryVC") as! CategoriesViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width:500,height:400)
        popover?.delegate = self
        popover?.sourceView = self.view
        popoverContent.mDelegate = self
        popover?.sourceRect = CGRect(x:screenWidth/2-90,y:screenHeight/2,width:0,height:0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)

        self.present(nav, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    // MARK: Delegate Method for Category
    
    func sendArrayToPreviousVC(myArray:NSMutableArray) {
        //DO YOUR THING
        for view in self.catogriesScrollView.subviews {
            view.removeFromSuperview()
        }
        defaultCategoryScrollContentSize = 100
        defaultXValueforView = 5;
        categoryList = NSMutableArray()
        categoryList = myArray
        self.addCategoriesToView()
        if(categoryList.count>0)
        {
            if(Commons.connectedToNetwork())
            {
                
                MakeAddUserCategoriesAPICall()
            }
            else
            {
                Commons.showAlert("Please check your connection", VC: self)
            }
        }
    }
    
    func getCatIdArray () -> NSMutableArray
    {
        let ids = NSMutableArray()
        var dicSet = NSMutableDictionary()
        
        for i in 0..<categoryList.count {
            
            let catogry = categoryList[i] as! CategoryModel
            let catId = catogry.catID
            dicSet = NSMutableDictionary()
            dicSet.setValue(catId, forKey: "cat_id")
            ids.add(dicSet)
            
        }
        
        return ids
    }
    
    
    // MARK: API Call for Switch
    
    func MakeAvialableForGigsAPICall()
    {
        
        let params = ["user_id":userModel.userId,"available_for_gigs":availableForGigs] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.availableForGigsAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseSignUpResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    
    fileprivate func parseAvailableForGigsResponse(_ response:String) {
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
            UserDefaults.standard.set(response, forKey: Constants.USERRESPONSEKEY)
            UserModel.initialize()
            UserModel.instance.parseSignUpResponse(response)

        }
    }
    
    // MARK: API Call for Category
    
    func MakeAddUserCategoriesAPICall()
    {
        
        let params = ["user_id":userModel.userId,"categories":self.getCatIdArray()] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.ADDUSERCATEGORYAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseSignUpResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    
    fileprivate func parseCategoriesResponse(_ response:String) {
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
            let msgArray = dict?["msg"] as! NSArray
            var categoryModel = CategoryModel()
            for i in 0..<msgArray.count {
                let firstObject = msgArray[i] as! NSDictionary
                let objectval = firstObject["Category"] as! NSDictionary
                categoryModel = CategoryModel()
                categoryModel.catID = objectval["cat_id"] as! String
                categoryModel.catName = objectval["cat_name"] as! String
                categoryModel.isSelected = false
                categoryList.add(categoryModel as CategoryModel)
                print(categoryModel.catID)
                print(categoryModel.catName)
            }
            print(categoryList.count)
        }
    }
    // MARK: Delegate Method for Skills
    
    func sendSkillsToPreviousVC(myArray:NSMutableArray) {
        //DO YOUR THING
        for view in self.skillsScrollView.subviews {
            view.removeFromSuperview()
        }
        defaultSkillsScrollContentSize = 100
        defaultXValueforSkillsView = 5;
       // skillsList = NSMutableArray()
        skillsList.removeAllObjects()
//        skillsList.arrayByAddingObjectsFromArray(myArray as SkillsModel) // Swift 3
        for i in 0..<myArray.count {
            
            let skills = myArray[i] as! SkillsModel
            skillsList.add(skills)
        }
        print(skillsList.count)
        //self.addSkillsToView()
//        if(skillsList.count>0)
//        {
//            if(Commons.connectedToNetwork())
//            {
//                
//                MakeAddUserSkillsAPICall()
//            }
//            else
//            {
//                Commons.showAlert("Please check your connection", VC: self)
//            }
//            
//        }
    }
    
    func getSkillsIdArray () -> NSMutableArray
    {
        let ids = NSMutableArray()
        var dicSet = NSMutableDictionary()
        
        for i in 0..<skillsList.count {
            
            let skill = skillsList[i] as! SkillsModel
            let catId = skill.skillName
            dicSet = NSMutableDictionary()
            dicSet.setValue(catId, forKey: "skill_name")
            ids.add(dicSet)
            
        }
        
        return ids
    }
    
    // MARK: API Call for Skills
    
    func MakeAddUserSkillsAPICall()
    {
        
        let params = ["user_id":userModel.userId,"skills":self.getSkillsIdArray()] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.ADDUSERSKILLAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseSignUpResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
   
    fileprivate func parseSignUpResponse(_ response:String) {
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
            UserDefaults.standard.set(response, forKey: Constants.USERRESPONSEKEY)
            UserModel.initialize()
            UserModel.instance.parseSignUpResponse(response)
            
            print(UserModel.instance.email)
            self.setValuesToFields()
           // self.showAlert("Gig has been posted successfully","Congratulations", VC: self)
        }
    }
    
    // MARK: Help Methods
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAllReview" {
            
            
            
            
            
            let destinationVC = segue.destination as! AllReviewsViewController
            
            destinationVC.user_id=userModel.userId
            
            
            
            
        }
    }
    
    func MakeAPICall()
    {
        showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.PUBLICUSERPROFILEAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    
    fileprivate func parseResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        hideProgressLoader()
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
            let msgArray = dict?["msg"] as! NSArray
            if(msgArray.count>0)
            {
                let firstObject = msgArray[0] as! NSDictionary
                //let userInfo = firstObject["UserInfo"] as! NSDictionary
                //let user = firstObject["User"] as! NSDictionary
                let rating = firstObject["Ratings"] as! NSDictionary
                stars="\(rating["stars"] ?? "0")"
                counts="\(rating["count"] ?? "0")"
                
                if stars=="<null>"{
                
                    stars="0"
                    counts="0"
                }
                
                self.setRatings()
                

            }
        }
    
    
    }
    
    func setRatings(){
        
        
        ratingLabel.text="\(stars)"
        overAllRatingBasedLabel.text="\(stars) out of 5 Rating based on \(counts) users"
        
        if stars == "0" {
            
            
            
            star1Image.image=UIImage(named: "starempty")
            star2Image.image=UIImage(named: "starempty")
            star3Image.image=UIImage(named: "starempty")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
        }else if stars == "0.5" {
            
            
            
            star1Image.image=UIImage(named: "starhalf")
            star2Image.image=UIImage(named: "starempty")
            star3Image.image=UIImage(named: "starempty")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
        }else if stars == "1" {
            
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "starempty")
            star3Image.image=UIImage(named: "starempty")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
            
            
        }else if stars == "1.5" {
            
            
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "starhalf")
            star3Image.image=UIImage(named: "starempty")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
        }else if stars == "2" {
            
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "starempty")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
            
            
            
        }else if stars == "2.5" {
            
            
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "starhalf")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
        }else if stars == "3" {
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "star")
            star4Image.image=UIImage(named: "starempty")
            star5Image.image=UIImage(named: "starempty")
            
            
            
            
        }else if stars == "3.5" {
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "star")
            star4Image.image=UIImage(named: "starhalf")
            star5Image.image=UIImage(named: "starempty")
            
            
            
            
        }else if stars == "4" {
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "star")
            star4Image.image=UIImage(named: "star")
            star5Image.image=UIImage(named: "starempty")
            
            
            
        }else if stars == "4.5" {
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "star")
            star4Image.image=UIImage(named: "star")
            star5Image.image=UIImage(named: "starhalf")
            
            
            
        }else if stars == "5" {
            
            star1Image.image=UIImage(named: "star")
            star2Image.image=UIImage(named: "star")
            star3Image.image=UIImage(named: "star")
            star4Image.image=UIImage(named: "star")
            star5Image.image=UIImage(named: "star")
            
            
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
