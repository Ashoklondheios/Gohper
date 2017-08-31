//
//  PostGigViewController.swift
//  Gopher
//
//  Created by User on 3/2/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMapsCore
import GooglePlaces
import GoogleMaps
import AFNetworking
import SDWebImage

class PostGigViewController: UIViewController {

    // MARK: IBOutlet Properties
    
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
    
    // MARK: Variables
    let locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient.shared()
    var mLongitutde = ""
    var mLatitude = ""
    var profilePicUrl = ""
    var holderImage:UIImage?
    var deadLine = ""
    var amount = ""
    
    // MARK: Life Cycle Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if (!mLongitutde.isEqual("") && !mLatitude.isEqual("")) {
          //  let custom_lat_long = "\(mLatitude)" + "," + "\(mLongitutde)"
            self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude:Double(mLatitude)!, longitude: Double(mLongitutde)!))
            drawMarkersOnMap()
        }else {
            //            getCurrentLocation()
            self.initialization()
        }
    
        
        //profilePicImg.sd_setImage(with: URL(string: profilePicUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        profilePicImg.image=holderImage
        postGigDeadline.text = deadLine
        postGigPaymentAmount.text = "$ " + amount 
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBAction Methods
    @IBAction func doneButton(_ sender: Any) {
       // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       // let nextViewController = storyBoard.instantiateViewController(withIdentifier: "rootController") as! RootViewController
       // self.navigationController?.pushViewController(nextViewController, animated:true)
       //_ = self.navigationController?.popToRootViewController(animated: true)
        
        self.performSegue(withIdentifier: "goToRoot", sender: self)
    }
    
    deinit {
        mapView = nil
    }
    
    //MARK:- initialization current location
    private func initialization() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = 45
        locationManager.distanceFilter = 100
        mapView.isMyLocationEnabled = true
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
            Commons.showAlert("Network Error", VC: self)
        }
    }
    
    //MARK:- Draw Markers
    fileprivate func drawMarkersOnMap() {
        
        var bounds = GMSCoordinateBounds()
        
       // for gigPost in self.listOfGigs {
           
            let location = CLLocationCoordinate2D(latitude: Double(mLatitude)!, longitude: Double(mLongitutde)!)
            let marker = GMSMarker(position: location)
            marker.appearAnimation = GMSMarkerAnimation.pop
            mapView.camera = GMSCameraPosition.camera(withLatitude: Double(mLatitude)!, longitude: Double(mLongitutde)!, zoom:15)
            marker.zIndex = 1
            marker.map = mapView
            bounds = bounds.includingCoordinate(marker.position)
    
    }
    
//    fileprivate func updateLocation(location:String) {
//        let params = ["user_id": User.getCurrentUser()!.userId,"location":location] as [String : Any]
//        workHomeLoader.tryGetLocation(parameters: params as [String : AnyObject]?, successBlock: {
//            
//        }, failureBlock: { (error) in
//            print(error!.localizedDescription)
//        })
//        
//    }
    
    //MARK:- Public Methods
    
    func timePrinter() {
        locationManager.startUpdatingLocation()
    }
    
    
}


//MARK:- extension CLLocationManagerDelegate
extension PostGigViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        if status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 2000, bearing: 0, viewingAngle: 0)
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let location = "\(lat),\(long)"
            print(location)
            locationManager.stopUpdatingLocation()
        }
    }
}
