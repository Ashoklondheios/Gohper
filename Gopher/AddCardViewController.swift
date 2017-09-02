//
//  AddCardViewController.swift
//  Gopher
//
//  Created by User on 4/6/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking

class AddCardViewController: UIViewController {

    @IBOutlet weak var cardNotAddedView: UIView!
    @IBOutlet weak var cardAddedView: UIView!
    @IBOutlet weak var enclosureImg: UIImageView!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardNumbers: UILabel!
    var cardID = ""
    var cardBrand = ""
    var cardHolderName = ""
    var cvcNumber = ""
    var isCardExist = ""
    var datePickerView = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNotAddedView.isHidden = true
        cardAddedView.isHidden = true
        CheckCardAPICall()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func backButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
//        navigationController?.popViewController(animated: true)
//        
        //dismiss(animated: true, completion: nil)
    }
    @IBAction func cardDetailsBtn(_ sender: Any) {
        
    }
    @IBAction func AddCardDetailBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addCardDetailVc") as! AddCardDetailViewController
        
        self.present(nextViewController, animated: true, completion: nil)
        //self.navigationController?.pushViewController(nextViewController, animated:true)

    }
    //MARK:- Get Conversation Api Call
    func CheckCardAPICall()
    {
        //self.showProgressLoader()
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
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
            cardNotAddedView.isHidden = false
            cardAddedView.isHidden = true
            //Commons.showAlert(dict?["msg"] as! String, VC: self)
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
                cardNotAddedView.isHidden = false
                cardAddedView.isHidden = true
            }
            else
            {
                cardNotAddedView.isHidden = true
                cardAddedView.isHidden = false
                let firstObject = msgArray[0] as! NSDictionary
                let cardDetail = firstObject["CardDetails"] as! NSDictionary
                let brand = cardDetail["brand"] as! String
                let last4 = cardDetail["last4"] as! String
                let name = cardDetail["name"] as! String
                cardName.text = name
                cardNumbers.text = last4
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

}
