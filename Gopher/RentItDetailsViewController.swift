//
//  RentItDetailsViewController.swift
//  Gopher
//
//  Created by Ashok Londhe on 25/05/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SDWebImage

class RentItDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var titleOfGig: UILabel!
   // @IBOutlet weak var // mainImage: UIImageView!
    @IBOutlet weak var descriptionOfGig: UILabel!
    @IBOutlet weak var locationText: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    var selectedGig = LatLongDetail()
    //var selectedIndex = 0
    
    var imageWidth:CGFloat = 166
    let imageHeight:CGFloat = 166
    var xPosition:CGFloat = 8
    var scrollViewSize:CGFloat=0
    let margin:CGFloat=20

    override func viewDidLoad() {
        super.viewDidLoad()

        titleOfGig.text=selectedGig.gigTitle
        descriptionOfGig.text=selectedGig.gig_description
        locationText.text=selectedGig.location_string
        locationText.adjustsFontSizeToFitWidth = true
        
        if(selectedGig.type_of_payment.isEqual("1"))
        {
            hourlyLabel.text = "$ " + selectedGig.pay +  " Flat"
            
        }
        else
        {
            hourlyLabel.text = "$ " + selectedGig.pay + " Hourly"
            
        }

        
//        if(!(selectedGig.gigImage.isEqual("")))
//        {
//            mainImageView.sd_setImage(with: URL(string: selectedGig.gigImage))
//        }
//        else
//        {
//             mainImageView.image=UIImage(named: "placeholder.png")
//        }
        loadCurrentImages()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func loadCurrentImages(){
 
        imagesScrollView.isPagingEnabled = true
        imagesScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(selectedGig.gigImageList.count), height: imagesScrollView.frame.size.height)
        imagesScrollView.showsHorizontalScrollIndicator = false
        self.pageControl.numberOfPages = selectedGig.gigImageList.count
        imagesScrollView.delegate = self
        for (index,imageObject) in selectedGig.gigImageList.enumerated() {
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
    



    
    @IBAction func backButtonAction(_ sender: UIButton) {
        _=self.navigationController?.popViewController(animated: true)
        
//        let transition = CATransition()
//        transition.duration = 0.2
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func calenderTapped(_ sender: UIButton) {
        
        //selectedIndex=sender.tag
        performSegue(withIdentifier: "showCalender", sender: self)    }
    @IBAction func plusBtnTapped(_ sender: Any) {
    }
    @IBAction func termsAndConditonsTapped(_ sender: Any) {
    }
    @IBAction func contactTapped(_ sender: Any) {
    }
    @IBAction func rentTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalender" {
            let destinationVC = segue.destination as! AvailabilityCalenderViewController
            
            destinationVC.selectedDatesArray = selectedGig.calenderList
            destinationVC.selectedImageArray = selectedGig.gigImageList
            destinationVC.imageUrl = selectedGig.gigImage
            destinationVC.gigTitle = selectedGig.gigTitle
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(page)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
/*
 // MARK: - Page Control Page changed
     
*/
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let pager = sender
        let page = pager.currentPage
        var frame = imagesScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        imagesScrollView.scrollRectToVisible(frame, animated: true)
        
    }

}
