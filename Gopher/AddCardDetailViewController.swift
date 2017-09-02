//
//  AddCardDetailViewController.swift
//  Gopher
//
//  Created by User on 4/6/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking
class AddCardDetailViewController: BaseViewController {
    var expiryDatePickerView = UIDatePicker()
    @IBOutlet weak var expiryDateEdittext: UITextField!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var nameEditText: UITextField!
    @IBOutlet weak var cardNumberEdittext: UITextField!
    @IBOutlet weak var securityCodeEdittext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideProgressLoader()
        
        parentScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.hideKeyBoardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Keyboard Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.parentScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.parentScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.parentScrollView.contentInset = contentInset
    }
    
    func hideKeyBoardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    // MARK: Validation Methods
    fileprivate func validateFields() -> (Bool, String?) {
        
        if (nameEditText.text?.isEqual(""))! {
            return (false, "Please enter your name")
        }
        
        if (cardNumberEdittext.text?.isEqual(""))! {
            return (false, "Please enter 16 digit card number")
        }
        
        if (expiryDateEdittext.text?.isEqual(""))! {
            return (false, "Please enter expiry date")
        }
        
        if (securityCodeEdittext.text?.isEqual(""))! {
            
            return (false , "enter a valid security code")
            
        }
        
        return (true,nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let (isValid, error) = validateFields()
        
        if !isValid {
            Commons.showAlert(error!, VC: self)
            return
        }
        
        if(Commons.connectedToNetwork())
        {
            
            MakeAPICall()
            
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        
        //_=navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
     func capitalizingFirstLetter(_ text:String?) -> String {
        let first = String(describing: text?.characters.prefix(1)).uppercased()
        let other = String(describing: text?.characters.dropFirst())
        return first + other
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didBeganEditingTextFiled(_ sender: Any) {
        var doneButton:UIBarButtonItem?
        expiryDateEdittext.inputView = expiryDatePickerView
        expiryDatePickerView.datePickerMode = UIDatePickerMode.date
        
        // Sets up the "button"
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        toolBar.sizeToFit()
        
        // Adds the buttons
        //doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewPostViewController.doneClick(_:)))
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewPostViewController.doneClick(sender:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewPostViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton!], animated: false)
        toolBar.isUserInteractionEnabled = true
        // Adds the toolbar to the view
        expiryDateEdittext.inputAccessoryView = toolBar
        
    }
    @IBAction func didBeganEditingTFiels(_ sender: Any) {
        var doneButton:UIBarButtonItem?
        expiryDateEdittext.inputView = expiryDatePickerView
        expiryDatePickerView.datePickerMode = UIDatePickerMode.date
        
        // Sets up the "button"
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        toolBar.sizeToFit()
        
        // Adds the buttons
        //doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewPostViewController.doneClick(_:)))
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewPostViewController.doneClick(sender:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewPostViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton!], animated: false)
        toolBar.isUserInteractionEnabled = true
        // Adds the toolbar to the view
        expiryDateEdittext.inputAccessoryView = toolBar
    }
    
    
    func doneClick(sender:UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let dateTime =  dateFormatter.string(from: expiryDatePickerView.date as Date)
        expiryDateEdittext.text = dateTime
        expiryDateEdittext.resignFirstResponder()
    }
    
    
    
    func cancelClick() {
        expiryDateEdittext.resignFirstResponder()
    }

    
    //MARK:- Make Api Call
    func MakeAPICall()
    {
        self.showProgressLoader()
        let fulldate : String = expiryDateEdittext.text!
        let fulldateArr : [String] = fulldate.components(separatedBy: "-")
        
        // And then to access the individual words:
        
        let year : String = fulldateArr[0]
        var month : String = fulldateArr[1]
        let params = ["user_id": UserModel.getUserData().userId,"name": nameEditText.text!,"card": cardNumberEdittext.text!, "exp_year": year ,"exp_month": month, "cvc": securityCodeEdittext.text!] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.addUserStripeAPIURL, parameters: params, success:
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
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
            self.present(nextViewController, animated:false, completion:nil)

           // self.navigationController?.pushViewController(nextViewController, animated:true)
        }
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
}
