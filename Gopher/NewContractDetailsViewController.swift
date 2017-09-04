//
//  NewContractDetailsViewController.swift
//  Gopher
//
//  Created by Ashok Londhe on 03/09/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class NewContractDetailsViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var serviceChargesLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    @IBOutlet weak var imagesScrollView: UIScrollView!
    //MARK:- Variables
    var categorieList = NSMutableArray()
    var titleString = ""
    var descriptionFromPostVC = ""
    var categorieListFromPostVC = NSMutableArray()
    var gigImageList = NSMutableArray()
    var locationFromPostVC = ""
    var deadLineFromPostVC = ""
    var paymentFromPostVC = ""
    var paymentTimeFromPostVC = ""
    var stateFromPostVC = ""
    var cityFromPostVC = ""
    var countryFromPostVC = ""
    var longitudeFromPostVC = ""
    var latFromPostVC = ""
    var location_stringFromPostVC = ""
    var paymentType = ""
    var defaultXValueforView = 5;
    var defaultCategoryScrollContentSize = 100;
    var fromNotificationVC = ""
    var gigImage=""
    var datesArrayCount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideProgressLoader()
        parentScrollView.isUserInteractionEnabled = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        parentScrollView.contentSize = CGSize(width: screenWidth, height: self.view.frame.height+50)
        parentScrollView.keyboardDismissMode = .onDrag
        // self.makeTextClickable()
        titleLabel.text = titleString
        descriptionLabel.text = "  " + descriptionFromPostVC
        locationLabel.text = cityFromPostVC
        timeLabel.text = paymentTimeFromPostVC
        categorieList = categorieListFromPostVC
        if(paymentTimeFromPostVC.isEqual("1")) {
            paymentType = " Daily"
        }
        else {
            paymentType = " Hourly"
        }
        
        
        
        if paymentTimeFromPostVC == "1" {
            
            rateLabel.text="Rate: $\(paymentFromPostVC)/day"
            
        }else{
            
            rateLabel.text="Rate: $\(paymentFromPostVC)/hr"
            
        }
        
      //  let datesArray=params["calender"] as! NSMutableArray
        
        if paymentTimeFromPostVC == "1" {
            
            
            durationLabel.text="Duration: \(datesArrayCount) day/s"
            
        }else{
            
            durationLabel.text="Duration: \(datesArrayCount) hour/s"
            
        }
//
        let totalDeposit = Int(datesArrayCount)!*Int(paymentFromPostVC)! as Int
        
        depositLabel.text="Deposit: $\(totalDeposit)"
        
        let serviceCharges=10
        
        serviceChargesLbl.text="Service Fee: $\(serviceCharges)"
        
        totalPriceLbl.text="Total: $\(totalDeposit+serviceCharges)"

        
        
        costLabel.text = "$ " + paymentFromPostVC + " " + paymentType
        self.addCategoriesToView()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if(!(self.fromNotificationVC.isEqual("")))
        {
            //self.applyNowBtn.isHidden = true
           // self.termsText.isHidden = true
        }
        else
        {
            //self.applyNowBtn.isHidden = false
            //self.termsText.isHidden = false
            
        }
        
        loadCurrentImages()

        // Do any additional setup after loading the view.
    }
    
    func loadCurrentImages(){
        
        imagesScrollView.isPagingEnabled = true
        imagesScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(gigImageList.count), height: imagesScrollView.frame.size.height)
        imagesScrollView.showsHorizontalScrollIndicator = false
        self.pageControl.numberOfPages = gigImageList.count
        imagesScrollView.delegate = self
        for (index,imageObject) in gigImageList.enumerated() {
            if let detailedImageView = Bundle.main.loadNibNamed("DetailImageView", owner: self, options: nil)?.first as? DetailImageView {
                
                detailedImageView.mainImageView.sd_addActivityIndicator()
                if let gigImageObject = imageObject as? GigImageObject {
                    detailedImageView.layoutIfNeeded()
                    detailedImageView.mainImageView.sd_setImage(with:  URL(string: gigImageObject.gigpost_image_url), placeholderImage: UIImage(named: "placeholder.png"), options: .refreshCached)
                    
                    // detailedImageView.mainImageView.sd_setImage(with: URL(string: gigImageObject.gigpost_image_url))
                    imagesScrollView.addSubview(detailedImageView)
                    detailedImageView.frame.size.width = self.view.bounds.size.width
                    detailedImageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                    detailedImageView.mainImageView.clipsToBounds = true
                    
                }
            }
        }
    }
    
    func createViewForCatogry(name: String, heightOfParent: Int) -> UIView {
        
        let catogeryView=UIView(frame: CGRect(x:defaultXValueforView, y:5, width:100, height:30))
        catogeryView.backgroundColor = UIColorFromRGB(rgbValue: 0xdfdfdf)
        
        let categoryName: UILabel = UILabel()
        categoryName.frame = CGRect(x: 8, y:5, width:80, height:21)
        categoryName.textColor = UIColorFromRGB(rgbValue: 0x55A0BF)
        categoryName.textAlignment = NSTextAlignment.center
        categoryName.text = name
        categoryName.font = categoryName.font.withSize(10)
        catogeryView.addSubview(categoryName)
        defaultXValueforView = defaultXValueforView + 120;
        return catogeryView
    }
    
    func addCategoriesToView()
    {
        for i in 0..<categorieList.count {
            
            let catogry = categorieList[i] as! CategoryModel
            defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 90
            categoryScrollView.addSubview(self.createViewForCatogry(name: catogry.catName, heightOfParent: Int(categoryScrollView.frame.size.height)))
            categoryScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
            
        }
        defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 40
        categoryScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.showsVerticalScrollIndicator = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        // self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) { 
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(page)
    }


}
