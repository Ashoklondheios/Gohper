//
//  AddExpenseViewController.swift
//  Gopher
//
//  Created by User on 4/7/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking
class AddExpenseViewController: UIViewController {

    @IBOutlet weak var addReciptBtnOutlet: UIButton!
    @IBOutlet weak var recieptImage: UIImageView!
    @IBOutlet weak var addRecipetLabel: UILabel!
    @IBOutlet weak var addReciptImageLogo: UIImageView!
    @IBOutlet weak var addExtraExpenseLabel: UILabel!
    @IBOutlet weak var addExpenseEditText: UITextField!
    var prepCompressedImage: UIImage!
    var imagePicker = UIImagePickerController()
    var base64StringOf_my_image = String()
    var order_gig_post = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addReciept(_ sender: Any) {
        
        showActionSheet()
        
        // For picking image from gallery
        
        
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//        present(imagePicker, animated: true,completion: nil)
    }
    
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func camera()
    {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true,completion: nil)
        
    }
    
    func photoLibrary()
    {
        imagePicker.delegate = self;
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true,completion: nil)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButton(_ sender: Any) {
        displayConfirmationAlert()

    }
    @IBAction func skipBtn(_ sender: Any) {
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
        let params = ["user_id": UserModel.getUserData().userId,"order_gig_post_id": order_gig_post,"expense": addExpenseEditText.text!] as [String : Any]
        //,"receipt_img":base64StringOf_my_image
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.sellerCompleteGigPostResponseAPIURL, parameters: params, success:
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
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
//            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
    }

    func showAlert(_ error: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: "Congratulations", message: "Task has been completed.", preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
    }
}
extension AddExpenseViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            recieptImage.image = pickedImage
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
}
