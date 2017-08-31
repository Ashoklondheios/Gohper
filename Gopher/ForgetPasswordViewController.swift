//
//  ForgetPasswordViewController.swift
//  Gopher
//
//  Created by User on 4/10/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import AFNetworking
class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPAsswordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
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
        
        let (isValid, error) = validateFields()
        
        if !isValid {
            Commons.showAlert(error!, VC: self)
            return
        }
        if(Commons.connectedToNetwork())
        {
           // self.showProgressLoader()
            
            MakeAPICall()
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
    }
    
    
    // MARK: Validation Methods
    fileprivate func validateFields() -> (Bool, String?) {
        
        
        if (oldPasswordTextField.text?.isEqual(""))!  {
            
            return (false , "Please enter current password")
            
        }
        
        if (newPAsswordTextField.text?.isEqual(""))! {
            return (false,"Please enter new password")
        }
        
        if (confrimPasswordTextField.text?.isEqual(""))! {
            return (false,"Please confirm password")
        }
        
        if (newPAsswordTextField.text?.isEqual(confrimPasswordTextField.text))! {
            return (false,"Passwords doesn't match")
        }
        
        return (true,nil)
    }
    // MARK: Call Api
    func MakeAPICall()
    {
        let params = ["user_id":UserModel.getUserData().userId,"current_password":oldPasswordTextField.text!,"current_password":oldPasswordTextField.text!] as [String : Any]
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.RESETAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                //self.showProgressLoader()
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseSignUpResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                //self.hideProgressLoader()
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
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
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
