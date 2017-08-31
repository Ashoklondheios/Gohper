//
//  SignupViewController.swift
//  Gopher
//
//  Created by User on 2/8/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Foundation
import AFNetworking

class SignupViewController : BaseViewController , TTTAttributedLabelDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Outlet Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addProfileImgOutlet: UIButton!
    @IBOutlet weak var firstNameTextFieldOutlet: UITextField!
    @IBOutlet weak var phoneTextFieldOutlet: UITextField!
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var imagePicker = UIImagePickerController()
    var base64StringOf_my_image = String()
    var prepCompressedImage: UIImage!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyBoardOnTap()
        self.hideProgressLoader()

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.hideKeyBoardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        let firstNameTextFieldPH = NSAttributedString(string: "First Name" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        firstNameTextFieldOutlet.attributedPlaceholder = firstNameTextFieldPH
        
        let lastNameTextFieldPH = NSAttributedString(string: "Last Name" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        lastNameTextField.attributedPlaceholder = lastNameTextFieldPH
        
        let phoneTextFieldPH = NSAttributedString(string: "Phone Number" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        phoneTextFieldOutlet.attributedPlaceholder = phoneTextFieldPH
        
        let emailTextFieldPH = NSAttributedString(string: "Email" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        emailTextFieldOutlet.attributedPlaceholder = emailTextFieldPH
        
        let passwordTextFieldPH = NSAttributedString(string: "Password" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        passwordTextFieldOutlet.attributedPlaceholder = passwordTextFieldPH
        addProfileImgOutlet.layer.masksToBounds = false
        addProfileImgOutlet.layer.borderColor = UIColor.white.cgColor
        addProfileImgOutlet.layer.cornerRadius = 13
        addProfileImgOutlet.layer.cornerRadius = addProfileImgOutlet.frame.size.height/2
        addProfileImgOutlet.clipsToBounds = true
        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Actions
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backLargeBTN(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageBtn(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true,completion: nil)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        //rootController  tbbarVC
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
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tbbarVC") as! UITabBarController
//        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // MARK: Close Keyboard
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
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
        
        if (firstNameTextFieldOutlet.text?.isEqual(""))! {
            return (false, "Please enter your name")
        }
        
        if (lastNameTextField.text?.isEqual(""))! {
            return (false, "Please enter your last name")
        }
        
        if (phoneTextFieldOutlet.text?.isEqual(""))! {
            return (false, "Please enter telephone #")
        }
        
        if (emailTextFieldOutlet.text?.isEqual(""))! || !isValidEmail(emailTextFieldOutlet.text) {
            
            return (false , "enter a valid email")
            
        }
        
        if (passwordTextFieldOutlet.text?.isEqual(""))! {
            return (false,"Please enter password")
        }
        
        if base64StringOf_my_image == ""{
            return (false,"Please enter image")
        }
        
        return (true,nil)
    }

    
    func isValidEmail(_ text:String?) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            let range = NSMakeRange(0, (text?.characters.count)!)
            return regex.firstMatch(in: text!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:range) != nil
        } catch{return false}
    }
    
        func isEmail(_ text:String?) -> Bool
        {
            let EMAIL_REGEX = "^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
            return predicate.evaluate(with: text)
        }
        
        func capitalizingFirstLetter(_ text:String?) -> String {
            let first = String(describing: text?.characters.prefix(1)).uppercased()
            let other = String(describing: text?.characters.dropFirst())
            return first + other
        }
    
    // MARK: Call Api
    
    func MakeAPICall()
    {
        
        
        let params:[String : Any]
        
        if base64StringOf_my_image == "" {
            
            params = ["email":emailTextFieldOutlet.text!,"password":passwordTextFieldOutlet.text!, "first_name": firstNameTextFieldOutlet.text!, "last_name":lastNameTextField.text!,"phone_no":phoneTextFieldOutlet.text!,"device_token":"asdsadas"] as [String : Any]
            
        }else{
        
            params = ["email":emailTextFieldOutlet.text!,"password":passwordTextFieldOutlet.text!, "first_name": firstNameTextFieldOutlet.text!, "last_name":lastNameTextField.text!,"phone_no":phoneTextFieldOutlet.text!,"profile_img":["content_type": "image/png", "filename":"test.png", "file_data": base64StringOf_my_image],"device_token":"asdsadas"] as [String : Any]
        }
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.SIGNUPAPIURL, parameters: params, success:
            {
                requestOperation, response in
                self.showProgressLoader()
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
            UserDefaults.standard.set(response, forKey: Constants.USERRESPONSEKEY)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserModel.initialize()
            UserModel.instance.parseSignUpResponse(response)
            
            print(UserModel.instance.email)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
            self.present(nextViewController, animated:false, completion:nil)
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

// MARK: Pick Image from Gallery

extension SignupViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            addProfileImgOutlet.setBackgroundImage(pickedImage, for: .normal)
           // self.prepCompressedImage = UIImage.compress(pickedImage, compressRatio: 0.8)
            base64StringOf_my_image = base64StringOfImage(pickedImage)
//            
//            if appUtility.connectedToNetwork() {
//                let params = ["user_id":user!.userId,"picbase64":["file_data": base64StringOf_my_image]] as [String : Any]
//                appUtility.loadingView(self, wantToShow: true)
//                userLoader.tryProfilePic(params as [String : AnyObject]?, successBlock: { (user) in
//                    appUtility.loadingView(self, wantToShow: false)
//                }, failureBlock: { (error) in
//                    appUtility.loadingView(self, wantToShow: false)
//                    appUtility.showAlert((error?.localizedDescription)!, VC: self)
//                })
//            }else {
//                appUtility.loadingView(self, wantToShow: false)
//                appUtility.showNoNetworkAlert()
//            }
            
        }else{}
        imagePicker.delegate = nil
        self.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func base64StringOfImage(_ image:UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let base64String = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
}

