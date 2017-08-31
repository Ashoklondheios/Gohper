//
//  LogInViewController.swift
//  Gopher
//
//  Created by User on 2/8/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Foundation
import AFNetworking
import FBSDKLoginKit
import FacebookLogin

import GoogleSignIn


class LogInViewController: BaseViewController, TTTAttributedLabelDelegate, UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
    
    // MARK: Outlet Properties
    
    
    
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPassword: TTTAttributedLabel!
    @IBOutlet weak var createAccout: TTTAttributedLabel!
    var dict=[String : AnyObject]()
    
    var Fbtoken=""
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked) forControlEvents: .TouchUpInside)
        
        facebookBtn.addTarget(self, action:#selector(self.loginButtonClicked), for: .touchUpInside)
        
        //self.checkIfUserIsAuthorized()

        self.hideProgressLoader()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let emailPH = NSAttributedString(string: "Email" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        emailTextField.attributedPlaceholder = emailPH
        
        let passwordPH = NSAttributedString(string: "Password" , attributes: [NSForegroundColorAttributeName:UIColor.white])
        passwordTextField.attributedPlaceholder = passwordPH
        

        self.hideKeyBoardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(createAccountClick(_:)))
        createAccout.addGestureRecognizer(tap)
        createAccout.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //forgetpassVC
    // MARK: Create Account
    func createAccountClick(_ sender: UITapGestureRecognizer) {
        
        // Do something here for when the user taps on the label
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "signUpView") as! SignupViewController
        //self.navigationController?.pushViewController(nextViewController, animated:true)       
        
        self.present(nextViewController, animated:true, completion:nil)

        
    }

    @IBAction func forgetPasswordBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "forgetpassVC") as! ForgetPasswordViewController
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func createAccountLarge(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "signUpView") as! SignupViewController
       //self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated:true, completion:nil)
    }
    // MARK: Button Actions
   
    @IBAction func backSmallBtn(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender: Any) {
        _=navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func logInWithGooglePlusBtn(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    @IBAction func logInWithFBBtn(_ sender: Any) {
        
        
    }
    @IBAction func logInBtn(_ sender: Any) {
        
        let (isValid, error) = validateFields()
        
        if !isValid {
            Commons.showAlert(error!, VC: self)
            return
        }
        
        if(Commons.connectedToNetwork())
        {
            self.showProgressLoader()
            MakeAPICall()
        }
        else
        {
            Commons.showAlert("Please check your connection", VC: self)
        }

    }
    
    // MARK: Close Keyboard

    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
        
        
        if (emailTextField.text?.isEqual(""))! || !isValidEmail(emailTextField.text) {
            
            return (false , "enter a valid email")
            
        }
        
        if (passwordTextField.text?.isEqual(""))! {
            return (false,"Please enter password")
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
    
    // MARK: Helper Methods
    
    func capitalizingFirstLetter(_ text:String?) -> String {
        let first = String(describing: text?.characters.prefix(1)).uppercased()
        let other = String(describing: text?.characters.dropFirst())
        return first + other
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
    
    
    // MARK: Call Api
    func MakeAPICall()
    {
        let params = ["email":emailTextField.text!,"password":passwordTextField.text!,"device_token":"asdsadas"] as [String : Any]
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.SIGNINAPIURL, parameters: params, success:
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
    
    
    func MakeAPICallFacebook()
    {
        var params = ["email":self.dict["email"] ?? "test@email.com","first_name":self.dict["first_name"] ?? "firstName","last_name":self.dict["last_name"] ?? "lastName","authentication_token":Fbtoken,"facebook_id":self.dict["id"] ?? "0"] as [String : Any]
        
        if let pictureDict=self.dict["picture"]{
            
            if let dataDict=pictureDict["data"] as! [String:Any]? {
            
                if let picUrl=dataDict["url"]{
                    
                    
                    params["profile_img"]=picUrl
                    
                }
                
            }
        
        }
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.SIGNINFBAPIURL, parameters: params, success:
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
    
    
    func MakeAPICallGoogle(user: GIDGoogleUser!)
    {
        
        
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name as String!
        //let givenName = user.profile.givenName
        //let familyName = user.profile.familyName
        let email = user.profile.email
        
        let fullNameArr = fullName?.components(separatedBy: " ")
        
        let firstName    = fullNameArr?[0]
        
        let lastName: String? = (fullNameArr?.count)! > 1 ? fullNameArr?[1] : ""
        
        var params = ["email":email ?? "no@email.com","first_name":firstName ?? "No","last_name":lastName ?? "Name","authentication_token":idToken ?? "0000","google_id":userId ?? "0000"] as [String : Any]
        
        if user.profile.hasImage != false {
            
            params["profile_img"]=(user.profile.imageURL(withDimension: 120) as URL).absoluteString
            
            
        }
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.SIGNINGOOGLEAPIURL, parameters: params, success:
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
            //self.navigationController?.pushViewController(nextViewController, animated:true)
            
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile,.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                //if grantedPermissions != nil {
                    if(grantedPermissions.contains("email"))
                    {
                        self.Fbtoken=accessToken.authenticationToken
                        self.getFBUserData()
                        //fbLoginManager.logOut()
                    }
                //}
                print("Logged in!")
            }
        }

    }
    
    func checkIfUserIsAuthorized() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // User authorized before
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            // User not authorized open sign in screen
            
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    
                    self.MakeAPICallFacebook()
                    //print(result!)
                    //print(self.dict)
                }
            })
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            self.MakeAPICallGoogle(user: user)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!){
    
        viewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) {
    
    
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        
        
        
    }
}
