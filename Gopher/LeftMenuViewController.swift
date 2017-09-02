//
//  LeftMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn

public class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?

    var titles: [String] = ["Add Card", "Setting","Log Out", "Terms of Service", "Privacy", "My Information"]
    var images: [String] = ["serach1", "setting1","setting1", "terms1", "privacy1", "my_Info"]

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let tableView: UITableView = UITableView.init(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 5) / 2.0, width: self.view.frame.size.width, height: 54 * 5), style: UITableViewStyle.plain)
        tableView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false

        self.tableView = tableView
        self.view.addSubview(self.tableView!)
        
    }

    // MARK: - <UITableViewDelegate>

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            //            case 0:
            //                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "firstViewController")), animated: true)
            //                self.sideMenuViewController!.hideMenuViewController()
            //
            //            case 1:
            //                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "secondViewController")), animated: true)
            //                self.sideMenuViewController!.hideMenuViewController()
            //        case 2:
            //            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "secondViewController")), animated: true)
            //            self.sideMenuViewController!.hideMenuViewController()
            //        case 3:
            //            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "addCardVc")), animated: true)
            //            self.sideMenuViewController!.hideMenuViewController()
            //        case 4:
            //            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "secondViewController")), animated: true)
            //            self.sideMenuViewController!.hideMenuViewController()
            
        case 0:
            
            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "addCardVc")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case 1:
        
//            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "editRental")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
            break//editRental
            
            
        case 2:
            
            self.logout()
            
            break//editRental
            
        default:
            break
        }
    }

    // MARK: - <UITableViewDataSource>

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return titles.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.font = UIFont.init(name: "HelveticaNeue", size: 21)
            cell!.textLabel?.textColor = UIColor.white
            cell!.textLabel?.highlightedTextColor = UIColor.lightGray
            cell!.selectedBackgroundView = UIView.init()
        }

        cell!.textLabel?.text = titles[indexPath.row]
        cell!.imageView?.image = UIImage.init(named: images[indexPath.row])

        return cell!
    }
    
    func logout(){
        //let appDomain = Bundle.main.bundleIdentifier
        //UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        //self.parent?.navigationController?.popToRootViewController(animated: true)

        //if GIDSignIn.sharedInstance().currentUser != nil {
            
            GIDSignIn.sharedInstance().signOut()
        
        //}
        
        FBSDKLoginManager().logOut()
        
        //self.parent?.dismiss(animated: true, completion: nil);
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "getStartedVc") as UIViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)


        
    }
}
