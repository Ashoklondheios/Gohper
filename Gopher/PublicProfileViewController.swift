//
//  PublicProfileViewController.swift
//  Gopher
//
//  Created by User on 3/9/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation


class PublicProfileViewController: BaseViewController {

    // MARK: IBOutlet Properties
    @IBOutlet weak var seeMoreActiveBtn: UIButton!

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var worldRankText: UILabel!
    @IBOutlet weak var totalEarningText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var country: UILabel!
    //@IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var ratingsText: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var reviewText: UILabel!
    @IBOutlet weak var lastReviewLabel: UILabel!
    //@IBOutlet weak var categories: UITextView!
    //@IBOutlet weak var skillsText: UITextView!
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var lasrReviewText: UILabel!
    @IBOutlet weak var lasrReviewDate: UILabel!
    @IBOutlet weak var lasrReviewStar1: UIImageView!
    @IBOutlet weak var lasrReviewStar2: UIImageView!
    @IBOutlet weak var lasrReviewStar3: UIImageView!
    @IBOutlet weak var lasrReviewStar4: UIImageView!
    @IBOutlet weak var lasrReviewStar5: UIImageView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var postImage1: UIImageView!
    @IBOutlet weak var postLabel1: UILabel!
    @IBOutlet weak var postImage2: UIImageView!
    @IBOutlet weak var postLabel2: UILabel!
    
    @IBOutlet weak var postLabel4: UILabel!
    @IBOutlet weak var postImage4: UIImageView!
    @IBOutlet weak var postLabel3: UILabel!
    @IBOutlet weak var postImage3: UIImageView!
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
    
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    

    @IBAction func seeMore(_ sender: Any) {
        
        performSegue(withIdentifier: "seeMore", sender: self)
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
                let user = firstObject["User"] as! NSDictionary
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
                
                let UserLocation = firstObject["UserLocation"] as! NSDictionary
                currentUserId = userInfo[keyUserId] as! String
                //let email = user[keyEmail] as! String
                if let first_name = userInfo[keyFirstName] as? String, let last_name = userInfo[keyLastName] as? String {
                    name.text = "\(first_name) \(last_name)"
                }
                
                let latitudeString=UserLocation["lat"] as? String ?? ""
                let longitudeString=UserLocation["long"] as? String ?? ""
                
                if let activeArray=firstObject["ActiveGigPost"] as! NSArray?{
                    
                    ActivePosts.removeAll()
                    for i in 0..<activeArray.count{
                        
                        let dictObject=activeArray[i] as! NSDictionary
                        
                        var itemDict=[String:Any]()
                        
                        itemDict["image"]=String (Constants.PROFILEBASEURL) + String (dictObject["image"] as! String)
                        itemDict["title"]=dictObject["title"]
                        itemDict["gig_post_id"]=dictObject["gig_post_id"]
                        
                        ActivePosts.append(itemDict)
                        
                    }
                    
                    self.loadActives()
                    //self.loadRental()
                    
                }
                
                
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
            
                self.Bio.text = about
            
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
            lasrReviewStar3.image=UIImage(named: "starempty")
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
        
        
        
        
        lasrReviewText.text="\"\(last_rating_comment)\""
        lasrReviewDate.text=last_rating_date
        
        if last_rating_star == "-1" {
        
            lasrReviewText.isHidden=true
            lasrReviewDate.isHidden=true
            
            lasrReviewStar1.isHidden=true
            lasrReviewStar2.isHidden=true
            lasrReviewStar3.isHidden=true
            lasrReviewStar4.isHidden=true
            lasrReviewStar5.isHidden=true
            
            lastReviewLabel.isHidden=true
        
        
        }else if last_rating_star == "0" {
            
            
            
            lasrReviewStar1.image=UIImage(named: "starempty")
            lasrReviewStar2.image=UIImage(named: "starempty")
            lasrReviewStar3.image=UIImage(named: "starempty")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
        }else if last_rating_star == "0.5" {
            
            
            
            lasrReviewStar1.image=UIImage(named: "starhalf")
            lasrReviewStar2.image=UIImage(named: "starempty")
            lasrReviewStar3.image=UIImage(named: "starempty")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
        }else if last_rating_star == "1" {
            
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "starempty")
            lasrReviewStar3.image=UIImage(named: "starempty")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
            
            
        }else if last_rating_star == "1.5" {
            
            
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "starhalf")
            lasrReviewStar3.image=UIImage(named: "starempty")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
        }else if last_rating_star == "2" {
            
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "starempty")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
            
            
            
        }else if last_rating_star == "2.5" {
            
            
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "starhalf")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
        }else if last_rating_star == "3" {
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "star")
            lasrReviewStar4.image=UIImage(named: "starempty")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
            
            
        }else if last_rating_star == "3.5" {
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "star")
            lasrReviewStar4.image=UIImage(named: "starhalf")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
            
            
        }else if last_rating_star == "4" {
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "star")
            lasrReviewStar4.image=UIImage(named: "star")
            lasrReviewStar5.image=UIImage(named: "starempty")
            
            
            
        }else if last_rating_star == "4.5" {
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "star")
            lasrReviewStar4.image=UIImage(named: "star")
            lasrReviewStar5.image=UIImage(named: "starhalf")
            
            
            
        }else if last_rating_star == "5" {
            
            lasrReviewStar1.image=UIImage(named: "star")
            lasrReviewStar2.image=UIImage(named: "star")
            lasrReviewStar3.image=UIImage(named: "star")
            lasrReviewStar4.image=UIImage(named: "star")
            lasrReviewStar5.image=UIImage(named: "star")
            
            
        }
    
    }
    
    func loadActives(){
        
        seeMoreActiveBtn.isHidden=false
        
        for i in 0..<ActivePosts.count{
            
            let item=ActivePosts[i] as [String:Any]
            
            let postImage = item["image"] as! String
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAllReview" {
            
            
            

            
            let destinationVC = segue.destination as! AllReviewsViewController
            
            destinationVC.user_id=currentUserId
          
            
            
            
        }else if segue.identifier == "seeMore" {
            
            
            let destinationVC = segue.destination as! SeeMoreController
            
            destinationVC.mode = "2"
            
            destinationVC.currentUserId = currentUserId
            
            
        }

    }
    
    @IBAction func seeMoreActive(_ sender: Any) {
        
        //mode="2"
        performSegue(withIdentifier: "seeMore", sender: self)
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
