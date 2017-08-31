//
//  ViewController.swift
//  Gopher
//
//  Created by User on 2/8/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ViewController: UIViewController , TTTAttributedLabelDelegate {

    // MARK: Outlet Properties
    
    @IBOutlet weak var termsAndConditionText: TTTAttributedLabel!
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.makeTextClickable()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Make Terms and Condition Label Clickable
    
    func makeTextClickable() {
    let termsAndContionsText : NSString = "By continuing you agree to the permissions used by this app and the Gopher privacy settings"
    termsAndConditionText.delegate = self
    termsAndConditionText.text = termsAndContionsText as String
    termsAndConditionText.textColor = UIColor.white
    let range1 : NSRange = termsAndContionsText.range(of: "privacy settings")
    let range : NSRange = termsAndContionsText.range(of: "permissions")
    termsAndConditionText.addLink(to: NSURL(string: "http://google.com/")! as URL!, with: range)
    termsAndConditionText.addLink(to: NSURL(string: "http://google.com/")! as URL!, with: range1)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
        
    }
    
    // MARK: Button Actions
    @IBAction func get_started_Btn(_ sender: Any) {
       
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
        
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        
        self.present(nextViewController, animated: true, completion: nil)

        
        //self.navigationController?.pushViewController(nextViewController, animated:true)
     //  self.present(nextViewController, animated:false, completion:nil)
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
//        self.pushViewController(nextViewController, animated: true)
        //self.present(nextViewController, animated:false, completion:nil)
    }

}

