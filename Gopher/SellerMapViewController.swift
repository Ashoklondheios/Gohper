//
//  SellerMapViewController.swift
//  Gopher
//
//  Created by User on 2/13/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMapsCore
import GooglePlaces
import GoogleMaps
import AFNetworking
import SDWebImage
class SellerMapViewController: BaseViewController,GMSMapViewDelegate, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, AvailabilityCalenderDatesProtocol {
    
    // MARK: IBOutlet Properties
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gigDetailView: UIView!
//    @IBOutlet weak var postGigStar5: UIImageView!
//    @IBOutlet weak var postGigStar4: UIImageView!
//    @IBOutlet weak var postGigStar3: UIImageView!
//    @IBOutlet weak var postGigStar2: UIImageView!
//    @IBOutlet weak var postGigStar1: UIImageView!
//    @IBOutlet weak var postGigPaymentAmount: UILabel!
//    @IBOutlet weak var postGigTime: UILabel!
//    @IBOutlet weak var postGigReviews: UILabel!
//    @IBOutlet weak var postGigDeadline: UILabel!
    @IBOutlet weak var rentBtn: UIButton!
    @IBOutlet weak var dailyRateLabel: UILabel!
    @IBOutlet weak var hourlyRateLabel: UILabel!
    @IBOutlet weak var postGigPersonName: UILabel!
    @IBOutlet weak var postGigDistance: UILabel!
    //@IBOutlet weak var postGigTaskType: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var gigBtnContact: UIButton!
    @IBOutlet weak var trunOnLocationView: UIView!
    @IBOutlet weak var trunOnLocationImgView: UIImageView!
    @IBOutlet weak var trunOnLocationBtnOutlet: UIButton!
    
    @IBOutlet weak var filterView: V2DropDown!
//    @IBOutlet weak var trunOnLocationView: UIView!
//    @IBOutlet weak var trunOnLocationImgView: UIImageView!
//    @IBOutlet weak var trunOnLocationBtnOutlet: UIButton!
    // MARK: IBOutlet Properties For TableView

    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gigListTableView: UITableView!
    
    // MARK: Variables
    let locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient.shared()
    var mLongitutde = ""
    var mLatitude = ""
    var deadLine = ""
    var amount = ""
    var listOfGigs = NSMutableArray()
    var listOfGigsAfterFilter = NSMutableArray()

