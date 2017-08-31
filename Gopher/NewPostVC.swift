//
//  NewPostVC.swift
//  Gopher
//
//  Created by Ashok Londhe on 23/05/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking
import SWRevealViewController
import CoreLocation
import GoogleMapsCore
import GooglePlaces
import IQKeyboardManagerSwift
import ImagePicker

//import image



class NewPostVC: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, MyProtocol,   UIPickerViewDataSource,UIPickerViewDelegate, AvailabilityCalenderDatesProtocol,DateTimeProtocol,ImagePickerDelegate {

    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var availibilityCalenderHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addTitleTextField: V2Textfield!
    @IBOutlet weak var descriptionTextField: V2Textfield!
    @IBOutlet weak var addCategoryTextField: V2Textfield!
    @IBOutlet weak var addLocationTextField: V2Textfield!
    @IBOutlet weak var addPriceTextField: V2Textfield!
    @IBOutlet weak var addAvailibityCalenderTextFiled: V2Textfield!
    
    @IBOutlet weak var additionalNotesTextField: V2Textfield!
    var categoryList = NSMutableArray()
    
    @IBOutlet weak var pickerVIew: UIPickerView!
    
    var currentLocation=CLLocation()
    let locationManager = CLLocationManager()
    var searchResults = [GMSAutocompletePrediction]()
    let searchbarView = UIView()
    var searchController: UISearchController?
    let tableView = UITableView()
    var searchView = UIView()
    var hidden: Bool = false
    var placesClient = GMSPlacesClient.shared()
    var deadlineDate = ""
    var paymentType = "1"
    var state = ""
    var city = ""
    var country = ""
    var longitude = ""
    var lat = ""
    var location_string = ""
    var isDatePickerON = false;
    var data = ["Daily", "Hourly"]
    var defaultXValueforView = 5;
    var defaultCategoryScrollContentSize = 100;
    var datesArray = [String]()

    var imagePicker = UIImagePickerController()
    var base64StringOf_my_image = String()
    
    var editGigDetail = LatLongDetail()
    var editFlag = false
    
    let imageWidth:CGFloat = 130
    let imageHeight:CGFloat = 114
    var xPosition:CGFloat = 8
    var scrollViewSize:CGFloat=0
    let margin:CGFloat=8
    
    //@IBOutlet weak var imageHolder: UIImageView!
    var imageHolder: UIImageView!
    var imagesArray=[UIImage]()
    var defaultImageIndex=1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        initializePhotosScrollView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = 45
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        
        
        if editFlag {
            
            loadEditeditems()
            self.titleUILabel.text="Edit Post"
            backBtn.isHidden=false;
            addAvailibityCalenderTextFiled.isHidden=false
            additionalNotesTextField.isHidden=false
            pickerVIew.isHidden=false

            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //IQKeyboardManager.sharedManager().enable=false
        
        //mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //IQKeyboardManager.sharedManager().enable = true
        
    }
    
    @IBAction func showLocation(_ sender: Any) {
        
        
        self.secondAnimatedView(placeHolder: "Search Places")
    }
    
    @IBAction func goBack(_ sender: Any){
        
        
        self.dismiss(animated: true, completion: nil)
        
    }

