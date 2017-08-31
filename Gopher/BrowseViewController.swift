//
//  BrowseViewController.swift
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
class BrowseViewController: BaseViewController,GMSMapViewDelegate, UITableViewDelegate,UITableViewDataSource {
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var indicators: UIActivityIndicatorView!
    @IBOutlet weak var gigDetailView: UIView!
    @IBOutlet weak var postGigStar5: UIImageView!
    @IBOutlet weak var postGigStar4: UIImageView!
    @IBOutlet weak var postGigStar3: UIImageView!
    @IBOutlet weak var postGigStar2: UIImageView!
    @IBOutlet weak var postGigStar1: UIImageView!
    @IBOutlet weak var postGigPaymentAmount: UILabel!
    @IBOutlet weak var postGigTime: UILabel!
    @IBOutlet weak var postGigReviews: UILabel!
    @IBOutlet weak var postGigDeadline: UILabel!
    @IBOutlet weak var postGigPersonName: UILabel!
    @IBOutlet weak var postGigDistance: UILabel!
    @IBOutlet weak var postGigTaskType: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var gigBtnContact: UIButton!
    @IBOutlet weak var gigBtnSendContract: UIButton!
    @IBOutlet weak var trunOnLocationView: UIView!
    @IBOutlet weak var trunOnLocationImgView: UIImageView!
    @IBOutlet weak var trunOnLocationBtnOutlet: UIButton!
    
    // MARK: IBOutlet Properties For TableView

    @IBOutlet weak var gigListTableView: UITableView!
    
    // MARK: Variables
    let locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient.shared()
    var mLongitutde = "74.3572"
    var mLatitude = "31.5546"
    var deadLine = ""
    var amount = ""
    var listOfGigs = NSMutableArray()
    var listOfConversation = NSMutableArray()
    var tableView = UITableView()
    var markerDetails = LatLongDetail()
    // MARK: View Life Cycle
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
        NotificationCenter.default.addObserver(self, selector:#selector(BrowseViewController.appIsComingForeground), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        if Commons.connectedToNetwork() {
            self.MakeAPICall()

        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
        //self.tabBarController?.tabBar.items?[4].badgeValue = "1"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.segmentedControl.selectedSegmentIndex = 0
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if Commons.connectedToNetwork() {
            self.GetNotificationAPICall()

        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
        self.tabBarController?.tabBar.isHidden = false

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfGigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gigCell", for: indexPath)as! GigListTableViewCell
        let markerDetails = listOfGigs[indexPath.row] as! LatLongDetail
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
        
        
        
        if(markerDetails.type_of_payment.isEqual("1"))
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
            cell.gigSendContractBtn.isHidden = true
        }
        else
        {
            cell.gigContact.isHidden = false
            cell.gigSendContractBtn.isHidden = false
        }
        cell.gigContact.backgroundColor = .clear
        cell.gigContact.layer.cornerRadius = 5
        cell.gigContact.layer.borderWidth = 1
        cell.gigContact.layer.borderColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF).cgColor
        cell.gigContact.tag = indexPath.row + 100
        cell.gigContact.addTarget(self, action: #selector(contactButtonTapped(_:)), for: .touchUpInside)
        
        cell.gigSendContractBtn.backgroundColor = .clear
        cell.gigSendContractBtn.layer.cornerRadius = 5
        cell.gigSendContractBtn.layer.borderWidth = 1
        cell.gigSendContractBtn.layer.borderColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF).cgColor
        
        cell.gigSendContractBtn.tag = indexPath.row
        cell.gigSendContractBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
  
    

    
    // MARK: IBAction Methods
    
    @IBAction func newPost(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "newPostViewC") as! NewPostVC
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    @IBAction func turnOnLocationBtn(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
    }
    
    func gigDetailViewTap(tapGestureRecognizer: UITapGestureRecognizer)
    {
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
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func contactButtonTapped(_ sender : UIButton){
        let buttonRow = sender.tag - 100
       
        let markerDetails = listOfGigs[buttonRow] as! LatLongDetail
        if Commons.connectedToNetwork() {
            self.GetAllConversationsAPICall(markerDetails)
        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
        
    }
    
    func buttonTapped(_ sender : UIButton){
        let buttonRow = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let markerDetails = listOfGigs[buttonRow] as! LatLongDetail
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "previewSendContractVC") as! PreviewSendContractViewController
        
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
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "publicProfileVC") as! PublicProfilePostsController
        nextViewController.profileId = markerDetails.userId
        nextViewController.profilePicUrl = markerDetails.profile_img
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
        // Your action
    }
    @IBAction func GetAllConversationsAPICallGetAllConversationsAPICall(_ sender: Any) {
        if Commons.connectedToNetwork() {
            self.GetAllConversationsAPICall(markerDetails)
        }
        else {
            Commons.showAlert("Network Error", VC: self)
        }
    }
    
