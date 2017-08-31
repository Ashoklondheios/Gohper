//
//  ReviewsViewController.swift
//  Gopher
//
//  Created by User on 4/10/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking

class ReviewsViewController: UIViewController {

    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!

    @IBOutlet weak var reviewsTextField: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    var ratingValue = ""
    var sellerid = ""
    var order_gigpost_id = ""
    var star1ImageName = "starempty"
    var star2ImageName = "starempty"
    var star3ImageName = "starempty"
    var star4ImageName = "starempty"
    var star5ImageName = "starempty"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func star1Btn(_ sender: Any) {
        ratingValue = "1"
       if(star1ImageName.isEqual("starempty"))
        {
            let image = UIImage(named: "star") as UIImage?
            let image1 = UIImage(named: "starempty") as UIImage?

            star1.setImage(image, for: .normal)
            star2.setImage(image1, for: .normal)
            star3.setImage(image1, for: .normal)
            star4.setImage(image1, for: .normal)
            star5.setImage(image1, for: .normal)

            star1ImageName = "star"
        }
        else
        {
            ratingValue = "0"

            let image = UIImage(named: "starempty") as UIImage?
            star1ImageName = "starempty"
            
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image, for: .normal)
            star5.setImage(image, for: .normal)
        }
       
        //starempty
    }
    @IBAction func commentBtn(_ sender: Any) {
        postReviewCall()
    }

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)

    }
    @IBAction func star2Btn(_ sender: Any) {
        ratingValue = "2"
        if(star2ImageName.isEqual("starempty"))
        {
            let image = UIImage(named: "star") as UIImage?
            star2ImageName = "star"
            let image1 = UIImage(named: "starempty") as UIImage?
            
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image1, for: .normal)
            star4.setImage(image1, for: .normal)
            star5.setImage(image1, for: .normal)
        }
        else
        {
            let image = UIImage(named: "starempty") as UIImage?
            star2ImageName = "starempty"
            let image1 = UIImage(named: "star") as UIImage?
            
            star1.setImage(image1, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image, for: .normal)
            star5.setImage(image, for: .normal)
        }
    }
    @IBAction func star3Btn(_ sender: Any) {
    ratingValue = "3"
        if(star3ImageName.isEqual("starempty"))
        {
            let image = UIImage(named: "star") as UIImage?
            star3ImageName = "star"
            let image1 = UIImage(named: "starempty") as UIImage?
            
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image1, for: .normal)
            star5.setImage(image1, for: .normal)
        }
        else
        {
            let image = UIImage(named: "starempty") as UIImage?
            star3ImageName = "starempty"
            let image1 = UIImage(named: "star") as UIImage?
            
            star1.setImage(image1, for: .normal)
            star2.setImage(image1, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image, for: .normal)
            star5.setImage(image, for: .normal)
        }
    }
    @IBAction func star4Btn(_ sender: Any) {
    ratingValue = "4"
        if(star4ImageName.isEqual("starempty"))
        {
            let image = UIImage(named: "star") as UIImage?
            star4ImageName = "star"
            let image1 = UIImage(named: "starempty") as UIImage?
            
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image, for: .normal)
            star5.setImage(image1, for: .normal)
        }
        else
        {
            let image = UIImage(named: "starempty") as UIImage?
            star4ImageName = "starempty"
            let image1 = UIImage(named: "star") as UIImage?
            
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image1, for: .normal)
            star5.setImage(image1, for: .normal)
        }
    }
    @IBAction func star5Btn(_ sender: Any) {
    ratingValue = "5"
        if(star5ImageName.isEqual("starempty"))
        {
            let image = UIImage(named: "star") as UIImage?
            star5ImageName = "star"
            //let image1 = UIImage(named: "starempty") as UIImage?
            
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image, for: .normal)
            star5.setImage(image, for: .normal)
        }
        else
        {
            let image = UIImage(named: "starempty") as UIImage?
            star5ImageName = "starempty"
            star1.setImage(image, for: .normal)
            star2.setImage(image, for: .normal)
            star3.setImage(image, for: .normal)
            star4.setImage(image, for: .normal)
            star5.setImage(image, for: .normal)
        }
    }
    
    //MARK:- Get Conversation Api Call
    func postReviewCall()
    {
        //self.showProgressLoader()
//        "buyer_id":"40",
//        "seller_id":"41",
//        "comment":"hello i am irfan",
//        "order_gig_post_id":"1",
//        "stars":"5",
//        "datetime":""
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postDate =  dateFormatter.string(from: date as Date)
        
        let params = ["buyer_id":UserModel.getUserData().userId, "seller_id":sellerid, "comment":reviewsTextField.text!, "order_gig_post_id":order_gigpost_id, "stars":ratingValue, "datetime":postDate] as [String : Any]
        print(params)
        // self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getUserPaymentDetailsAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.checkCardTaskResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                //   self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func checkCardTaskResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        //  self.hideProgressLoader()
        print(code)
        // self.hideProgressLoader()
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
          
                // {"code":200,"msg":[{"CardDetails":{"brand":"Visa","last4":"4242"}}]}
            }
            //showAlert(msgArray, VC: self)
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