    func initializePhotosScrollView(){
    
        let myImage:UIImage = UIImage(named: "new_post_placeholder")!
        
        imageHolder = UIImageView.init(image: myImage)
        //imageHolder.image = myImage
        imageHolder.contentMode = UIViewContentMode.scaleAspectFit
        
        imageHolder.frame.size.width = imageWidth
        imageHolder.frame.size.height = imageHeight
        imageHolder.frame.origin.x = xPosition
        imageHolder.frame.origin.y = 8
        
        let btn=UIButton.init(frame: imageHolder.frame)
        
        btn.addTarget(self, action: #selector(loadFromGallery(_:)), for: .touchUpInside)
        
        imagesScrollView.addSubview(imageHolder)
        
        imagesScrollView.addSubview(btn)
        
        xPosition += imageWidth
        scrollViewSize += imageWidth
        
        imagesScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)

    
    }
    
    
    func applyStyle() {
        
        addTitleTextField.placeHolderString = "Add Title"
        addTitleTextField.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        addTitleTextField.delegate = self
        addTitleTextField.returnKeyType = UIReturnKeyType.next
        addTitleTextField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)

        
        descriptionTextField.placeHolderString = "Add Description"
        descriptionTextField.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        descriptionTextField.delegate = self
        descriptionTextField.returnKeyType = UIReturnKeyType.next
        descriptionTextField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)
        
        addCategoryTextField.placeHolderString = "Add Category"
        addCategoryTextField.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        addCategoryTextField.delegate = self
        addCategoryTextField.returnKeyType = UIReturnKeyType.next
        addCategoryTextField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)

        
        addLocationTextField.placeHolderString = "Add Location"
        addLocationTextField.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        addLocationTextField.delegate = self
        addLocationTextField.returnKeyType = UIReturnKeyType.next
        addLocationTextField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)

        
        addPriceTextField.placeHolderString = "Add Price"
        addPriceTextField.setStyle(style: .V2TextFieldStylePhoneNumber, border: .V2TextFieldWithBorder)
       // addPriceTextField.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        addPriceTextField.delegate = self
        //addPriceTextField.returnKeyType = UIReturnKeyType.next
        addPriceTextField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)

        
        addAvailibityCalenderTextFiled.placeHolderString = "Add Availiability Calender"
        addAvailibityCalenderTextFiled.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        addAvailibityCalenderTextFiled.delegate = self
        addAvailibityCalenderTextFiled.returnKeyType = UIReturnKeyType.next
        addAvailibityCalenderTextFiled.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)
        
        additionalNotesTextField.placeHolderString = "Add Additional Notes"
        additionalNotesTextField.setStyle(style: .V2TextFieldStyleEmail, border: .V2TextFieldWithBorder)
        additionalNotesTextField.delegate = self
        additionalNotesTextField.returnKeyType = UIReturnKeyType.next
        additionalNotesTextField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 2.0)

        self.pickerVIew.dataSource = self
        self.pickerVIew.delegate = self
        
        //mainScrollView.contentSize=CGSize(width: self.view.frame.width, height: additionalNotesTextField.frame.origin.y)

    }
    
    @IBAction func calenderTapped(_ sender: Any) {
        
        if paymentType == "1"{
            
            performSegue(withIdentifier: "availabilityCalenderVC", sender: self)
        }else{
            
            performSegue(withIdentifier: "showSelectDateTime", sender: self)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadEditeditems(){
        initializePhotosScrollView()
        loadCurrentImages()
    
        descriptionTextField.text=editGigDetail.gig_description
        
        categoryList=editGigDetail.categoryList
        var categoryName  = ""
        
        for category in categoryList {
            if categoryList.count > 1 {
                if categoryName.characters.count > 1 {
                    categoryName = categoryName + ", "
                }
            }
            categoryName =  categoryName.appending(((category as? CategoryModel)?.catName)!)
            
        }
        self.addCategoryTextField.text = categoryName
        addLocationTextField.text=editGigDetail.location_string
        self.location_string=editGigDetail.location_string
        addPriceTextField.text=editGigDetail.pay
        var pickerRowIndex=0
        paymentType="1"
        if editGigDetail.type_of_payment == "2"{
            
            paymentType="2"
            pickerRowIndex=1
        
        }
        
        pickerVIew.selectRow(pickerRowIndex, inComponent: 0, animated: true)
            
        self.state=editGigDetail.state
        self.city=editGigDetail.city
        self.country=editGigDetail.country
        self.lat=editGigDetail.lat
        self.longitude=editGigDetail.long
        
        //var selectedDates = [Date]()
        var counter=0
        var datesStr=""
        
        for (_, object) in editGigDetail.calenderList.enumerated()
        {
            let item = object as! CalenderObject
            
            print(item.calenderDate)
            
            datesArray.append(Commons.changeGigDateFormatToCalender(dateFrom: item.calenderDate))
            
            if counter == 0{
            
                datesStr+="\(Commons.changeGigDateFormatToCalender(dateFrom: item.calenderDate))"
                
            }else{
            
                datesStr+=", \(Commons.changeGigDateFormatToCalender(dateFrom: item.calenderDate))"
                
            }
                
            
            counter += 1
            
        }
        
        addAvailibityCalenderTextFiled.text=datesStr
        additionalNotesTextField.text=editGigDetail.notes
        addTitleTextField.text=editGigDetail.gigTitle
    
    
    }
    
    
    @IBAction func loadFromGallery(_ sender: Any) {
        
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//        present(imagePicker, animated: true,completion: nil)
        
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func editThisImage(_ sender: Any) {
        
        let btn=sender as! UIButton
        
        let tag=btn.tag
        
        let alertController = UIAlertController(title: "Alert", message: "Please Select as Default or Remove Image", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            
        }
        let okAction = UIAlertAction(title: "Set As Default", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            
            if self.defaultImageIndex != tag {
            
                let oldDefault = (self.imagesScrollView.viewWithTag(self.defaultImageIndex)) as! UIButton
                
                oldDefault.layer.borderWidth=0
                
                btn.layer.borderColor = UIColor.red.cgColor
                
                btn.layer.borderWidth = 2
                
                self.defaultImageIndex=tag

                
            }
        }
        
        
        let removeAction = UIAlertAction(title: "Remove", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.imagesArray.remove(at: tag-1)
            
            if self.defaultImageIndex == tag {
                
                
                self.defaultImageIndex=1
                
                
            }

            
            
            self.loadCurrentImages()
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(removeAction)
        self.present(alertController, animated: true, completion: nil)
        //remove
        
    }
    
    @IBAction func menuLargeBtn(_ sender: Any) {
       
        _=navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func nextLargeBtn(_ sender: Any) {
        
        if editFlag {
            base64StringOf_my_image = base64StringOfImage(imageHolder.image!)
        }
        
        let (isValid, error) = validateFields()
        
        if !isValid {
            Commons.showAlert(error!, VC: self)
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "previewVC") as! PreviewViewController
        
        if editFlag {
            
            nextViewController.editedGigId=editGigDetail.gig_post_id
        
        }else{
        
            nextViewController.editedGigId=""
        }
        
        nextViewController.imagesArray=imagesArray
        nextViewController.defaultImageIndex=self.defaultImageIndex
        nextViewController.descriptionFromPostVC = descriptionTextField.text!
        nextViewController.categorieListFromPostVC = categoryList
        nextViewController.locationFromPostVC = addLocationTextField.text!
        nextViewController.deadLineFromPostVC = deadlineDate
        nextViewController.paymentFromPostVC = addPriceTextField.text!
        nextViewController.paymentTimeFromPostVC = paymentType
        nextViewController.stateFromPostVC = self.state
        nextViewController.cityFromPostVC = self.city
        nextViewController.countryFromPostVC = self.country
        nextViewController.longitudeFromPostVC = self.longitude
        nextViewController.latFromPostVC = self.lat
        nextViewController.datesArray = self.datesArray
        nextViewController.additionalNotesPostVC = self.additionalNotesTextField.text!
        nextViewController.titlePostVC = self.addTitleTextField.text!
        
        nextViewController.holderImage=imageHolder.image
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postDate =  dateFormatter.string(from: date as Date)
        nextViewController.dateAndTime = postDate
        nextViewController.location_stringFromPostVC = self.location_string
        //self.navigationController?.pushViewController(nextViewController, animated:true)
        present(nextViewController, animated: true, completion: nil)
    }
    
    fileprivate func validateFields() -> (Bool, String?) {
        
        if addTitleTextField.text == "" {
             return (false, "Please add title")
        }
        
        if (descriptionTextField.text?.isEqual(""))! {
            return (false, "Please add description")
        }
        
        if (categoryList.count==0) {
            return (false, "Please add category or catgories")
        }
        
        if (addLocationTextField.text?.isEqual(""))! {
            return (false, "Please Choose location")
        }
        
        if (addPriceTextField.text?.isEqual(""))! {
            
            return (false , "Please enter amount")
            
        }
        
        if additionalNotesTextField.text == "" {
            return (false , "Please enter notes")

        }
        
//        if base64StringOf_my_image == ""{
//            return (false,"Please enter image")
//        }
        
        if imagesArray.count == 0{
            return (false,"Please enter at least one image")
        }
        
        if self.datesArray.count == 0{
            return (false,"Please Select at least one date")
        }

        
      
        
        return (true,nil)
    }
    
    // MARK: PickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(row==0)
        {
            paymentType = "1"
            addAvailibityCalenderTextFiled.text="Add Availibilty Calender Date"
        }
        else
        {
            paymentType = "2"
            addAvailibityCalenderTextFiled.text="Add Availibilty Calender Date And Time"
        }
        //        gradeTextField.text = gradePickerValues[row]
        //        self.view.endEditing(true)
    }

    
    func addCategory() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "categoryVC") as! CategoriesViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width:500,height:400)
        popover?.delegate = self
        popoverContent.mDelegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x:screenWidth/2-90,y:screenHeight/2,width:0,height:0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        self.present(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func priceTapped(_ sender: Any) {
        
        //self.view.layoutIfNeeded()
        
        addAvailibityCalenderTextFiled.isHidden=false
        additionalNotesTextField.isHidden=false
        pickerVIew.isHidden=false

        
    }
    func sendArrayToPreviousVC(myArray:NSMutableArray) {
        categoryList = NSMutableArray()
        categoryList = myArray
        var categoryName  = ""
        
        for category in categoryList {
            if categoryList.count > 1 {
                if categoryName.characters.count > 1 {
                    categoryName = categoryName + ", "
                }
            }
            categoryName =  categoryName.appending(((category as? CategoryModel)?.catName)!)
        
        }
        self.addCategoryTextField.text = categoryName
    }

    func sendDatesArrayToPreviousVC(dates:Array<String>) {
        datesArray = dates
        var dateString = ""
        for date in dates {
            if dates.count > 1 {
                if dateString.characters.count > 1 {
                    dateString = dateString + ", "
                }
            }
            
            dateString =  dateString.appending(date)

            
        }
        
        self.addAvailibityCalenderTextFiled.text = dateString
    }
    
    func sendSelectedDateTimeArrayToPreviousVC(dates: Array<String>){
        
        datesArray = dates
        var dateString = ""
        for date in dates {
            if dates.count > 1 {
                if dateString.characters.count > 1 {
                    dateString = dateString + ", "
                }
            }
            
            dateString =  dateString.appending(date)
            
            
        }
        
        self.addAvailibityCalenderTextFiled.text = dateString
    
    
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "availabilityCalenderVC" {
            let destinationVC = segue.destination as! AvailabilityCalenderViewController
            
            if editFlag {
                
            destinationVC.selectedDatesArray = editGigDetail.calenderList
            destinationVC.imageUrl = editGigDetail.gigImage
                destinationVC.gigTitle = editGigDetail.gigTitle
            }
            
            destinationVC.datesDelegate = self
        }else if segue.identifier == "showSelectDateTime" {
        
            let destinationVC = segue.destination as! SelectDateTimeController
            
            if editFlag {
                
                destinationVC.selectedDatesArray = editGigDetail.calenderList
                destinationVC.imageUrl = editGigDetail.gigImage
                destinationVC.gigTitle = editGigDetail.gigTitle
            }
            
            destinationVC.dateTimeDelegate = self
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == descriptionTextField{
            
            
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }else if textField == addTitleTextField{
        
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        }else if textField == addPriceTextField {
            
            self.priceTapped(self)
            
        }else if textField == addCategoryTextField {
            addCategory()
            textField.endEditing(true)
        } else  if textField == addLocationTextField {
            addLocationTextField.resignFirstResponder()
            self.secondAnimatedView(placeHolder: "Search Places")
        } else if textField == addAvailibityCalenderTextFiled {
            textField.resignFirstResponder()
            textField.endEditing(true)
            view.endEditing(true)
            mainScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
           // addAvailibityCalenderTextFiled.resignFirstResponder()
            if paymentType == "1"{
            
                performSegue(withIdentifier: "availabilityCalenderVC", sender: self)
            }else{
            
                performSegue(withIdentifier: "showSelectDateTime", sender: self)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- TextEdit Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        return true
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
    
    
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
    
        //imagesArray.append(contentsOf: images)
        imagesArray+=images
        dismiss(animated: true)
        
        loadCurrentImages()
    
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
    
        dismiss(animated: true)
    
    }
    
    
    func loadCurrentImages(){
    
        imagesScrollView.subviews.forEach({ $0.removeFromSuperview() })
        xPosition = 0
        scrollViewSize=0
        
        var c=0
        for image in imagesArray {
            let myImage:UIImage = image
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            
            myImageView.frame.size.width = imageWidth-16
            myImageView.frame.size.height = imageHeight-16
            myImageView.frame.origin.x = xPosition+8
            myImageView.frame.origin.y = 16
            
            //myImageView.inset
            
            let frame=CGRect(x: xPosition, y: 8, width: imageWidth, height: imageHeight)
            
            let btn=UIButton.init(frame: frame)
            
            btn.addTarget(self, action: #selector(editThisImage(_:)), for: .touchUpInside)
            
            btn.tag=c+1
            
            if defaultImageIndex==c+1 {
                
                btn.layer.borderWidth = 2
                btn.layer.borderColor = UIColor.red.cgColor
            
            }
            //myImageView.sd_addActivityIndicator()
            imagesScrollView.addSubview(myImageView)
            imagesScrollView.addSubview(btn)
            xPosition += (imageWidth + margin)
            scrollViewSize += (imageWidth + margin)
            
            c+=1
        }
        
        
        
        let myImage:UIImage = UIImage(named: "new_post_placeholder")!
        
        imageHolder = UIImageView.init(image: myImage)
        //imageHolder.image = myImage
        
        imageHolder.contentMode = UIViewContentMode.scaleAspectFit
        
        imageHolder.frame.size.width = imageWidth
        imageHolder.frame.size.height = imageHeight
        imageHolder.frame.origin.x = xPosition
        imageHolder.frame.origin.y = 16
        
        let btn=UIButton.init(frame: imageHolder.frame)
        
        btn.addTarget(self, action: #selector(loadFromGallery(_:)), for: .touchUpInside)
        
        imagesScrollView.addSubview(imageHolder)
        
        imagesScrollView.addSubview(btn)
        
        xPosition += imageWidth
        scrollViewSize += imageWidth
        
        imagesScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
    
    }

}


extension NewPostVC: CLLocationManagerDelegate {
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
                //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
                currentLocation=location
                let lat = location.coordinate.latitude
                let long = location.coordinate.longitude
                let location = "\(lat),\(long)"
                //updateLocation(location: location)
                print(location)
                locationManager.stopUpdatingLocation()
            }
        }
}





//MARK:- Custom Location Address
extension NewPostVC {
    func setUpSearchController() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostVC.keyboardWillShowFor(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        searchView = UIView(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height))
        //        let recongnizer = UITapGestureRecognizer(target: self, action: #selector(StudentProfileVC.hideSearchView))
        //        searchbarView.addGestureRecognizer(recongnizer)
        searchView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.view.frame
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchView.insertSubview(effectView, at: 0)
        effectView.alpha = 0
        
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        
        searchController?.searchBar.placeholder = "Search Location"
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.isTranslucent = true
        searchController?.delegate = self
        
        searchController!.searchBar.delegate = self
        searchController!.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundView = searchController!.searchBar.value(forKey: "background") as? UIView
        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundView?.layer.backgroundColor = UIColor.clear.cgColor
        backgroundView?.alpha = 0.0
        
        let textFieldInsideSearchBar = searchController!.searchBar.value(forKey: "searchField") as? UITextField
        //UIColor(red: 66/255, green: 150/255, blue: 230/255, alpha: 0.5)
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 0.0)
        //        textFieldInsideSearchBar?.translatesAutoresizingMaskIntoConstraints = false
        //        textFieldInsideSearchBar?.alpha = 0.0
        textFieldInsideSearchBar?.tintColor = UIColor.black
        textFieldInsideSearchBar?.textColor = UIColor.lightGray
        textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string:"Search Location",
                                                                             attributes:[NSForegroundColorAttributeName: UIColor.gray])
        let glassIconView = textFieldInsideSearchBar!.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.gray
        
        let clearButton = textFieldInsideSearchBar!.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        clearButton.addTarget(self, action: #selector(NewPostVC.clearButtonAction), for: UIControlEvents.touchUpInside)
        clearButton.tintColor = UIColor.gray
        
        //        self.view.bringSubviewToFront(searchView)
        self.view.addSubview(searchView)
        UIView.animate(withDuration: 0.5, animations: {
            effectView.alpha = 0.9
            textFieldInsideSearchBar?.backgroundColor = UIColor.white
            backgroundView?.alpha = 1.0
            textFieldInsideSearchBar?.alpha = 1.0
            var frame = self.searchView.frame
            frame.origin.y = 0
            self.searchView.frame = frame
        }, completion: { (finished) in
            
            self.searchController!.searchBar.isHidden = false
            self.searchController!.isActive = true
            self.searchController!.searchBar.becomeFirstResponder()
            self.addingSearchView()
        })
        
        
    }
    //MARK:- Add Search View
    func addingSearchView() {
        searchbarView.translatesAutoresizingMaskIntoConstraints = false
        searchController?.searchBar.translatesAutoresizingMaskIntoConstraints = false
        //        searchController!.searchBar.tintColor = UIColor.blackColor()
        //        searchController!.searchBar.barTintColor = UIColor.grayColor()
        //        searchController!.searchBar.backgroundColor = UIColor.clearColor()
        //        searchController!.searchBar.barStyle = .BlackTranslucent
        //        searchController!.searchBar.showsCancelButton = false
        //        searchController!.searchBar.alpha = 0.0
        searchbarView.layer.cornerRadius = 8.0
        searchbarView.backgroundColor = UIColor.white
        searchbarView.alpha = 0.8
        
        searchbarView.bringSubview(toFront: searchController!.searchBar)
        searchbarView.addSubview(searchController!.searchBar)
        searchView.bringSubview(toFront: searchbarView)
        searchView.addSubview(searchbarView)
        searchView.bringSubview(toFront: searchbarView)
        searchView.addSubview(searchbarView)
        
        let searchtop = NSLayoutConstraint(item: searchController!.searchBar, attribute: .top, relatedBy: .equal, toItem: searchbarView, attribute: .top, multiplier: 1, constant: 0)
        let searchleading = NSLayoutConstraint(item: searchController!.searchBar, attribute: .leading, relatedBy: .equal, toItem: searchbarView, attribute: .leading, multiplier: 1, constant: 0)
        
        let searchtrailing = NSLayoutConstraint(item: searchController!.searchBar, attribute: .trailing, relatedBy: .equal, toItem: searchbarView, attribute: .trailing, multiplier: 1, constant: 0)
        let searchbottom = NSLayoutConstraint(item: searchController!.searchBar, attribute: .bottom, relatedBy: .equal, toItem: searchbarView, attribute: .bottom, multiplier: 1, constant: 0)
        
        searchbarView.addConstraints([searchtop, searchleading,searchtrailing,searchbottom])
        
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.view.frame
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 0
        searchbarView.insertSubview(effectView, at: 0)
        
        let top = NSLayoutConstraint(item: searchbarView, attribute: .top, relatedBy: .equal, toItem: searchView, attribute: .top, multiplier: 1, constant: 50)
        let leading = NSLayoutConstraint(item: searchbarView, attribute: .leading, relatedBy: .equal, toItem: searchView, attribute: .leading, multiplier: 1, constant: 20)
        
        let trailing = NSLayoutConstraint(item: searchbarView, attribute: .trailing, relatedBy: .equal, toItem: searchView, attribute: .trailing, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: searchbarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        
        self.searchView.addConstraints([top, leading,trailing,height])
        
        tableView.frame = CGRect(x: 0, y: 0, width: 0, height: searchController!.view.frame.size.height)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = nil
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = effectView
        searchView.addSubview(tableView)
        searchView.bringSubview(toFront: tableView)
        
        let tabletop = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: searchbarView, attribute: .top, multiplier: 1, constant: 40)
        let tableleading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: searchbarView, attribute: .leading, multiplier: 1, constant: 10)
        
        let tabletrailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: searchbarView, attribute: .trailing, multiplier: 1, constant: -10)
        let tableheight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 500)
        
        self.searchView.addConstraints([tabletop, tableleading,tabletrailing,tableheight])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchController!.searchBar.alpha = 1.0
        }, completion: { (finished) in
        })
    }
    
    func hideSearchView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.hidden = true
            var frame = self.searchView.frame
            frame.origin.y = self.view.frame.height/2
            self.searchView.frame = frame
            self.searchResults.removeAll()
        }, completion: { (finished) in
            
            self.searchView.removeFromSuperview()
            
            
        })
    }
    //MARK:- Keyboard Delegate Methods
    func keyboardWillShowFor(_ notification:Notification) {
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        var frame = tableView.frame
        frame.size.height = self.view.frame.height - (tableView.frame.origin.y + keyboardHeight)
        tableView.frame = frame
    }
    
    func clearButtonAction() {
        self.searchResults.removeAll()
        tableView.reloadData()
    }
    
    //MARK:- Animate View
    func secondAnimatedView(placeHolder: String) {
        hidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostVC.keyboardWillShowFor(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        searchView = UIView(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height))
        
        searchView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = self.view.frame
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchView.insertSubview(effectView, at: 0)
        searchView.addSubview(effectView)
        effectView.alpha = 0
        
        //adding text field as a search field
        let searchField = UISearchBar(frame: CGRect(x: 20, y: 50, width: 280, height: 30))
        searchField.placeholder = placeHolder
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        searchField.layer.cornerRadius = 10
        
        searchField.delegate = self
        
        
        let backgroundView = searchField.value(forKey: "background") as? UIView
        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        backgroundView?.layer.backgroundColor = UIColor.clear.cgColor
        backgroundView?.alpha = 0.0
        
        let textFieldInsideSearchBar = searchField.value(forKey: "searchField") as? UITextField
        //UIColor(red: 66/255, green: 150/255, blue: 230/255, alpha: 0.5)
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        //        textFieldInsideSearchBar?.translatesAutoresizingMaskIntoConstraints = false
        //        textFieldInsideSearchBar?.alpha = 0.0
        textFieldInsideSearchBar?.tintColor = UIColor.black
        textFieldInsideSearchBar?.textColor = UIColor.lightGray
        textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string:"Search Location",
                                                                             attributes:[NSForegroundColorAttributeName: UIColor.gray])
        let glassIconView = textFieldInsideSearchBar!.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor.gray
        
        let clearButton = textFieldInsideSearchBar!.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState())
        clearButton.addTarget(self, action: #selector(NewPostVC.clearButtonAction), for: UIControlEvents.touchUpInside)
        clearButton.tintColor = UIColor.gray
        
        searchView.addSubview(searchField)
        
        let searchFieldtop = NSLayoutConstraint(item: searchField, attribute: .top, relatedBy: .equal, toItem: searchView, attribute: .top, multiplier: 1, constant: 50)
        
        let searchFieldleading = NSLayoutConstraint(item: searchField, attribute: .leading, relatedBy: .equal, toItem: searchView, attribute: .leading, multiplier: 1, constant: 20)
        
        let searchFieldtrailing = NSLayoutConstraint(item: searchField, attribute: .trailing, relatedBy: .equal, toItem: searchView, attribute: .trailing, multiplier: 1, constant: -20)
        
        let searchFieldheight = NSLayoutConstraint(item: searchField, attribute: .height, relatedBy: .equal, toItem: nil,  attribute: .height, multiplier: 1, constant: 30)
        
        self.searchView.addConstraints([searchFieldtop, searchFieldleading,searchFieldtrailing,searchFieldheight])
        
        tableView.frame = CGRect(x: 0, y: 0, width: 0, height: searchView.frame.size.height)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = nil
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = UIColor.clear
        //        tableView.backgroundView = effectView
        searchView.addSubview(tableView)
        searchView.bringSubview(toFront: tableView)
        //
        let tabletop = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: searchField, attribute: .top, multiplier: 1, constant: 40)
        let tableleading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: searchField, attribute: .leading, multiplier: 1, constant: 10)
        
        let tabletrailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: searchField, attribute: .trailing, multiplier: 1, constant: -10)
        let tableheight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 500)
        
        self.searchView.addConstraints([tabletop, tableleading,tabletrailing,tableheight])
        
        let recongnizer = UITapGestureRecognizer(target: self, action: #selector(NewPostVC.hideSearchView))
        recongnizer.delegate = self
        searchView.addGestureRecognizer(recongnizer)
        self.view.addSubview(searchView)
        UIView.animate(withDuration: 0.5, animations: {
            effectView.alpha = 0.9
            var frame = self.searchView.frame
            frame.origin.y = 0
            self.searchView.frame = frame
        }, completion: { (finished) in
            
            searchField.becomeFirstResponder()
        })
        
    }
    
}