    var listOfConversation = NSMutableArray()
    var tableView = UITableView()
    var markerDetails = LatLongDetail()
    var selected_row=0
    var categoryNameArray = [String]()
    var allCategoryList = [NSMutableDictionary]()
    
    
    // MARK: View Life Cycle - Ashok
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideProgressLoader()
        self.hideTableView()
        self.hideLocationView()
        let timer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(timePrinter), userInfo: nil, repeats: true)
        profilePicImg.layer.borderWidth=1.0
        profilePicImg.layer.masksToBounds = false
        profilePicImg.layer.borderColor = UIColor.white.cgColor
        profilePicImg.layer.cornerRadius = 13
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.height/2
        profilePicImg.clipsToBounds = true
        timer.fire()
       // self.gigBtnSendContract.isHidden = true
        
        mapView.isUserInteractionEnabled = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.setAllGesturesEnabled(true)
        mapView.delegate = self;

        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePicImg.isUserInteractionEnabled = true
        profilePicImg.addGestureRecognizer(tapGestureRecognizer)

        let gigDetailViewtap = UITapGestureRecognizer(target: self, action: #selector(gigDetailViewTap(tapGestureRecognizer:)))
        gigDetailView.isUserInteractionEnabled = true
        gigDetailView.addGestureRecognizer(gigDetailViewtap)
        self.initialization()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector:#selector(BrowseViewController.appIsComingForeground), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.calenderTapped), name:NSNotification.Name(rawValue: "calenderTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.filterDoneTapped(notification:)), name:NSNotification.Name(rawValue: "filterDoneTapped"), object: nil)
        self.gigListTableView.register(RentalListTableViewCell.self, forCellReuseIdentifier: "RentalListCell")
        self.gigListTableView.register(UINib(nibName: "RentalListTableViewCell", bundle: nil), forCellReuseIdentifier: "RentalListCell")
        
        filterView.style = .DropDownDefault
        filterView.optionsArray = ["Sort", "Availability Calender", "Category", "Distance", "Price"]
        filterView.detailsArray = ["Best Match", "", "All", "5 Miles", "$2000"]

        filterView.isHidden = true
        if(Commons.connectedToNetwork()) {
            self.getCategoriesAPICall()
        }

        self.segmentedControl.selectedSegmentIndex = 0
        self.GetNotificationAPICall()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.showLocationView()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.hideLocationView()
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func appIsComingForeground(){
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    self.showLocationView()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    self.hideLocationView()
                }
            } else {
                print("Location services are not enabled")
            }
        }
        
    }

    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        if self.filterView.isHidden {
            self.filterView.isHidden = false
        } else {
            self.filterView.isHidden = true
        }
        if segmentedControl.selectedSegmentIndex == 0 {
            self.filterViewTopConstraint.constant = 104
            self.mapView.addSubview(filterView)
            self.mapView.bringSubview(toFront: filterView)

        } else {
            self.filterViewTopConstraint.constant = 60
            self.gigListTableView.addSubview(filterView)
            self.gigListTableView.bringSubview(toFront: filterView)

        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func selectRentIt(_ sender: UIButton) {
        
        selected_row=sender.tag
        
        let selectedGig = listOfGigs[selected_row] as! LatLongDetail
        
        
        if(UserModel.getUserData().userId.isEqual(selectedGig.userId))
        {
            
        }else{
        
            performSegue(withIdentifier: "selectRentIt", sender: self)
        }
        
    }
    
    @IBAction func selectContacts(_ sender: UIButton) {
        
        selected_row=sender.tag
        
        let selectedGig = listOfGigs[selected_row] as! LatLongDetail
        
        
        if(UserModel.getUserData().userId.isEqual(selectedGig.userId))
        {
            
        }else{
            if Commons.connectedToNetwork() {
                self.GetAllConversationsAPICall(selectedGig)
            }
            else {
                Commons.showAlert("Network Error", VC: self)
            }
        }
        
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let viewController = storyboard.instantiateViewController(withIdentifier :"selectRentIt") as! RentDatesController
        //
        ////        let selectedGig = listOfGigs[indexPath.row] as! LatLongDetail
        ////
        ////        viewController.selectedGig = selectedGig
        //
        //        self.show(viewController, sender: self)
        
        //performSegue(withIdentifier: "selectRentIt", sender: self)
        
        
    }
    
    
    @IBAction func availibilityCalenderTapped(_ sender: Any) {
    }
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int {
      //  self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfGigs.count
    }
    
    @IBAction func rentButtonClicked(_ sender: Any) {
        
        self.selectRentIt(sender as! UIButton)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "RentalListCell", for: indexPath)as! RentalListTableViewCell
        
        let markerDetails = listOfGigs[indexPath.row] as! LatLongDetail
        
        if(!(markerDetails.gigImage.isEqual("")))
        {
            cell.gigImage.sd_setImage(with:  URL(string: markerDetails.gigImage), placeholderImage: nil, options: .refreshCached)
           // cell.gigImage.sd_setImage(with: URL(string: markerDetails.gigImage))
        }
        else
        {
            cell.gigImage.image=UIImage(named: "placeholder.png")
            //cell.gigImage.setBackgroundImage( UIImage(named: "placeholder.png"), for: .normal)
        }
        
        if(UserModel.getUserData().userId.isEqual(markerDetails.userId))
        {
            
            cell.rentButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.contactButton.layer.borderColor = UIColor.lightGray.cgColor
            
            //cell.rentButton.isEnabled=false
            //cell.contactButton.isEnabled=false
            
            //cell.rentButton.tintColor = UIColor.lightGray
            //cell.contactButton.tintColor = UIColor.lightGray
            
            cell.rentButton.setTitleColor(.lightGray, for: .normal)
            cell.contactButton.setTitleColor(.lightGray, for: .normal)
            

            
        }else{
            
            
            let rgbValue = 0x55A0BF
            let r = Float((rgbValue & 0xFF0000) >> 16)/255.0
            let g = Float((rgbValue & 0xFF00) >> 8)/255.0
            let b = Float((rgbValue & 0xFF))/255.0
            
            
            cell.rentButton.layer.borderColor = UIColor(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0).cgColor
            cell.contactButton.layer.borderColor = UIColor(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0).cgColor
            
            //cell.rentButton.isEnabled=false
            //cell.contactButton.isEnabled=false
            
            //cell.rentButton.tintColor = UIColor.lightGray
            //cell.contactButton.tintColor = UIColor.lightGray
            
            cell.rentButton.setTitleColor(UIColor(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0), for: .normal)
            cell.contactButton.setTitleColor(UIColor(red:CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0), for: .normal)
            
        
            
        
        }
        
        cell.rentButton.tag=indexPath.row
        cell.contactButton.tag=indexPath.row
        
        // cell.gigProfileImg.sd_setImage(with: URL(string: markerDetails.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        
        //cell.gigProfileImg.tag = indexPath.row + 10
        //cell.gigProfileImg.addTarget(self, action: #selector(buttonProfileTapped(_:)), for: .touchUpInside)
        
        
        
        if(markerDetails.type_of_payment.isEqual("1"))
        {
            cell.dailyRatesLabel.text = "$ " + markerDetails.pay +  " Flat"
            cell.hourlyRatesLabel.isHidden = true
            cell.dailyRatesLabel.isHidden = false
        }
        else
        {
            cell.hourlyRatesLabel.text = "$ " + markerDetails.pay + " Hourly"
            cell.hourlyRatesLabel.isHidden = false
            cell.dailyRatesLabel.isHidden = true

        }
        cell.mainTitle.text = markerDetails.gigTitle
        cell.detailDescription.text=markerDetails.gig_description
        cell.distance.text = markerDetails.distance + " miles away"
        //cell.deadLineText.text = markerDetails.deadline
        //cell.backgroundColor = UIColor.red
        /*  Commented by ashok
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)as! GigListTableViewCell
        let markerDetails = listOfGigs[indexPath.row] as! SellerDetail
        if(!(markerDetails.profile_img.isEqual("")))
        {
            cell.gigProfileImg.sd_setBackgroundImage(with: URL(string: markerDetails.profile_img), for: .normal)
        }
        else
        {
            
             cell.gigProfileImg.setBackgroundImage( UIImage(named: "placeholder.png"), for: .normal)
        }
        
        
       // cell.gigProfileImg.sd_setImage(with: URL(string: markerDetails.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        
        cell.gigProfileImg.tag = indexPath.row + 10
        cell.gigProfileImg.addTarget(self, action: #selector(buttonProfileTapped(_:)), for: .touchUpInside)
        
        
        
        if(markerDetails.type_of_payment.isEqual("0"))
        {
            cell.amountAndType.text = "$ " + markerDetails.pay +  " Flat"

        }
        else
        {
            cell.amountAndType.text = "$ " + markerDetails.pay + " Hourly"

        }
        cell.gigName.text = markerDetails.first_name + " " + markerDetails.last_name
        cell.gigDistance.text = markerDetails.distance + " miles away"
        cell.deadLineText.text = markerDetails.deadline
        if(UserModel.getUserData().userId.isEqual(markerDetails.userId))
        {
            cell.gigContact.isHidden = true
        }
        else
        {
            cell.gigContact.isHidden = false
        }
        cell.gigContact.backgroundColor = .clear
        cell.gigContact.layer.cornerRadius = 5
        cell.gigContact.layer.borderWidth = 1
        cell.gigContact.layer.borderColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF).cgColor
        cell.gigContact.tag = indexPath.row + 100 */
      //  cell.gigContact.addTarget(self, action: #selector(contactButtonClicked(_:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "rentItDetailsVC", sender: self)
        
        //selected_row=indexPath.row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"showRentDetail") as! RentItDetailsViewController
        
        let selectedGig = listOfGigs[indexPath.row] as! LatLongDetail
        viewController.selectedGig = selectedGig
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectRentIt" {
            
            
            
            let selectedGig = listOfGigs[selected_row] as! LatLongDetail

            let destinationVC = segue.destination as! RentDatesController
            
            var selectedDates = [Date]()
            
            for (_, object) in selectedGig.calenderList.enumerated()
            {
                let item = object as! CalenderObject
                
                print(item.calenderDate)
                
                selectedDates.append(Commons.getDatefromString(dateFrom: item.calenderDate)!)
                
                
            }
            destinationVC.selectedImageArray = selectedGig.gigImageList
            destinationVC.selectedDatesArray = selectedGig.calenderList
            destinationVC.arrayOfDates = selectedDates
            destinationVC.imageUrl = selectedGig.gigImage
            destinationVC.gigTitle = selectedGig.gigTitle
            destinationVC.gigDetail = selectedGig
            destinationVC.paymentType=selectedGig.type_of_payment
            
            
            //destinationVC.datesDelegate = self
        } else if segue.identifier == "availabilityCalenderVC" {
            let destinationVC = segue.destination as! AvailabilityCalenderViewController
//            
//            if editFlag {
//                
//                destinationVC.selectedDatesArray = editGigDetail.calenderList
//                destinationVC.imageUrl = editGigDetail.gigImage
//                destinationVC.gigTitle = editGigDetail.gigTitle
//            }
//            
            destinationVC.datesDelegate = self
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "rentItDetailsVC" ,
//            let nextScene = segue.destination as? RentItDetailsViewController ,
//            let indexPath = self.tableView.indexPathForSelectedRow {
//            let selectedGig = listOfGigs[indexPath.row] as! LatLongDetail
//
//            nextScene.selectedGig = selectedGig
//        }
//    }
    

    
    // MARK: IBAction Methods
    
    @IBAction func turnOnLocationBtn(_ sender: Any) {
         UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
    }
    
    
    func gigDetailViewTap(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
//        nextViewController.profileId = markerDetails.userId
//        nextViewController.profilePicUrl = markerDetails.profile_img
//        //self.navigationController?.pushViewController(nextViewController, animated:true)
//        self.present(nextViewController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"showRentDetail") as! RentItDetailsViewController
        
        viewController.selectedGig = markerDetails
        
        self.present(viewController, animated: true, completion: nil)
        
        
        
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sendContractDetailVC") as! PreviewSendContractDetailsViewController
//        var categorieList = NSMutableArray()
//        var descriptionFromPostVC = ""
//        var categorieListFromPostVC = NSMutableArray()
//        var locationFromPostVC = ""
//        var deadLineFromPostVC = ""
//        var paymentFromPostVC = ""
//        var paymentTimeFromPostVC = ""
//        var stateFromPostVC = ""
//        var cityFromPostVC = ""
//        var countryFromPostVC = ""
//        var longitudeFromPostVC = ""
//        var latFromPostVC = ""
//        var location_stringFromPostVC = ""
//        var paymentType = ""
        
//        nextViewController.descriptionFromPostVC = markerDetails.gig_description
//        nextViewController.categorieListFromPostVC = markerDetails.categoryList
//        nextViewController.locationFromPostVC = markerDetails.location_string
//        nextViewController.deadLineFromPostVC = markerDetails.deadline
//        nextViewController.paymentFromPostVC = markerDetails.pay
//        nextViewController.paymentTimeFromPostVC = markerDetails.deadline
//        nextViewController.stateFromPostVC = markerDetails.state
//        nextViewController.cityFromPostVC = markerDetails.city
//        nextViewController.countryFromPostVC = markerDetails.country
//        nextViewController.longitudeFromPostVC = markerDetails.long
//        nextViewController.latFromPostVC = markerDetails.lat
//        nextViewController.location_stringFromPostVC = markerDetails.location_string
//        nextViewController.paymentType = markerDetails.type_of_payment
//        self.present(nextViewController, animated:true, completion:nil)
        
        // Your action
    }
    
    func buttonProfileTapped(_ sender : UIButton){
        let buttonRow = sender.tag - 10
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
//        
//        let markerDetails = listOfGigs[buttonRow] as! LatLongDetail
//        
//        nextViewController.profileId = markerDetails.userId
//        nextViewController.profilePicUrl = markerDetails.profile_img
//        //self.navigationController?.pushViewController(nextViewController, animated:true)
//        self.present(nextViewController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"showRentDetail") as! RentItDetailsViewController
        
        let markerDetails = listOfGigs[buttonRow] as! LatLongDetail
        
        viewController.selectedGig = markerDetails
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func buttonTapped(_ sender : UIButton){
        let buttonRow = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let markerDetails = listOfGigs[buttonRow] as! LatLongDetail
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sellerPreviewSendContractVC") as! SellerPreviewSendContractDetailsViewController
        
        nextViewController.descriptionFromPostVC = markerDetails.gig_description
        nextViewController.categorieListFromPostVC = markerDetails.categoryList
        nextViewController.locationFromPostVC = markerDetails.location_string
        nextViewController.deadLineFromPostVC = markerDetails.deadline
        nextViewController.paymentFromPostVC = markerDetails.pay
        nextViewController.paymentTimeFromPostVC = markerDetails.type_of_payment
        nextViewController.stateFromPostVC = markerDetails.state
        nextViewController.cityFromPostVC = markerDetails.city
        nextViewController.countryFromPostVC = markerDetails.country
        nextViewController.longitudeFromPostVC = markerDetails.long
        nextViewController.latFromPostVC = markerDetails.lat
        nextViewController.buyerId = markerDetails.gig_user_id
        nextViewController.location_stringFromPostVC = markerDetails.location_string
        nextViewController.selectedGigDetail = markerDetails
        
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
//        nextViewController.profileId = markerDetails.userId
//        nextViewController.profilePicUrl = markerDetails.profile_img
//        //self.navigationController?.pushViewController(nextViewController, animated:true)
//        
//        self.present(nextViewController, animated: true, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"showRentDetail") as! RentItDetailsViewController
        
        
        
        viewController.selectedGig = markerDetails
        
        self.present(viewController, animated: true, completion: nil)
        
        // Your action
    }
    @IBAction func contactBtn(_ sender: Any) {
    }
    
    @IBAction func applyBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "sellerPreviewSendContractVC") as! SellerPreviewSendContractDetailsViewController
        
        nextViewController.descriptionFromPostVC = markerDetails.gig_description
        nextViewController.categorieListFromPostVC = markerDetails.categoryList
        nextViewController.locationFromPostVC = markerDetails.location_string
        nextViewController.deadLineFromPostVC = markerDetails.deadline
        nextViewController.paymentFromPostVC = markerDetails.pay
        nextViewController.paymentTimeFromPostVC = markerDetails.type_of_payment
        nextViewController.stateFromPostVC = markerDetails.state
        nextViewController.cityFromPostVC = markerDetails.city
        nextViewController.countryFromPostVC = markerDetails.country
        nextViewController.longitudeFromPostVC = markerDetails.long
        nextViewController.latFromPostVC = markerDetails.lat
        nextViewController.buyerId = markerDetails.gig_user_id
        nextViewController.location_stringFromPostVC = markerDetails.location_string
        nextViewController.gigPostId = markerDetails.gig_post_id
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated: true, completion: nil)
    }
   

    @IBAction func indexChanged(sender: UISegmentedControl) {
        self.filterView.isHidden = true
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.hideTableView()

        case 1:
            self.showtableView()
        default:
            break;
        }
    }
    
    @IBAction func contactButtonClicked(_sender:UIButton){
        
        if Commons.connectedToNetwork() {
            self.GetAllConversationsAPICall(markerDetails)
        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }

        
        
    }
   
    
    @IBAction func menuLargeBtn(_ sender: Any) {
         self.sideMenuViewController!.presentLeftMenuViewController()
    }
    @IBAction func menuBtn(_ sender: Any) {
        self.sideMenuViewController!.presentLeftMenuViewController()

    }
    
    // MARK: Mapview Methods
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // reset custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        //    customInfoView.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Remember to return false
        // so marker event is still handled by delegate
        
        markerDetails = marker.userData as! LatLongDetail
        print(markerDetails)
        print("clicked")
        postGigPersonName.text = markerDetails.gigTitle
        postGigDistance.text = markerDetails.distance + "miles away"
        if markerDetails.type_of_payment == "1" {
            dailyRateLabel.text="Daily Rate : " + "$" + markerDetails.pay
            dailyRateLabel.isHidden = false
            hourlyRateLabel.isHidden = true
        } else {
            hourlyRateLabel.text="Hourly Rate : " + markerDetails.pay
            dailyRateLabel.isHidden = true
            hourlyRateLabel.isHidden = false

        }

        
        if(UserModel.getUserData().userId.isEqual(markerDetails.userId))
        {
            gigBtnContact.isHidden = true
            rentBtn.isHidden = true
           // gigBtnSendContract.isHidden = true
        }
        else
        {
            gigBtnContact.isHidden = false
            rentBtn.isHidden = false

            gigBtnContact.addTarget(self, action: #selector(contactButtonClicked(_sender:)), for: .touchUpInside)
        }
        profilePicImg.sd_setImage(with:  URL(string: markerDetails.gigImage), placeholderImage: UIImage(named: "placeholder.png"), options: .refreshCached)
        gigDetailView.isHidden = false
        return false
    }
    
    // let the custom infowindow follows the camera
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

    }
    deinit {
        mapView = nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    //MARK:- initialization current location
    private func initialization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = 45
        locationManager.distanceFilter = 100
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()

       // self.updateLocation(locationManager.location!)
        //loadNearestMechanics(custom_lat_long: "")
    }

