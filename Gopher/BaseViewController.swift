//
//  BaseViewController.swift
//  Gopher
//
//  Created by Ashok Londhe on 31/08/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    let activityViewLayerCornerRadius = 05
    let activityViewBackgroundAlpha = 0.9
    let activityViewColorAlpha = 1.0
    let activityViewColorRed = 1.0
    let activityViewColorGreen = 1.0
    let activityViewColorBlue = 1.0
    var mainArray: NSArray = []
    var filerArray: NSArray = []
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyleForActivityIndicator()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Activity incator....
    
    func applyStyleForActivityIndicator() {
        
        activityView.layer.cornerRadius = CGFloat(activityViewLayerCornerRadius)
        activityView.center = CGPoint(x: self.view.frame.width / 2.0 , y: self.view.frame.size.height / 2.0)
        activityView.backgroundColor = UIColor(white: 0.0, alpha: CGFloat(activityViewBackgroundAlpha))
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityView.color = UIColor(red:CGFloat(activityViewColorRed),green:CGFloat(activityViewColorGreen),blue:CGFloat(activityViewColorBlue),alpha:CGFloat(activityViewColorAlpha))
        activityView.hidesWhenStopped = true
    }
    
    func showProgressLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.activityView.startAnimating()
            self.view.addSubview(self.activityView)
            
        }
    }
    
    func hideProgressLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()
            
        }
    }
   

}