//MARK:- Custom Location Address
extension NewPostVC: UISearchControllerDelegate, UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //        searchController.active = true
        tableView.reloadData()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if Commons.connectedToNetwork() {
            if searchText.isEmpty {
                self.searchResults.removeAll()
                tableView.reloadData()
                return
            }
            //add Service
            //[GMSAutocompletePrediction]?
            placesClient.autocompleteQuery(searchText, bounds: nil, filter: nil, callback: { (list, error) in
                self.searchResults.removeAll()
                self.searchResults = list!
                self.tableView.reloadData()
            })
            
        }else {
            Commons.showAlert("Please check your connection", VC: self)        }
    }
    
    //MARK:- TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.searchResults.count == 0{
            return 1
        }
        return self.searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if !hidden {
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.layer.cornerRadius = 5.0
            cell.backgroundColor = UIColor.clear
            
            if self.searchResults.count > 0 {

            let plac = self.searchResults[(indexPath as NSIndexPath).row]
                cell.textLabel?.attributedText = plac.attributedFullText
            
            }else if self.searchResults.count == 0  {
                
                cell.textLabel?.text = "Use Current Location"
            }
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchResults.count == 0{
        
            print(currentLocation)
            self.addLocationTextField.text = "Current Location"
            
        }else{
        
        let plc = self.searchResults[(indexPath as NSIndexPath).row]
        print(plc)
        placesClient.lookUpPlaceID(plc.placeID!, callback: { (place, errpr) in
            print(place ?? "")
            self.addLocationTextField.text = place!.name
            var address = place!.formattedAddress
            let fullAddressArr = address?.characters.split{$0 == ","}.map(String.init)
            
            
            if(fullAddressArr?.count==1)
            {
                self.state = ""
                self.city = (fullAddressArr?[0])!
                self.country = ""
            }
            else if(fullAddressArr?.count==2)
            {
                self.state = (fullAddressArr?[1])!
                self.city = (fullAddressArr?[0])!
                self.country = (fullAddressArr?[1])!
            }
            else if(fullAddressArr?.count==3)
            {
                self.state = (fullAddressArr?[1])!
                self.city = (fullAddressArr?[0])!
                self.country = (fullAddressArr?[2])!
            }
            
            self.longitude = String(place!.coordinate.longitude)
            self.lat = String(place!.coordinate.latitude)
            self.location_string = place!.formattedAddress!
            
            print(self.state)
            print(self.city)
            print(self.country)
            print(self.longitude)
            print(self.lat)
            print(self.location_string)
            
            
            self.hideSearchView()
        })
        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.tableHeaderView
        headerView?.backgroundColor = UIColor.clear
        return headerView
    }
    
    //MARK:- Gesture Methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        //TableView Touch
        if (touch.view?.isKind(of: UITableView.classForCoder()))! {
            return true
        }
        //UITableViewCellContentView Touch
        if (touch.view?.superview?.isKind(of: UITableViewCell.classForCoder()))! {
            let location = touch.location(in: self.tableView)
            var indexPath = self.tableView.indexPathForRow(at: location)
            
            if self.searchResults.count == 0{
                
                
                
                print(currentLocation)
                
                self.addLocationTextField.text = "Current Location"
                
                CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
                    print(location)
                    
                    if error != nil {
                        print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                        return
                    }
                    
                    if (placemarks?.count)! > 0 {
                        let pm = placemarks?[0] as CLPlacemark?
                        print(pm?.locality ?? "")
                        
                        if pm?.locality != "" {
                            
                            //self.country.text="\(pm?.locality ?? ""), \(pm?.country ?? "")"
                            self.state = ""
                            self.city = pm?.locality ?? ""
                            self.country = pm?.country ?? ""
                            self.longitude = String(self.currentLocation.coordinate.longitude)
                            self.lat = String(self.currentLocation.coordinate.latitude)
                            self.location_string = "\(pm?.locality ?? ""), \(pm?.country ?? "")"

                            
                        }else{
                            
                            
                            self.state = ""
                            self.city = ""
                            self.country = ""
                            
                        }
                        
                        
                    }
                    else {
                        print("Problem with the data received from geocoder")
                    }
                    
                    self.hideSearchView()
                    //return false
                })
                //return false
            }else{
            
            let plc = self.searchResults[(indexPath?.row)!]
            print(plc)
            placesClient.lookUpPlaceID(plc.placeID!, callback: { (place, errpr) in
                print(place)
                self.addLocationTextField.text = place!.name
                var address = place!.formattedAddress
                let fullAddressArr = address?.characters.split{$0 == ","}.map(String.init)
                
                
                if(fullAddressArr?.count==1)
                {
                    self.state = ""
                    self.city = (fullAddressArr?[0])!
                    self.country = ""
                }
                else if(fullAddressArr?.count==2)
                {
                    self.state = (fullAddressArr?[1])!
                    self.city = (fullAddressArr?[0])!
                    self.country = (fullAddressArr?[1])!
                }
                else if(fullAddressArr?.count==3)
                {
                    self.state = (fullAddressArr?[1])!
                    self.city = (fullAddressArr?[0])!
                    self.country = (fullAddressArr?[2])!
                }
                
                self.longitude = String(place!.coordinate.longitude)
                self.lat = String(place!.coordinate.latitude)
                self.location_string = place!.formattedAddress!
                
                print(self.state)
                print(self.city)
                print(self.country)
                print(self.longitude)
                print(self.lat)
                print(self.location_string)
                
                
                self.hideSearchView()
            })
            //  self.tableView.deselectRow(at: indexPath?.row, animated: true)
            return false
            }
        }
        return true
    }
    
}

extension NewPostVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //addProfileImgOutlet.setBackgroundImage(pickedImage, for: .normal)
            
            //holderImage=pickedImage
            imageHolder.image=pickedImage
            // self.prepCompressedImage = UIImage.compress(pickedImage, compressRatio: 0.8)
            base64StringOf_my_image = base64StringOfImage(pickedImage)
            //
            //            if appUtility.connectedToNetwork() {
            //                let params = ["user_id":user!.userId,"picbase64":["file_data": base64StringOf_my_image]] as [String : Any]
            //                appUtility.loadingView(self, wantToShow: true)
            //                userLoader.tryProfilePic(params as [String : AnyObject]?, successBlock: { (user) in
            //                    appUtility.loadingView(self, wantToShow: false)
            //                }, failureBlock: { (error) in
            //                    appUtility.loadingView(self, wantToShow: false)
            //                    appUtility.showAlert((error?.localizedDescription)!, VC: self)
            //                })
            //            }else {
            //                appUtility.loadingView(self, wantToShow: false)
            //                appUtility.showNoNetworkAlert()
            //            }
            
        }else{}
        imagePicker.delegate = nil
        self.dismiss(animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func base64StringOfImage(_ image:UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let base64String = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    
    
}






