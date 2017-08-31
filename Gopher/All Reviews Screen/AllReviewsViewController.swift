//
//  AllReviewsViewController.swift
//  ReviewScreen
//
//  Created by Aman on 15/04/17.
//  Copyright © 2017 Aman. All rights reserved.
//

import UIKit
import AFNetworking

class AllReviewsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var personTableView: UITableView!
    
    var user_id="0"
    var personNameArray = [String]()
    var personImageArray = [String]()
    var personPriceArray = [String]()
    var listOfReviews=[reviewDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        personTableView.register(nib, forCellReuseIdentifier: "ReviewCell")
        
        personNameArray = ["Abhishek Bachan" , "Katrina Kaif" , "Ranbir Kapoor" , "Neil Nitin Mukesh" , "Isha Gupta" , "Deepika  Padukone","Abhishek Bachan" , "Katrina Kaif" , "Ranbir Kapoor" , "Neil Nitin Mukesh" , "Isha Gupta" , "Deepika  Padukone"];
        
        
        personImageArray = ["abhishek" , "kat" , "ranbir" , "neil" , "esha" , "depeeka", "abhishek" , "kat" , "ranbir" , "neil" , "esha" , "depeeka"];
        
        personPriceArray = ["$80" , "$90" , "$100" ,"$110" , "$75" , "$85", "$80" , "$90" , "$100" ,"$110" , "$75" , "$85"];
        
        self.MakeAPICall()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewTableViewCell
        
        let revItem=listOfReviews[indexPath.row]
        
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.personName.text =  revItem.reviewerName
        cell.personImageView.sd_setImage(with: URL(string: revItem.reviewerImageUrl))
        cell.personPrice.setTitle("$\(revItem.total)", for: .normal)
        cell.personDescLabel.text = revItem.comment
        cell.dateLabel.text=Commons.reviewDateFormat(dateFrom: revItem.dateString)
        
        let ratings=Int(revItem.rating)
        
        if ratings == 0 {
        
            cell.star1.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star2.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star3.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star4.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star5.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            
            
        }else if ratings == 1 {
            
            cell.star1.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star2.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star3.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star4.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star5.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            
            
        }else if ratings == 2 {
            
            cell.star1.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star2.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star3.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star4.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star5.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            
            
        }else if ratings == 3 {
            
            cell.star1.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star2.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star3.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star4.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            cell.star5.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            
            
            
        }else if ratings == 4 {
            
            cell.star1.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star2.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star3.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star4.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star5.setImage(UIImage(named: "starempty"), for: UIControlState.normal)
            
            
        }else if ratings == 5 {
            
            cell.star1.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star2.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star3.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star4.setImage(UIImage(named: "star"), for: UIControlState.normal)
            cell.star5.setImage(UIImage(named: "star"), for: UIControlState.normal)
            
                        
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
  
    @IBAction func backButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func MakeAPICall()
    {
        var params=[String:Any]()
        params["user_id"]=user_id
        
        showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.ALLUSERRATING, parameters: params, success:
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
            self.showAlert("No reviews found"  ,"Oops", VC: self)
        }
        if code == 401 {
            
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 400 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        
        if(code == 200)
        {
            
            //print(dict ?? "")
            
            let msgArray = dict?["msg"] as! NSArray
            listOfReviews.removeAll()
            
            for i in 0..<msgArray.count {
            
                let reviewItem=reviewDetail()
                
                let currentItem=msgArray[i] as! NSDictionary
                
                let OrderGigPost=currentItem["OrderGigPost"] as! NSDictionary
                
                if OrderGigPost["total"] != nil{
                
                    reviewItem.total=OrderGigPost["total"] as! String
                }
                
                let rating=currentItem["Rating"] as! NSDictionary
                
                reviewItem.rating=rating["stars"] as! String
                
                reviewItem.dateString=rating["datetime"] as! String 
                
                
                
                reviewItem.comment=rating["comment"] as! String
                
                let buyerInfo=currentItem["buyer_info"] as! NSDictionary
                
                reviewItem.reviewerName="\(buyerInfo["first_name"] ?? "") \(buyerInfo["last_name"] ?? "")"
                
                if (buyerInfo["profile_img"] as! String).range(of:"http") != nil{
                    reviewItem.reviewerImageUrl = String (buyerInfo["profile_img"] as! String)
                }else{
                    reviewItem.reviewerImageUrl = String (Constants.PROFILEBASEURL) + String (buyerInfo["profile_img"] as! String)
                }
                
                
                listOfReviews.append(reviewItem)
            
            }
            
            personTableView.reloadData()
            
            
        }
    }
    

    
    func showAlert(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
    }
    
    func closeVC(action: UIAlertAction) {
        _=navigationController?.popViewController(animated: true)
        
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
    
    func showAlertPostedGig(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: closeVC))
        VC.present(alertView, animated: true, completion: nil)
        
    }
    
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
    


}
