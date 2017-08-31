//
//  AppDelegate.swift
//  Gopher
//
//  Created by User on 2/8/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import GoogleSignIn
import GooglePlaces
import GoogleMaps
import IQKeyboardManagerSwift
import FBSDKLoginKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    


    var window: UIWindow?
    var categoryNameArray = [String]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        GMSServices.provideAPIKey(Constants.googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(Constants.googlePlacesClient)
        let rgbValue = 0x55A0BF
        let r = Float((rgbValue & 0xFF0000) >> 16)/255.0
        let g = Float((rgbValue & 0xFF00) >> 8)/255.0
        let b = Float((rgbValue & 0xFF))/255.0

        //UITabBar.appearance().barTintColor = UIColor(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        
        UITabBar.appearance().barTintColor = UIColor.white
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white] , for: .normal)

        //UITabBar.appearance().tintColor = UIColor.white
        
        UITabBar.appearance().tintColor = UIColor(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().backgroundColor = UIColor(red: 85.0/255.0, green: 160.0/255.0, blue: 191.0/255.0, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().tintColor = UIColor(red: 85.0/255.0, green: 160.0/255.0, blue: 191.0/255.0, alpha: 1)
        
        let response = UserDefaults.standard.object(forKey: "isLoggedIn") as? Bool
//        if(response==nil)
//        {
//            response = ""
//        }
        if(response == true)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
            //let nav = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = vc
            //self.window?.rootViewController?.navigationController?.navigationBar.isHidden = true
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "getStartedVc") as! ViewController
            let nav = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = nav
            //self.window?.rootViewController = nav
        }
        
        
//        var response = UserDefaults.standard.object(forKey: Constants.USERRESPONSEKEY) as! String?
//        if(response==nil)
//        {
//            response = ""
//        }
//        if((response?.characters.count)!>0)
//        {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
//            //let nav = UINavigationController(rootViewController: vc)
//            self.window?.rootViewController = vc
//            //self.window?.rootViewController?.navigationController?.navigationBar.isHidden = true
//        }
//        else
//        {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "getStartedVc") as! ViewController
//            let nav = UINavigationController(rootViewController: vc)
//            self.window?.rootViewController = nav
//            //self.window?.rootViewController = nav
//        }
        
        //var configureError: NSError? GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        //GIDSignIn.sharedInstance().clientID = "621594967069-4ct6ci046gejmovvc4nemlf9n25r1pv1.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = "621594967069-4ct6ci046gejmovvc4nemlf9n25r1pv1.apps.googleusercontent.com"
        //GIDSignIn.sharedInstance().delegate = self
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
//        self.present(nextViewController, animated:false, completion:nil)
        //return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true

    }
    
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//            openURL:url
//            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
//        ];
        
        let handled=FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url,
                                                                                                                                                                                                   sourceApplication: sourceApplication,
                                                                                                                                                                                                   annotation: annotation)
    }
    
//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        if(url.scheme!.isEqual("fbXXXXXXXXXXX")) {
//            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
//            
//        } else {
//            return GIDSignIn.sharedInstance().handle(url as URL!,
//                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
//                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        }
//    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }

        
    }
    
//    func application(application: UIApplication,
//                     open: URL, options: [String: AnyObject]) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url as URL!,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//    }
    
    

    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if #available(iOS 9.0, *) {
//            return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        } else {
//            // Fallback on earlier versions
//            return GIDSignIn.sharedInstance().handle(url,
//                                                        sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                        annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        }
//    }
    
//    func application(application: UIApplication,
//                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url as URL!,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
    
    
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

