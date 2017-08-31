//
//  SeeMoreController.swift
//  Gopher
//
//  Created by User on 7/18/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMapsCore
import GooglePlaces
import GoogleMaps
import AFNetworking
import SDWebImage

class SeeMoreController: BaseViewController, GMSMapViewDelegate, UITableViewDelegate,UITableViewDataSource {
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var navTitle: UILabel!
////    @IBOutlet weak var gigDetailView: UIView!
////    @IBOutlet weak var postGigStar5: UIImageView!
////    @IBOutlet weak var postGigStar4: UIImageView!
////    @IBOutlet weak var postGigStar3: UIImageView!
////    @IBOutlet weak var postGigStar2: UIImageView!
////    @IBOutlet weak var postGigStar1: UIImageView!
////    @IBOutlet weak var postGigPaymentAmount: UILabel!
////    @IBOutlet weak var postGigTime: UILabel!
////    @IBOutlet weak var postGigReviews: UILabel!
////    @IBOutlet weak var postGigDeadline: UILabel!
////    @IBOutlet weak var postGigPersonName: UILabel!
////    @IBOutlet weak var postGigDistance: UILabel!
////    @IBOutlet weak var postGigTaskType: UILabel!
//    @IBOutlet weak var mapView: GMSMapView!
//    @IBOutlet weak var profilePicImg: UIImageView!
//    @IBOutlet weak var segmentedControl: UISegmentedControl!
//    @IBOutlet weak var gigBtnContact: UIButton!
//    @IBOutlet weak var trunOnLocationView: UIView!
//    @IBOutlet weak var trunOnLocationImgView: UIImageView!
//    @IBOutlet weak var trunOnLocationBtnOutlet: UIButton!
    
    @IBOutlet weak var filterView: V2DropDown!
    //    @IBOutlet weak var trunOnLocationView: UIView!
    //    @IBOutlet weak var trunOnLocationImgView: UIImageView!
    //    @IBOutlet weak var trunOnLocationBtnOutlet: UIButton!
    // MARK: IBOutlet Properties For TableView
    
    @IBOutlet weak var gigListTableView: UITableView!
    
    // MARK: Variables
    let locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient.shared()
    var mLongitutde = ""
    var mLatitude = ""
    var deadLine = ""
    var amount = ""
    var listOfGigs = NSMutableArray()
    var listOfConversation = NSMutableArray()
    var tableView = UITableView()
    var markerDetails = LatLongDetail()
    var selected_row=0
    var mode="0" as String!
    var currentUserId="0"
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideProgressLoader()
        self.hideTableView()
        self.hideLocationView()
        
        // self.gigBtnSendContract.isHidden = true
        self.gigListTableView.isHidden=false
        
        
        // Do any additional setup after loading the view.
        self.initialization()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector:#selector(BrowseViewController.appIsComingForeground), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.gigListTableView.register(RentalListTableViewCell.self, forCellReuseIdentifier: "RentalListCell")
        //self.tabBarController?.tabBar.items?[4].badgeValue = "1"
        self.gigListTableView.register(UINib(nibName: "RentalListTableViewCell", bundle: nil), forCellReuseIdentifier: "RentalListCell")
        //  let view11 = UIView(frame: CGRect(x: 200, y: 70, width: 214, height: 250))
        // view11.backgroundColor = UIColor.red
        
        filterView.style = .DropDownDefault
        
        filterView.optionsArray = ["Sort", "Availability Calender", "Categpry", "Distance", "Price"]
        filterView.detailsArray = ["Best Match", "", "All", "5 Miles", "$2000"]
//        filterView.optionsArray = ["Sort", "Availability Calender", "Categpry", "Distance", "brand", "Condition","Price", "Pickup/Delivery", "Item Loaction"]
//        filterView.detailsArray = ["Best Match", "", "All", "5 Miles", "All", "Any", "Any", "Any", ""]
        filterView.isHidden = true
        
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
        
        
        let intMode=Int(mode!) as Int! ?? 0
        
