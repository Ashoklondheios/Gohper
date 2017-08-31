//
//  SettingsViewController.swift
//  Gopher
//
//  Created by User on 2/18/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SDWebImage
import SystemConfiguration
import AFNetworking
class SettingsViewController: BaseViewController {

    //MARK:- IBOutlet Properties
    @IBOutlet weak var totalEarningLabel: UILabel!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var worlRankLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    
    //MARK:- Variables

    var userModel = UserModel.Instance()
    var imagePicker = UIImagePickerController()
    var base64StringOf_my_image = String()
    var prepCompressedImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideProgressLoader()

        //scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.hideKeyBoardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.setValuesToFields()
        profilePicImg.layer.borderWidth=1.0
        profilePicImg.layer.masksToBounds = false
        profilePicImg.layer.borderColor = UIColor.white.cgColor
        profilePicImg.layer.cornerRadius = 13
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.height/2
        profilePicImg.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePicImg.isUserInteractionEnabled = true
        profilePicImg.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Image Tap Method
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true,completion: nil)
        // Your action
    }
    
    //MARK:- IBActions Methods
    @IBAction func editProfilePic(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true,completion: nil)
    }

    @IBAction func backLargeBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func menuBTN(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func updateProfile(_ sender: Any) {
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
    
    //MARK:- Keyboard Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification){
        
//        var userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//        
//        var contentInset:UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        self.scrollView.contentInset = contentInset
    }
    
    func hideKeyBoardOnTap()
    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(self.dismissKeyboard))
//        
//        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        //view.endEditing(true)
    }
    
    //MARK:- Set Fields Values
    func setValuesToFields()
    {
        userModel = UserModel.getUserData()
        //let url = NSURL(string: userModel.profile_img)
//        profilePicImg.setImageWith(url as! URL)
        profilePicImg.sd_setImage(with: URL(string: userModel.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
       // profilePicImg.setImageWith.sd_setImage(with: URL(string: userModel.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        firstNameTextField.text = userModel.first_name
        lastNameTextField.text = userModel.last_name
        
        let city = UserDefaults.standard.object(forKey: "city") as? String ?? ""
        let country = UserDefaults.standard.object(forKey: "country") as? String ?? ""
        
        
        if city != "" {
            
            countryLabel.text="\(city), \(country)"
            
        }else{
            
            countryLabel.text=""
            
        }
        
        emailTextField.text = userModel.email
        phoneNoTextField.text = userModel.phone_no
        aboutTextField.text = userModel.about
    }
    
    // MARK: Validation Methods
    fileprivate func validateFields() -> (Bool, String?) {
        
        if (firstNameTextField.text?.isEqual(""))! {
            return (false, "Please enter your name")
        }
        
        if (lastNameTextField.text?.isEqual(""))! {
            return (false, "Please enter your last name")
        }
        
        if (phoneNoTextField.text?.isEqual(""))! {
            return (false, "Please enter telephone #")
        }
        
        if (emailTextField.text?.isEqual(""))! || !isValidEmail(emailTextField.text) {
            
            return (false , "enter a valid email")
            
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
    
    
    //MARK:- Make Api Call
    func MakeAPICall()
    {
        showProgressLoader()
        var imgURL = NSDictionary()
        if(!base64StringOf_my_image.isEmpty)
        {
            imgURL = ["content_type": "image/png", "filename":"test.png", "file_data": base64StringOf_my_image]
        }
        
        
        let params = ["user_id":userModel.userId,"email":emailTextField.text!,"first_name": firstNameTextField.text!, "last_name":lastNameTextField.text!,"phone_no":phoneNoTextField.text!,"profile_img":imgURL, "about":aboutTextField.text] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.EDITPROFILEAPIURL, parameters: params, success:
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
            UserDefaults.standard.set(response, forKey: Constants.USERRESPONSEKEY)
            UserModel.initialize()
            UserModel.instance.parseSignUpResponse(response)
            self.setValuesToFields()
            print(UserModel.instance.email)
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

extension SettingsViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicImg.image = pickedImage
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