fileprivate func getCurrentLocation() {
        if Commons.connectedToNetwork() {
            placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                if error != nil {
                    self.getCurrentLocation()
                    // self.hideSearchView()
                    return
                }
                //appUtility.loadingView(self, wantToShow: false)
                if let placeLikelihoodList = placeLikelihoodList {
                    for likelihood in placeLikelihoodList.likelihoods {
                        let place = likelihood.place
                        //                        appShared.currentLocation = place
                        
                        self.locationManager.startUpdatingLocation()
                        
                        // self.address.text = "Current Location"
                    }
                }
            })
        }else {
            // appUtility.loadingView(self, wantToShow: false)
            Commons.showAlert("Network Error" , VC: self)
        }
    }
    
        fileprivate func updateLocation(_ manager: CLLocation) {
          //  let params = ["user_id": "","location" : manager.coordinate.latitude]as [String : Any]
            print(manager.coordinate.latitude)
            mLongitutde = String(manager.coordinate.longitude)
            mLatitude = String(manager.coordinate.latitude)
            
            let location = CLLocation(latitude: manager.coordinate.latitude, longitude: manager.coordinate.longitude) //changed!!!
            print(location)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                print(location)
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks?[0] as CLPlacemark?
                    print(pm?.locality ?? "")
                    UserDefaults.standard.set(pm?.locality ?? "", forKey: "city")
                    UserDefaults.standard.set(pm?.country ?? "", forKey: "country")
                    
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
            
            if(Commons.connectedToNetwork())
            {
                
                self.MakeAPICall()
                
            }
            else
            {
                Commons.showAlert("Please check your connection", VC: self)
            }
        }
    
    // MARK: Draw Markers On Map
    fileprivate func drawMarkersOnMap() {
        
        mapView.clear()
        
        var bounds = GMSCoordinateBounds()
        for gigPost in self.listOfGigs {
            
            let latlong =  gigPost as! LatLongDetail
            print(latlong.lat)
            if(!(latlong.lat.isEqual("")) && !(latlong.long.isEqual("")))
            {
                let location = CLLocationCoordinate2D(latitude: Double(latlong.lat)!, longitude: Double(latlong.long)!)
                let marker = GMSMarker(position: location)
                marker.appearAnimation = GMSMarkerAnimation.pop
                if(!(latlong.lat.isEqual("0")) && !(latlong.long.isEqual("0")))
                {
                    mapView.camera = GMSCameraPosition.camera(withLatitude: Double(latlong.lat)!, longitude: Double(latlong.long)!, zoom:1)
                    marker.zIndex = 1
                    
                    //changing the tint color of the image
                    //markerView.tintColor = UIColorFromRGB(rgbValue: 0x55A0BF)
                    marker.icon = UIImage(named: "mappin")!.withRenderingMode(.alwaysTemplate)
                    marker.title = latlong.pay
                    marker.map = mapView
                    marker.userData = gigPost
                    bounds = bounds.includingCoordinate(marker.position)
                    // mapView.selectAll(marker)
                    
                    
                    
                }
            }
        }
    }
    
    //MARK:- Public Methods
    
    func timePrinter() {
        locationManager.startUpdatingLocation()
    }

    //MARK:- Get All Gigs Post Api Call
    func MakeAPICall()
    {
        
        var params = ["user_id" : UserModel.getUserData().userId ,"lat":mLatitude,"long":mLongitutde] as [String : Any]
        print(params)
        
        
        var post_url=Constants.GETALLGIGGSAPIURL
        
        if (searchBar.text?.characters.count)!>0{
        
        
            params["keyword"]=searchBar.text
            post_url=Constants.SEARCHGIGGSAPIURL
        }
        
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(post_url, parameters: params, success:
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
        let dict = Commons.convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
           //Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 401 {
            
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        if code == 400 {
            Commons.showAlert(dict?["msg"] as! String, VC: self)
        }
        
        if(code == 200)
        {
            listOfGigs.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            
            for i in 0..<msgArray.count {
                let gigDetails = LatLongDetail()
                let firstObject = msgArray[i] as! NSDictionary
                let userInfo = firstObject["UserInfo"] as! NSDictionary
                let user = firstObject["User"] as! NSDictionary
                let gigInfo = firstObject["GigPost"] as! NSDictionary
                
                var locationInfo = NSDictionary()
                if let  locationInfo1 = firstObject["Location"] as? NSDictionary {
                    locationInfo = locationInfo1
                }
                //let locationInfo = firstObject["Location"] as! NSDictionary
                
                var distance = 0
                if let  distanceDict = firstObject["0"] as? NSDictionary {
                    if let distance1 = distanceDict["distance"] as? String, let dictInFloat = Float(distance1) {
                        distance = Int(dictInFloat)
                    }
                }
                gigDetails.userId = userInfo["user_id"] as! String
                gigDetails.email = user["email"] as! String
                
                if let firstName = userInfo["first_name"] as? String {
                    gigDetails.first_name = firstName
                }
                
                if let last_name = userInfo["last_name"] as? String {
                    gigDetails.last_name = last_name
                }
                
                if let phone_Number =  userInfo["phone_no"] as? String {
                    gigDetails.phone_no = phone_Number
                }
                
                if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                    gigDetails.profile_img = String (userInfo["profile_img"] as! String)
                }else{
                    gigDetails.profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
                }
                
                if let registration_date =  gigInfo["registration_date"] as? String {
                    gigDetails.registration_date = Commons.changeDateFormat(dateFrom: registration_date)
                }
                
                if let gig_post_id =  gigInfo["gig_post_id"] as? String {
                    gigDetails.gig_post_id = gig_post_id
                }
                
                if let user_id =  gigInfo["user_id"] as? String {
                    gigDetails.gig_user_id = user_id
                }
                
                if let gig_description =  gigInfo["description"] as? String {
                    gigDetails.gig_description = gig_description
                }
                
                if let pay =  gigInfo["pay"] as? String {
                    gigDetails.pay = pay
                }
                
                if let gigTitle = gigInfo["title"] as? String {
                    gigDetails.gigTitle = gigTitle
                }
                
                
                if let gigImage = gigInfo["image"] as? String {
                    gigDetails.gigImage =  String (Constants.PROFILEBASEURL) + String (gigImage)
                }

                if let deadline = gigInfo["deadline"] as? String {
                    gigDetails.deadline = deadline
                }
                
                if let type_of_payment = gigInfo["type_of_payment"] as? String{
                    gigDetails.type_of_payment = type_of_payment
                }
                
                var catObjectList = NSArray()
                if let catObjectList1 = firstObject["GigPostAndCategory"] as? NSArray {
                    catObjectList = catObjectList1
                }
                
                print(catObjectList)
                
                for i in 0..<catObjectList.count {
                    let catDict = catObjectList[i] as! NSDictionary
                    let categoryModel = CategoryModel()
                    categoryModel.isSelected = true
                    categoryModel.catID = catDict.object(forKey: "cat_id") as! String
                    categoryModel.catName = (catDict.object(forKey: "Category") as! NSDictionary).object(forKey: "cat_name") as! String
                    gigDetails.categoryList.add(categoryModel as CategoryModel)
                    print(categoryModel.catID)
                    print(categoryModel.catName)
                }
                
                let calenderList = firstObject["GigPostAndCalender"] as! NSArray
                print(calenderList)
                for i in 0..<calenderList.count {
                    let itemDict = calenderList[i] as! NSDictionary
                    let calenderModel = CalenderObject()
                    
                    if let calenderId = itemDict["gigpost_calender_id"] as? String {
                        calenderModel.calenderId  = calenderId
                    }
                    
                    
                    if( !(itemDict["gigpost_calender_id"] is NSNull))
                    {
                        let stringDate = Commons.changeGigDateFormat(dateFrom: itemDict["date"] as! String) as String
                        
                        calenderModel.calenderDate  = stringDate
//                        
//                        print(calenderModel.calenderId)
//                        print(calenderModel.calenderDate)
//                        print(itemDict["date"] ?? "No date")
                    }

                    gigDetails.calenderList.add(calenderModel as CalenderObject)
                   
                }
                
                
                
                if( !(locationInfo["lat"] is NSNull))
                {
                    if let lat = locationInfo["lat"] as? String {
                        gigDetails.lat = lat
                    }
                }
                
                if let long = locationInfo["long"] as? String {
                    gigDetails.long = long
                }
                
                if let city = locationInfo["city"] as? String {
                    gigDetails.city = city
                }
                
                if let state =  locationInfo["state"] as? String {
                    gigDetails.state = state
                }
                
                if let country = locationInfo["country"] as? String {
                    gigDetails.country  = country
                }
                
                if let location_String = locationInfo["location_string"] as? String {
                    gigDetails.location_string = location_String
                }
                

                // fetch Gig Image array....
                let gigImageList = firstObject["GigPostAndImage"] as! NSArray
                print(gigImageList)
                for i in 0..<gigImageList.count {
                    let itemDict = gigImageList[i] as! NSDictionary
                    let gigImageModel = GigImageObject()
                    
                    if let gig_post_id = itemDict["gig_post_id"] as? String {
                        gigImageModel.gig_post_id  = gig_post_id
                    }
                    
                    if let gigpost_image_id = itemDict["gigpost_image_id"] as? String {
                        gigImageModel.gigpost_image_id  = gigpost_image_id
                    }

                    
                    if let image = itemDict["image"] as? String {
                        if image.contains("default.jpg") {
                            gigDetails.gigImage = String (Constants.PROFILEBASEURL) + image
                        }
                        gigImageModel.gigpost_image_url  = String (Constants.PROFILEBASEURL) + image
                        
                    }
                    
                    gigDetails.gigImageList.add(gigImageModel as GigImageObject)
                    
                }
                gigDetails.distance = String(distance)
                listOfGigs.add(gigDetails)
                
            }
            if (!mLongitutde.isEqual("") && !mLatitude.isEqual("")) {
                //  let custom_lat_long = "\(mLatitude)" + "," + "\(mLongitutde)"
                self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude:Double(mLatitude)!, longitude: Double(mLongitutde)!))
                drawMarkersOnMap()
                self.gigListTableView.reloadData()
            }else {
                //            getCurrentLocation()
                self.initialization()
            }
            
        }
    }