        switch intMode {
        case 1:
            navTitle.text="Rental Posts"
        case 2:
            navTitle.text="Active Posts"
        case 3:
            navTitle.text="Previous Posts"
        default:
            navTitle.text="Active Posts"
        }
        
    }
    func appIsComingForeground(){
        
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
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        if self.filterView.isHidden {
            self.filterView.isHidden = false
        } else {
            self.filterView.isHidden = true
        }
        
        //        if sender.tag == 0 {
        //            sender.tag = 1
        //            self.filterView.isHidden = false
        //        } else {
        //            sender.tag = 0
        //            self.filterView.isHidden = true
        //        }
        
        
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
    
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        //  self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfGigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RentalListCell", for: indexPath)as! RentalListTableViewCell
        
        let markerDetails = listOfGigs[indexPath.row] as! LatLongDetail
        
        if(!(markerDetails.gigImage.isEqual("")))
        {
            cell.gigImage.sd_setImage(with: URL(string: markerDetails.gigImage))
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
            
            
            
        }
        
        cell.rentButton.tag=indexPath.row
        cell.contactButton.tag=indexPath.row
        
        // cell.gigProfileImg.sd_setImage(with: URL(string: markerDetails.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
        
        //cell.gigProfileImg.tag = indexPath.row + 10
        //cell.gigProfileImg.addTarget(self, action: #selector(buttonProfileTapped(_:)), for: .touchUpInside)
        
        
        
        if(markerDetails.type_of_payment.isEqual("1"))
        {
            cell.hourlyRatesLabel.text = "$ " + markerDetails.pay +  " Flat"
            
        }
        else
        {
            cell.hourlyRatesLabel.text = "$ " + markerDetails.pay + " Hourly"
            
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
        
        self.present(viewController, animated: true, completion: nil)
        
        
        
        
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
            
            destinationVC.selectedDatesArray = selectedGig.calenderList
            destinationVC.arrayOfDates = selectedDates
            destinationVC.imageUrl = selectedGig.gigImage
            destinationVC.gigTitle = selectedGig.gigTitle
            destinationVC.gigDetail = selectedGig
            destinationVC.paymentType=selectedGig.type_of_payment
            
            
            //destinationVC.datesDelegate = self
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
        nextViewController.profileId = markerDetails.userId
        nextViewController.profilePicUrl = markerDetails.profile_img
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated: true, completion: nil)
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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
        let markerDetails = listOfGigs[buttonRow] as! LatLongDetail
        nextViewController.profileId = markerDetails.userId
        nextViewController.profilePicUrl = markerDetails.profile_img
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        self.present(nextViewController, animated: true, completion: nil)
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
        nextViewController.profileId = markerDetails.userId
        nextViewController.profilePicUrl = markerDetails.profile_img
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        
        self.present(nextViewController, animated: true, completion: nil)
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
        //self.sideMenuViewController!.presentLeftMenuViewController()
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
        //_=self.navigationController?.popViewController(animated: true)
    }
    @IBAction func menuBtn(_ sender: Any) {
        //self.sideMenuViewController!.presentLeftMenuViewController()
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
        //_=self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: Mapview Methods
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // reset custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    
    
    
    
    
    // let the custom infowindow follows the camera
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
    }
    deinit {
        
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
        //mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        if let location = locationManager.location {
            self.updateLocation(location)
        }
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
//    fileprivate func drawMarkersOnMap() {
//        
//        var bounds = GMSCoordinateBounds()
//        for gigPost in self.listOfGigs {
//            
//            let latlong =  gigPost as! LatLongDetail
//            print(latlong.lat)
//            if(!(latlong.lat.isEqual("")) && !(latlong.long.isEqual("")))
//            {
//                let location = CLLocationCoordinate2D(latitude: Double(latlong.lat)!, longitude: Double(latlong.long)!)
//                let marker = GMSMarker(position: location)
//                marker.appearAnimation = GMSMarkerAnimation.pop
//                if(!(latlong.lat.isEqual("0")) && !(latlong.long.isEqual("0")))
//                {
//                    mapView.camera = GMSCameraPosition.camera(withLatitude: Double(latlong.lat)!, longitude: Double(latlong.long)!, zoom:1)
//                    marker.zIndex = 1
//                    
//                    //changing the tint color of the image
//                    //markerView.tintColor = UIColorFromRGB(rgbValue: 0x55A0BF)
//                    marker.icon = UIImage(named: "mappinmen")!.withRenderingMode(.alwaysTemplate)
//                    marker.title = latlong.pay
//                    marker.map = mapView
//                    marker.userData = gigPost
//                    bounds = bounds.includingCoordinate(marker.position)
//                    // mapView.selectAll(marker)
//                    
//                    
//                    
//                }
//            }
//        }
//    }
    
    //MARK:- Public Methods
    
    func timePrinter() {
        locationManager.startUpdatingLocation()
    }
    
    //MARK:- Get All Gigs Post Api Call
    func MakeAPICall()
    {
        
        let params = ["user_id" : currentUserId ,"lat":mLatitude,"long":mLongitutde] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        var apiString=Constants.GETALLGIGGSAPIURL
        
        if mode == "1"{
        
            apiString=Constants.ACTIVEGIGPOSTS
        
        }else if mode == "2"{
        
            apiString=Constants.ACTIVEGIGPOSTS
        
        }else if mode == "3"{
        
            apiString=Constants.DEACTIVEGIGPOSTS
        
        }
        
        manager.post(apiString, parameters: params, success:
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
                let locationInfo = firstObject["Location"] as! NSDictionary
                let distance = firstObject["Distance"] as! Int
                gigDetails.userId = userInfo["user_id"] as! String
                gigDetails.email = user["email"] as! String
                gigDetails.first_name = userInfo["first_name"] as! String
                gigDetails.last_name = userInfo["last_name"] as! String
                gigDetails.phone_no = userInfo["phone_no"] as! String
                if (userInfo["profile_img"] as! String).range(of:"http") != nil{
                    gigDetails.profile_img = String (userInfo["profile_img"] as! String)
                }else{
                    gigDetails.profile_img = String (Constants.PROFILEBASEURL) + String (userInfo["profile_img"] as! String)
                }
                
                gigDetails.registration_date = Commons.changeDateFormat(dateFrom: userInfo["registration_date"] as! String)
                gigDetails.gig_post_id = gigInfo["gig_post_id"] as! String
                gigDetails.gig_user_id = gigInfo["user_id"] as! String
                gigDetails.gig_description = gigInfo["description"] as! String
                gigDetails.pay = gigInfo["pay"] as! String
                
                if( !(gigInfo["title"] is NSNull))
                {
                    gigDetails.gigTitle = gigInfo["title"] as! String
                }
                //gigDetails.gigTitle = gigInfo["title"] as! String
//                if( !(gigInfo["image"] is NSNull))
//                {
//                    gigDetails.gigImage =  String (Constants.PROFILEBASEURL) + String (gigInfo["image"] as! String)
//                    
//                }
                
                if let imageName = gigInfo["image"] as? String {
                    gigDetails.gigImage =  String (Constants.PROFILEBASEURL) + imageName
                }
                
                
                if let deadline = gigInfo["deadline"] {
                    gigDetails.deadline = deadline as! String
                }
                gigDetails.pay = gigInfo["pay"] as! String
                gigDetails.type_of_payment = gigInfo["type_of_payment"] as! String
                let catObjectList = firstObject["GigPostAndCategory"] as! NSArray
                print(catObjectList)
                //let categoryModel = CategoryModel()
                for i in 0..<catObjectList.count {
                    let catDict = catObjectList[i] as! NSDictionary
                    let categoryModel = CategoryModel()
                    //_ = NSDictionary()
                    categoryModel.isSelected = true
                    categoryModel.catID = catDict.object(forKey: "cat_id") as! String
                    categoryModel.catName = (catDict.object(forKey: "Category") as! NSDictionary).object(forKey: "cat_name") as! String
                    gigDetails.categoryList.add(categoryModel as CategoryModel)
                    print(categoryModel.catID)
                    print(categoryModel.catName)
                }
                
                let calenderList = firstObject["GigPostAndCalender"] as! NSArray
                print(calenderList)
                //var calenderModel = CalenderObject()
                for i in 0..<calenderList.count {
                    let itemDict = calenderList[i] as! NSDictionary
                    let calenderModel = CalenderObject()
                    
                    if( !(itemDict["gigpost_calender_id"] is NSNull))
                    {
                        calenderModel.calenderId  = itemDict["gigpost_calender_id"] as! String
                    }
                    
                    if( !(itemDict["gigpost_calender_id"] is NSNull))
                    {
                        //calenderModel.calenderDate  = itemDict["date"] as! String
                        
                        let stringDate = Commons.changeGigDateFormat(dateFrom: itemDict["date"] as! String) as String
                        
                        calenderModel.calenderDate  = stringDate
                        
                        print(calenderModel.calenderId)
                        print(calenderModel.calenderDate)
                        print(itemDict["date"] ?? "No date")
                        
                        
                    }
                    
                    //calenderModel.calenderId =
                    gigDetails.calenderList.add(calenderModel as CalenderObject)
                    
                }
                
                
                
                if( !(locationInfo["lat"] is NSNull))
                {
                    gigDetails.lat = locationInfo["lat"] as! String
                }
                if(!(locationInfo["long"] is NSNull))
                {
                    gigDetails.long = locationInfo["long"] as! String
                }
                if( !(locationInfo["city"] is NSNull))
                {
                    gigDetails.city = locationInfo["city"] as! String
                }
                if( !(locationInfo["state"] is NSNull))
                {
                    gigDetails.state = locationInfo["state"] as! String
                }
                if( !(locationInfo["country"] is NSNull))
                {
                    gigDetails.country = locationInfo["country"] as! String
                }
                if( !(locationInfo["location_string"] is NSNull))
                {
                    gigDetails.location_string = locationInfo["location_string"] as! String
                }
                
                gigDetails.distance = String(distance)
                listOfGigs.add(gigDetails)
                
            }
            if (!mLongitutde.isEqual("") && !mLatitude.isEqual("")) {
                //  let custom_lat_long = "\(mLatitude)" + "," + "\(mLongitutde)"
//                self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude:Double(mLatitude)!, longitude: Double(mLongitutde)!))
//                drawMarkersOnMap()
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
            //print(msgArray)
            
            
        }
        
    }
    
    func showtableView()
    {
//        self.gigListTableView.isHidden=false
//        self.mapView.isHidden=true
//        self.gigDetailView.isHidden = true
//        self.trunOnLocationView.isHidden = true
//        
//        self.tableView.reloadData()
    }
    
    func hideTableView()
    {
//        self.gigListTableView.isHidden=true
//        self.trunOnLocationView.isHidden = true
//        
//        self.mapView.isHidden=false
        
    }
    
    func showLocationView()
    {
//        self.gigListTableView.isHidden=true
//        self.trunOnLocationView.isHidden = false
//        self.mapView.isHidden=true
    }
    
    func hideLocationView()
    {
//        self.gigListTableView.isHidden=true
//        self.trunOnLocationView.isHidden = true
//        self.mapView.isHidden=false
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue) {
        
        
    }
    
}


//MARK:- extension CLLocationManagerDelegate
extension SeeMoreController: CLLocationManagerDelegate {
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
            //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 2000, bearing: 0, viewingAngle: 0)
            //let lat = location.coordinate.latitude
            //let long = location.coordinate.longitude
            //            let location = "\(lat),\(long)"
            //            print(location)
            self.updateLocation(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    
    //    func addLocations()
    //    {
    //        var latlong = SellerDetail()
    //        latlong.lat = "31.5546"
    //        latlong.long = "74.3572"
    //        listOfGigs.add(latlong)
    //
    //        latlong = SellerDetail()
    //        latlong.lat = "31.5108"
    //        latlong.long = "74.3450"
    //        listOfGigs.add(latlong)
    //
    //        latlong = SellerDetail()
    //        latlong.lat = "31.5035"
    //        latlong.long = "74.3318"
    //        listOfGigs.add(latlong)
    //
    //    }
    
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if (scrollView.contentOffset.y == 0){
            
            if(Commons.connectedToNetwork())
            {
                
                self.MakeAPICall()
                
            }
            else
            {
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
            //self.navigationController?.pushViewController(nextViewController, animated:true)
            
            self.present(nextViewController, animated: true, completion: nil)
        }
        
    }
    
    
}

