//
//  AddTipViewController.swift
//  Gopher
//
//  Created by User on 4/7/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking
class AddTipViewController: UIViewController {

    @IBOutlet weak var addTipTextField: UITextField!
    var order_gig_post = ""
    var sellerid = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func confirmBtn(_ sender: Any) {
        displayConfirmationAlert()
    }
    @IBAction func skipTipBtn(_ sender: Any) {
        displayConfirmationAlert()
    }
    
    // Code Written by Ashok.. display confirmation Alert
    
    func displayConfirmationAlert() {
        let alert = UIAlertController(title: "", message: "If you press confirm the order will consider done and the payment will be transfered to david account", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            self.MakeAPICall()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Make Api Call
    func MakeAPICall()
    {
       // self.showProgressLoader()
        let params = ["user_id": UserModel.getUserData().userId,"order_gig_post_id": order_gig_post,"tip": addTipTextField.text!] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.CompleteAndPayAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseSignUpResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
              //  self.hideProgressLoader()
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseSignUpResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        
       // self.hideProgressLoader()
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
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "reviewVC") as! ReviewsViewController
            nextViewController.sellerid = sellerid
            nextViewController.order_gigpost_id = self.order_gig_post
            self.navigationController?.pushViewController(nextViewController, animated:true)
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
