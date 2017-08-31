//
//  MyProfilePosts.swift
//  Gopher
//
//  Created by User on 7/19/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation

class MyProfilePosts: BaseViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    // MARK: IBOutlet Properties
    @IBOutlet weak var seeMoreActiveBtn: UIButton!
    @IBOutlet weak var seeMorePrevBtn: UIButton!
    @IBOutlet weak var seeMoreRentalBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var worldRankText: UILabel!
    @IBOutlet weak var totalEarningText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var ratingsText: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var reviewText: UILabel!
    
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
  
    
    
    @IBOutlet weak var postImage1: UIImageView!
    @IBOutlet weak var postImage2: UIImageView!
    @IBOutlet weak var postImage3: UIImageView!
    @IBOutlet weak var postImage4: UIImageView!
    
    @IBOutlet weak var rentImage1: UIImageView!
    @IBOutlet weak var rentImage2: UIImageView!
    @IBOutlet weak var rentImage3: UIImageView!
    @IBOutlet weak var rentImage4: UIImageView!
    
    @IBOutlet weak var prevImage1: UIImageView!
    @IBOutlet weak var prevImage2: UIImageView!
    @IBOutlet weak var prevImage3: UIImageView!
    @IBOutlet weak var prevImage4: UIImageView!
    
    
    @IBOutlet weak var postLabel1: UILabel!
    @IBOutlet weak var postLabel2: UILabel!
    @IBOutlet weak var postLabel3: UILabel!
    @IBOutlet weak var postLabel4: UILabel!
    
    @IBOutlet weak var rentLabel1: UILabel!
    @IBOutlet weak var rentLabel2: UILabel!
    @IBOutlet weak var rentLabel3: UILabel!
    @IBOutlet weak var rentLabel4: UILabel!
    
    @IBOutlet weak var prevLabel1: UILabel!
    @IBOutlet weak var prevLabel2: UILabel!
    @IBOutlet weak var prevLabel3: UILabel!
    @IBOutlet weak var prevLabel4: UILabel!
    
    
    
    
    
    
    // MARK: Variables
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
    var profileId = ""
    var categoryList = ""
    var skillsList = ""
    var profilePicUrl = ""
    var currentUserId=""
    var stars="0"
    var counts="0"
    var last_rating_star="0"
    var last_rating_comment=""
    var last_rating_date=""
    
    var ActivePosts=[[String:Any]]()
    var DeActivePosts=[[String:Any]]()
    var PreviousPosts=[[String:Any]]()
    var mode="-1"
    
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserId=UserModel.Instance().userId
        profileId=UserModel.Instance().userId
        name.text=""
        country.text=""
        parentScrollView.isUserInteractionEnabled = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        parentScrollView.contentSize = CGSize(width: screenWidth, height: 800)
        profilePic.sd_setImage(with: URL(string: profilePicUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        profilePic.layer.borderWidth=1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.cornerRadius = 13
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.clipsToBounds = true
        self.MakeAPICall()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- IBActions Methods
    
    @IBAction func seeAllReviews(_ sender: Any) {
        performSegue(withIdentifier: "segueToAllReview", sender: nil)
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtn(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func MakeAPICall()
    {
        showProgressLoader()
        let params = ["user_id":profileId] as [String : Any]
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
        print(dict)
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
                let userInfo = firstObject["UserInfo"] as! NSDictionary
                //let user = firstObject["User"] as! NSDictionary
                let rating = firstObject["Ratings"] as! NSDictionary
                
                stars="\(rating["stars"] ?? "0")"
                counts="\(rating["count"] ?? "0")"
                last_rating_star="\(rating["last_rating_stars"] ?? "0")"
                last_rating_comment="\(rating["last_rating_comment"] ?? "0")"
                last_rating_date=Commons.reviewDateFormat(dateFrom: "\(rating["last_rating_date"] ?? "")")
                
                if stars=="<null>"{
                    
                    stars="0"
                    counts="0"
                    last_rating_star="-1"
                    last_rating_comment=""
                    last_rating_date=""
                    
                }
                
                self.setRatings()
                
                if let activeArray=firstObject["ActiveGigPost"] as! NSArray?{
                    
                    ActivePosts.removeAll()
                    for i in 0..<activeArray.count{
                        
                        let dictObject=activeArray[i] as! NSDictionary
                        
                        var itemDict=[String:Any]()
                        if let imageName = dictObject["image"] as? String {
                            itemDict["image"]=String (Constants.PROFILEBASEURL) + String (imageName)
                        }
                        
                        itemDict["title"]=dictObject["title"]
                        itemDict["gig_post_id"]=dictObject["gig_post_id"]
                        
                        ActivePosts.append(itemDict)
                        
                    }
                    
                    self.loadActives()
                    self.loadRental()
                    
                }
                
                
                if let deactiveArray=firstObject["DeactiveGigPost"] as! NSArray?{
                    
                    DeActivePosts.removeAll()
                    for i in 0..<deactiveArray.count{
                        
                        let dictObject=deactiveArray[i] as! NSDictionary
                        
                        var itemDict=[String:Any]()
                        
                        itemDict["image"]=String (Constants.PROFILEBASEURL) + String (dictObject["image"] as! String)
                        itemDict["title"]=dictObject["title"]
                        itemDict["gig_post_id"]=dictObject["gig_post_id"]
                        
                        DeActivePosts.append(itemDict)
                        
                        
                    }
                    
                    self.loadDeActives()
                }
                
                
                
                
                let UserLocation = firstObject["UserLocation"] as! NSDictionary
                currentUserId = userInfo[keyUserId] as! String
                //let email = user[keyEmail] as! String
                if let first_name = userInfo[keyFirstName] as? String, let last_name = userInfo[keyLastName] as? String {
                    name.text = "\(first_name) \(last_name)"
                }
                
                let latitudeString=UserLocation["lat"] as? String ?? ""
                let longitudeString=UserLocation["long"] as? String ?? ""
                
                
                if latitudeString == "" {
                    
                    self.country.text=""
                    
                    
                }else{
                    
                    let location = CLLocation(latitude: Double(latitudeString)!, longitude: Double(longitudeString)!) //changed!!!
                    print(location)
                    
                    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                        print(location)
                        
                        if error != nil {
                            print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                            return
                        }
                        
                        if (placemarks?.count)! > 0 {
                            let pm = placemarks?[0] as CLPlacemark?
                            print(pm?.locality ?? "")
                            
                            if pm?.locality != "" {
                                
                                self.country.text="\(pm?.locality ?? ""), \(pm?.country ?? "")"
                                
                                
                            }else{
                                
                                
                                self.country.text=""
                            }
                            UserDefaults.standard.set(pm?.locality ?? "", forKey: "city")
                            UserDefaults.standard.set(pm?.country ?? "", forKey: "country")
                            
                        }
                        else {
                            print("Problem with the data received from geocoder")
                        }
                    })
                    
                    
                }
                
                
                let phone_no = userInfo[keyphoneNo] as! String
                var profile_img = ""
                
                if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                    profile_img = String (userInfo["profile_img"] as! String)
                }else{
                    profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
                }
                
                
                let registration_date = userInfo[keyRegistrationDate] as! String
                var about = ""
                if( !(userInfo[keyAbout] is NSNull))
                {
                    about = userInfo[keyAbout] as! String
                }
                
                //self.Bio.text = about
                
                print(firstObject)
                let catList = firstObject["UserCategory"] as! NSArray
                for i in 0..<catList.count {
                    let catObj = catList[i] as! NSDictionary
                    let catListObj = CategoryModel()
                    catListObj.catID = catObj.value(forKey: "cat_id") as! String
                    let catNameObj = catObj.value(forKey: "Category") as! NSDictionary
                    catListObj.catName = catNameObj.value(forKey: "cat_name") as! String
                    if(catList.count == 1 || i == 0)
                    {
                        categoryList = catListObj.catName
                    }
                    else
                    {
                        categoryList = categoryList + ", " + catListObj.catName
                    }
                    
                }
                //            let skillList = firstObject["Skill"] as! NSArray
                //            for i in 0..<skillList.count {
                //                let skillObj = skillList[i] as! NSDictionary
                //                let skillListObj = SkillsModel()
                //                skillListObj.skillID = skillObj.value(forKey: "skill_id") as! String
                //                skillListObj.skillName = skillObj.value(forKey: "skill_name") as! String
                //                if(skillList.count == 1 || i == 0)
                //                {
                //                    skillsList = skillListObj.skillName
                //                }
                //                else
                //                {
                //                    skillsList = skillsList + ", " + skillListObj.skillName
                //                }
                //            }
                //            self.skillsText.text = skillsList
                //self.categories.text = categoryList
            }
        }
    }
    
    func loadActives(){
        
        seeMoreActiveBtn.isHidden=false
        
        for i in 0..<ActivePosts.count{
            
            let item=ActivePosts[i] as [String:Any]
            var postImage = ""
            if let postImage1 = item["image"] as? String {
                postImage = postImage1
            }
          //  let postImage = item["image"] as! String
            
            let postName = item["title"] as! String
            
            if i == 0{
                
                postImage1.sd_setImage(with: URL(string: postImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                postLabel1.text = postName
                
                postImage1.isHidden=false
                
                postLabel1.isHidden=false
                
                
            }else if i == 1{
                
                postImage2.sd_setImage(with: URL(string: postImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                postLabel2.text = postName
                
                postImage2.isHidden=false
                
                postLabel2.isHidden=false
                
                
                
            }else if i == 2{
                
                postImage3.sd_setImage(with: URL(string: postImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                postLabel3.text = postName
                
                postImage3.isHidden=false
                
                postLabel3.isHidden=false
                
            }else if i == 3{
                
                postImage4.sd_setImage(with: URL(string: postImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                postLabel4.text = postName
                
                postImage4.isHidden=false
                
                postLabel4.isHidden=false
                
            }
            
        }
        
        
    }
    
    
    
    func loadDeActives(){
        
        seeMorePrevBtn.isHidden=false
        
        for i in 0..<DeActivePosts.count{
            
            let item=DeActivePosts[i] as [String:Any]
            
            let prevImage = item["image"] as! String
            
            let prevName = item["title"] as! String
            
            if i == 0{
                
                prevImage1.sd_setImage(with: URL(string: prevImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                prevLabel1.text = prevName
                
                prevImage1.isHidden=false
                
                prevLabel1.isHidden=false
                
                
            }else if i == 1{
                
                prevImage2.sd_setImage(with: URL(string: prevImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                prevLabel2.text = prevName
                
                prevImage2.isHidden=false
                
                prevLabel2.isHidden=false
                
                
                
            }else if i == 2{
                
                prevImage3.sd_setImage(with: URL(string: prevImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                prevLabel3.text = prevName
                
                prevImage3.isHidden=false
                
                prevLabel3.isHidden=false
                
            }else if i == 3{
                
                prevImage4.sd_setImage(with: URL(string: prevImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                prevLabel4.text = prevName
                
                prevImage4.isHidden=false
                
                prevLabel4.isHidden=false
                
            }
            
        }
        
        
    }
    
    
    func loadRental(){
        
        seeMoreRentalBtn.isHidden=false
        
        for i in 0..<ActivePosts.count{
            
            let item=ActivePosts[i] as [String:Any]
            var rentImage = ""
            if let rentImage1 =  item["image"] as? String {
                rentImage = rentImage1
            }
          //  let rentImage = item["image"] as! String
            
            let rentName = item["title"] as! String
            
            if i == 0{
                
                rentImage1.sd_setImage(with: URL(string: rentImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                rentLabel1.text = rentName
                
                rentImage1.isHidden=false
                
                rentLabel1.isHidden=false
                
                
            }else if i == 1{
                
                rentImage2.sd_setImage(with: URL(string: rentImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                rentLabel2.text = rentName
                
                rentImage2.isHidden=false
                
                rentLabel2.isHidden=false
                
                
                
            }else if i == 2{
                
                rentImage3.sd_setImage(with: URL(string: rentImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                rentLabel3.text = rentName
                
                rentImage3.isHidden=false
                
                rentLabel3.isHidden=false
                
            }else if i == 3{
                
                rentImage4.sd_setImage(with: URL(string: rentImage), placeholderImage: UIImage(named: "placeholder.png"))
                
                rentLabel4.text = rentName
                
                rentImage4.isHidden=false
                
                rentLabel4.isHidden=false
                
            }
            
        }
        
        
    }
    
    func setRatings(){
        
        ratingsText.text="\(stars)"
        reviewText.text="\(stars) out of 5 Rating based on \(counts) users"
        
        if stars == "0" {
            
            
            
            star1.image=UIImage(named: "starempty")
            star2.image=UIImage(named: "starempty")
            star3.image=UIImage(named: "starempty")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
        }else if stars == "0.5" {
            
            
            
            star1.image=UIImage(named: "starhalf")
            star2.image=UIImage(named: "starempty")
            star3.image=UIImage(named: "starempty")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
        }else if stars == "1" {
            
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "starempty")
            star3.image=UIImage(named: "starempty")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
            
            
        }else if stars == "1.5" {
            
            
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "starhalf")
            star3.image=UIImage(named: "starempty")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
        }else if stars == "2" {
            
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "starempty")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
            
            
            
        }else if stars == "2.5" {
            
            
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "starhalf")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
        }else if stars == "3" {
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "star")
            star4.image=UIImage(named: "starempty")
            star5.image=UIImage(named: "starempty")
            
            
            
            
        }else if stars == "3.5" {
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "star")
            star4.image=UIImage(named: "starhalf")
            star5.image=UIImage(named: "starempty")
            
            
            
            
        }else if stars == "4" {
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "star")
            star4.image=UIImage(named: "star")
            star5.image=UIImage(named: "starempty")
            
            
            
        }else if stars == "4.5" {
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "star")
            star4.image=UIImage(named: "star")
            star5.image=UIImage(named: "starhalf")
            
            
            
        }else if stars == "5" {
            
            star1.image=UIImage(named: "star")
            star2.image=UIImage(named: "star")
            star3.image=UIImage(named: "star")
            star4.image=UIImage(named: "star")
            star5.image=UIImage(named: "star")
            
            
        }
        
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAllReview" {
            
            
            let destinationVC = segue.destination as! AllReviewsViewController
            
            destinationVC.user_id=currentUserId
            
            
            
            
        }else if segue.identifier == "seeMore" {
            
            
            let destinationVC = segue.destination as! SeeMoreController
            
            destinationVC.mode = mode
            
            destinationVC.currentUserId = currentUserId
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath as IndexPath) as! PostsCollectionCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.postName.text = ""
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // The first cell always start expanded with an height of 300
        // The others start with an height of 80
        
        return CGSize(width: collectionView.frame.size.width/5, height: collectionView.frame.size.height)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func openSettingsFromUser(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        //        self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated: true, completion: nil)
    }

    
    @IBAction func seeMoreRentals(_ sender: Any) {
        
        mode="1"
        performSegue(withIdentifier: "seeMore", sender: self)
        
    }
    @IBAction func seeMoreActive(_ sender: Any) {
        
        mode="2"
        performSegue(withIdentifier: "seeMore", sender: self)
    }
    @IBAction func seeMorePrev(_ sender: Any) {
        
        mode="3"
        performSegue(withIdentifier: "seeMore", sender: self)
    }
    
}
