//
//  RentPreviewController.swift
//  Gopher
//
//  Created by User on 7/10/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking

class RentPreviewController: BaseViewController {

    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var depositLabel: UILabel!
    
    @IBOutlet weak var serviceFeeLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    var selectedGig=LatLongDetail()
    
    var params=[String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPreview()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPreview(){
    
        mainLabel.text=selectedGig.gigTitle
        mainImage.sd_setImage(with: URL(string: selectedGig.gigImage))
        
        if selectedGig.type_of_payment == "1" {
            
            rateLabel.text="Rate: $\(selectedGig.pay)/day"
            
        }else{
        
            rateLabel.text="Rate: $\(selectedGig.pay)/hr"
            
        }
        
        let datesArray=params["calender"] as! NSMutableArray
        
        if selectedGig.type_of_payment == "1" {
            
            
            durationLabel.text="Duration: \(datesArray.count) day/s"
            
        }else{
            
            durationLabel.text="Duration: \(datesArray.count) hour/s"
            
        }
        
        let totalDeposit=datesArray.count*Int(selectedGig.pay)! as Int
        
        depositLabel.text="Deposit: $\(totalDeposit)"
        
        let serviceCharges=10
        
        serviceFeeLabel.text="Service Fee: $\(serviceCharges)"
        
        totalLabel.text="Total: $\(totalDeposit+serviceCharges)"
        
        
        
    }
    
    @IBAction func contactTapped(_ sender: Any) {
        
        
        
    }
    @IBAction func rentTapped(_ sender: Any) {
        
        if(connectedToNetwork())
        {
            MakeAPICall()
        }
        else
        {
            self.showAlert("Please check your connection","Oops", VC: self)
        }
    }
    
    func MakeAPICall()
    {
        
        
        params["total"]=totalLabel.text
        params["service_fee"]=serviceFeeLabel.text
        
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.RentAPIURL, parameters: params, success:
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

    func showAlert(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
        
    }
    
    func closeVC(action: UIAlertAction) {
        //_=navigationController?.popViewController(animated: true)
        
        //dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "goToRoot", sender: self)
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
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        //        print(datesArray)
        //        datesDelegate?.sendSelectedDatesArrayToPreviousVC(dates: self.datesArray)
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }


}