//    
//    fileprivate func parseSignUpResponse(_ response:String) {
//        let dict = Commons.convertToDictionary(text: response)
//        let code = dict?["code"] as! Int
//        self.hideProgressLoader()
//        print(code)
//        
//        if code == 201 {
//            Commons.showAlert(dict?["msg"] as! String, VC: self)
//        }
//        if code == 401 {
//            
//            Commons.showAlert(dict?["msg"] as! String, VC: self)
//        }
//        if code == 400 {
//            Commons.showAlert(dict?["msg"] as! String, VC: self)
//        }
//        
//        if(code == 200)
//        {
//            listOfGigs.removeAllObjects()
//            let msgArray = dict?["msg"] as! NSArray
//            print(msgArray)
//            
//            for i in 0..<msgArray.count {
//                let gigDetails = SellerDetail()
//                let firstObject = msgArray[i] as! NSDictionary
//                let userInfo = firstObject["UserInfo"] as! NSDictionary
//                let user = firstObject["User"] as! NSDictionary
//                //let gigInfo = firstObject["GigPost"] as! NSDictionary
//                let locationInfo = firstObject["UserLocation"] as! NSDictionary
//                let distance = firstObject["Distance"] as! Int
//                gigDetails.userId = userInfo["user_id"] as! String
//                gigDetails.email = user["email"] as! String
//                gigDetails.first_name = userInfo["first_name"] as! String
//                gigDetails.last_name = userInfo["last_name"] as! String
//                gigDetails.phone_no = userInfo["phone_no"] as! String
//                gigDetails.profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
//                gigDetails.registration_date = Commons.changeDateFormat(dateFrom: userInfo["registration_date"] as! String)
////                gigDetails.gig_post_id = gigInfo["gig_post_id"] as! String
////                gigDetails.gig_user_id = gigInfo["user_id"] as! String
////                gigDetails.gig_description = gigInfo["description"] as! String
////                gigDetails.deadline = Commons.changeDateFormat(dateFrom: gigInfo["deadline"] as! String)
////                gigDetails.pay = gigInfo["pay"] as! String
////                gigDetails.type_of_payment = gigInfo["type_of_payment"] as! String
//                let catObjectList = firstObject["UserCategory"] as! NSArray
//                print(catObjectList)
//                var categoryModel = CategoryModel()
//                for i in 0..<catObjectList.count {
//                    let firstObject = catObjectList[i] as! NSDictionary
//                    var objectval = NSDictionary()
//                    if( !(firstObject["Category"] is NSNull))
//                    {
//                        objectval = firstObject["Category"] as! NSDictionary
//                    }
//                    categoryModel = CategoryModel()
//                    if( !(firstObject["cat_id"] is NSNull))
//                    {
//                        categoryModel.catID = firstObject["cat_id"] as! String
//                    }
//                    if( !(objectval["cat_name"] is NSNull))
//                    {
//                        categoryModel.catName = objectval["cat_name"] as! String
//                    }
//                    categoryModel.isSelected = false
//                    gigDetails.categoryList.add(categoryModel as CategoryModel)
//                    print(categoryModel.catID)
//                    print(categoryModel.catName)
//                }
//
//                
//                
//                if( !(locationInfo["lat"] is NSNull))
//                {
//                    gigDetails.lat = locationInfo["lat"] as! String
//                }
//                if(!(locationInfo["long"] is NSNull))
//                {
//                    gigDetails.long = locationInfo["long"] as! String
//                }
//                if( !(locationInfo["city"] is NSNull))
//                {
//                    gigDetails.city = locationInfo["city"] as! String
//                }
//                if( !(locationInfo["state"] is NSNull))
//                {
//                    gigDetails.state = locationInfo["state"] as! String
//                }
//                if( !(locationInfo["country"] is NSNull))
//                {
//                    gigDetails.country = locationInfo["country"] as! String
//                }
//                if( !(locationInfo["location_string"] is NSNull))
//                {
//                    gigDetails.location_string = locationInfo["location_string"] as! String
//                }
//                
//               gigDetails.distance = String(distance)
//                listOfGigs.add(gigDetails)
//                
//            }
//            if (!mLongitutde.isEqual("") && !mLatitude.isEqual("")) {
//                //  let custom_lat_long = "\(mLatitude)" + "," + "\(mLongitutde)"
//                self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude:Double(mLatitude)!, longitude: Double(mLongitutde)!))
//                drawMarkersOnMap()
//                self.tableView.reloadData()
//            }else {
//                //            getCurrentLocation()
//                self.initialization()
//            }
//            
//        }
//    }
    //MARK:- Get Notification Count Api Call
    func GetNotificationAPICall()
    {
        
        let params = ["user_id":UserModel.getUserData().userId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.GETUNREADNOTIFICATIONSAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseNotificationResponse(result as String)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseNotificationResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
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
           
            let count = dict?["msg"] as! Int
            if(count==0)
            {
                self.tabBarController?.tabBar.items?[4].badgeValue = nil
  
            }else{
                self.tabBarController?.tabBar.items?[4].badgeValue = String(count)
            }
        }
    }

    func showtableView() {
        self.gigListTableView.isHidden=false
        self.mapView.isHidden=true
        searchBar.resignFirstResponder()
        self.gigDetailView.isHidden = true
        self.trunOnLocationView.isHidden = true
        self.tableView.reloadData()
    }
    
    func hideTableView() {
        self.gigListTableView.isHidden=true
        self.trunOnLocationView.isHidden = true
        self.mapView.isHidden=false
    }

    func showLocationView() {
        self.gigListTableView.isHidden=true
        self.trunOnLocationView.isHidden = false
        self.mapView.isHidden=true
        searchBar.resignFirstResponder()
    }
    
    func hideLocationView() {
        self.gigListTableView.isHidden=true
        self.trunOnLocationView.isHidden = true
        self.mapView.isHidden=false
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue) {

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(1)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(2)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if (searchBar.text?.characters.count)!>0{
            
            if(Commons.connectedToNetwork()){
                self.MakeAPICall()
            }
            else{
                Commons.showAlert("Please check your connection", VC: self)
            }
        }
        searchBar.resignFirstResponder()
    }
    
    func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
     
        searchBar.resignFirstResponder()
    }
    
    @IBAction func hideSearchKeyboard(_ sender:Any) {
        searchBar.text=""
        if(Commons.connectedToNetwork()) {
            self.MakeAPICall()
        }else {
            Commons.showAlert("Please check your connection", VC: self)
        }
        searchBar.resignFirstResponder()
    }
}