    @IBAction func applyBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "previewSendContractVC") as! PreviewSendContractViewController
        
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
        self.navigationController?.pushViewController(nextViewController, animated:true) 
    }
   

    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.hideTableView()
    
        case 1:
            self.showtableView()
        default:
            break;
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
        postGigPaymentAmount.text = "$ " + markerDetails.pay
        postGigTime.text = "Deadline: " + markerDetails.deadline
        postGigReviews.text = "3.84 out of 4 based on 79 reviews"
        postGigDeadline.text = ""
        postGigPersonName.text = markerDetails.first_name + " " + markerDetails.last_name
        postGigDistance.text = markerDetails.distance + "miles away"
        if(markerDetails.categoryList.count>0 && markerDetails.categoryList.count<=1)
        {
            let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
            postGigTaskType.text = catObj1.catName
        }
        else if(markerDetails.categoryList.count>1)
        {
            let catObj1 = markerDetails.categoryList.object(at: 0) as! CategoryModel
            let catObj2 = markerDetails.categoryList.object(at: 1) as! CategoryModel
            postGigTaskType.text = catObj1.catName + "," + catObj2.catName
        }
        
        
        if(UserModel.getUserData().userId.isEqual(markerDetails.userId))
        {
            gigBtnContact.isHidden = true
            gigBtnSendContract.isHidden = true
        }
        else
        {
            gigBtnContact.isHidden = false
            gigBtnSendContract.isHidden = false
        }
//        if(markerDetails.type_of_payment.isEqual("0"))
//        {
//            postGigTaskType.text = "Flat"
//
//        }
//        else{
//            postGigTaskType.text = "Hourly"
//
//        }
        profilePicImg.sd_setImage(with: URL(string: markerDetails.profile_img), placeholderImage: UIImage(named: "placeholder.png"))
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
        //self.updateLocation(locationManager.location!)
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
                    marker.icon = UIImage(named: "taskpin")!.withRenderingMode(.alwaysTemplate)
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
        
        let params = ["lat":mLatitude,"long":mLongitutde] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.GETALLGIGGSAPIURL, parameters: params, success:
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
            listOfGigs.removeAllObjects()
            let msgArray = dict?["msg"] as! NSArray
            print(msgArray)
            
            for i in 0..<msgArray.count {
                var gigDetails = LatLongDetail()
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
                if let deadline = gigInfo["deadline"] {
                    gigDetails.deadline = deadline as! String
                }
                gigDetails.pay = gigInfo["pay"] as! String
                gigDetails.type_of_payment = gigInfo["type_of_payment"] as! String
                let catObjectList = firstObject["GigPostAndCategory"] as! NSArray
                print(catObjectList)
                let categoryModel = CategoryModel()
                for i in 0..<catObjectList.count {
                    _ = catObjectList[i] as! NSDictionary
                    _ = NSDictionary()
                    categoryModel.isSelected = false
                    gigDetails.categoryList.add(categoryModel as CategoryModel)
                    print(categoryModel.catID)
                    print(categoryModel.catName)
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
                self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude:Double(mLatitude)!, longitude: Double(mLongitutde)!))
                drawMarkersOnMap()
                self.tableView.reloadData()
            }else {
                //            getCurrentLocation()
                self.initialization()
            }
            
        }
    }
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
        self.gigListTableView.isHidden=false
        self.trunOnLocationView.isHidden = true
        self.mapView.isHidden=true
        self.gigDetailView.isHidden = true
        self.tableView.reloadData()
    }
    
    func hideTableView()
    {
        self.gigListTableView.isHidden=true
        self.trunOnLocationView.isHidden = true
        self.mapView.isHidden=false
    }
    
    func showLocationView()
    {
        self.gigListTableView.isHidden=true
        self.trunOnLocationView.isHidden = false
        self.mapView.isHidden=true
    }
    
    func hideLocationView()
    {
        self.gigListTableView.isHidden=true
        self.trunOnLocationView.isHidden = true
        self.mapView.isHidden=false
    }
}


//MARK:- extension CLLocationManagerDelegate
extension BrowseViewController: CLLocationManagerDelegate {
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
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
//            let location = "\(lat),\(long)"
//            print(location)
            self.updateLocation(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
 
    //MARK:- Get Notification Count Api Call
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
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        
    }
    
}