//MARK:- extension CLLocationManagerDelegate
extension SellerMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        //        if status == .notDetermined {
        //            locationManager.startUpdatingLocation()
        //        }
        //        if status == .denied {
        //            locationManager.startUpdatingLocation()
        //        }
        //
        //        if status == .restricted {
        //            locationManager.startUpdatingLocation()
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 2000, bearing: 0, viewingAngle: 0)
            //let lat = location.coordinate.latitude
            //let long = location.coordinate.longitude
//            let location = "\(lat),\(long)"
//            print(location)
            self.updateLocation(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
    
        if (scrollView.contentOffset.y == 0){
        
            if(Commons.connectedToNetwork()){
                self.MakeAPICall()
            }
            else{
                Commons.showAlert("Please check your connection", VC: self)
            }
        }
    }
    
    
    func GetAllConversationsAPICall(_ markerDetail: LatLongDetail)
    {
        
        let params = ["user_id":UserModel.getUserData().userId, "sender_id":UserModel.getUserData().userId,"receiver_id":markerDetail.userId] as [String : Any]
        print(params)
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.getConversationAPIURL, parameters: params, success:
            {
                requestOperation, response in
                
                let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
                
                print(result)
                self.parseConversationsResponse(result as String, markerDetail: markerDetail as LatLongDetail)
        },
                     failure:
            {
                requestOperation, error in
                print(error.localizedDescription)
        })
        
    }
    fileprivate func parseConversationsResponse(_ response:String, markerDetail: LatLongDetail) {
        let dict = Commons.convertToDictionary(text: response)
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
            listOfConversation.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            for i in 0..<msgArray.count {
                let chatDetail = ConversationModel()
                let firstObject = msgArray[i] as! NSDictionary
                let chat = firstObject["Chat"] as! NSDictionary
                let user = firstObject["UserInfo"] as! NSDictionary
                chatDetail.chatId = chat["id"] as! String
                chatDetail.sender_id = chat["sender_id"] as! String
                chatDetail.receiver_id = chat["receiver_id"] as! String
                chatDetail.message = chat["message"] as! String
                chatDetail.conversation_id = chat["conversation_id"] as! String
                chatDetail.user_id = user["user_id"] as! String
                chatDetail.first_name = user["first_name"] as! String
                chatDetail.last_name = user["last_name"] as! String
                chatDetail.profile_img = user["profile_img"] as! String
                chatDetail.datetime = chat["datetime"] as! String
                listOfConversation.add(chatDetail)
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "conversationVC") as! ChatViewController
            nextViewController.conversationDetail.removeAllObjects()
            nextViewController.otherUserId = markerDetail.userId
            nextViewController.otherUserName = markerDetail.first_name + " " + markerDetail.last_name
            nextViewController.otherProfileImg = markerDetail.profile_img
            nextViewController.conversationDetail = listOfConversation
            self.present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    func getCategoriesAPICall()
    {
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.get(Constants.GETCATEGORIESAPIURL, parameters: nil, progress: nil, success: {  requestOperation, response in
            
            let result = NSString(data: (response as! NSData) as Data, encoding: String.Encoding.utf8.rawValue)!
            self.showProgressLoader()
            print(result)
            self.parseCategoriesResponse(result as String)
        },
                    failure:
            {
                requestOperation, error in
                self.hideProgressLoader()
                print(error.localizedDescription)
        })
 
    }
    
    fileprivate func parseCategoriesResponse(_ response:String) {
        let dict = Commons.convertToDictionary(text: response)
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
            
            let msgArray = dict?["msg"] as! NSArray
            for i in 0..<msgArray.count {
                let firstObject = msgArray[i] as! NSDictionary
                let objectval = firstObject["Category"] as! NSDictionary
                let catName =  objectval["cat_name"] as! String
                let catId =  objectval["cat_id"] as! String

                if !categoryNameArray.contains(catName) {
                    let categoryDict = NSMutableDictionary()
                    categoryDict.setValue(catName, forKey: "cat_Name")
                    categoryDict.setValue(catId, forKey: "cat_Id")
                    self.allCategoryList.append(categoryDict)
                    self.categoryNameArray.append(catName)
                }
            }
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.categoryNameArray = categoryNameArray
        }
    }

    // MARK : Perform segue to select date from calender
    func calenderTapped() {
        self.filterView.resignFirstResponder()
        self.filterView.endEditing(true)
        self.filterView.layoutSubviews()
        self.performSegue(withIdentifier: "availabilityCalenderVC", sender: self)
    }
    
    // MARK: Delegate method to get dates
    func sendDatesArrayToPreviousVC(dates: Array<String>){
        let datesArray = dates
        var dateString = ""
        for date in dates {
            if dates.count > 1 {
                if dateString.characters.count > 1 {
                    dateString = dateString + ", "
                }
            }
            dateString =  dateString.appending(date)
        }
        filterView.dateString = dateString
    }
    
    
    // MARK: Filter for Gigs - Ashok
    
    func filterDoneTapped(notification: Notification)  {
        
        let userInfo = notification.userInfo
        print(listOfGigs)
        var category_name = ""
        var category_id = ""
        var distance = ""
        var priceMax = ""
        var priceMin = ""
        var date = ""
        var price_order = ""
        
        if let sort = userInfo?["sort"] as? String {
            
            if sort != "" {
                if sort == "Lowest to Highest Price" {
                    price_order = "ASC"
                } else if sort == "Highest to Lowest Price"{
                    price_order = "DESC"
                } else {
                    price_order = sort
                }
            } else {
                price_order = "ASC"
            }
        }
        
        if let category = userInfo?["category"] as? String {
            category_name  = category
        }
        
        if var distance1 = userInfo?["distance"] as? String {
            if distance1 == "" {
                distance1 = "1000"
            }
            distance = distance1.appending("0000000")
        }

        if let minPrice = userInfo?["minPrice"] as? String {
            if minPrice == "" {
                priceMin = "1"
            } else {
                priceMin = minPrice
            }
        }

        if let maxPrice = userInfo?["maxPrice"] as? String {
            if maxPrice == "" {
                priceMax = "2000"
            } else {
                priceMax = maxPrice
            }

        }

        if let date1 = userInfo?["date"] as? String {
            date = date1
        }

        for category in allCategoryList {
            
            if let categoryName =  category.value(forKey: "cat_Name") as? String {
                if categoryName == category_name {
                    category_id =   (category.value(forKey: "cat_Id") as? String)!
                }
            }
        }
        
        let parameters = ["user_id" : UserModel.getUserData().userId ,"lat":mLatitude,"long":mLongitutde, "price_order": price_order, "price_min": priceMin, "price_max": priceMax, "distance": distance, "date": "" , "cat_id": category_id]
        
        let post_url = Constants.filterGigPosts
        
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(post_url, parameters: parameters, success:
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        self.resignFirstResponder()
        self.view.endEditing(true)
    }
}
