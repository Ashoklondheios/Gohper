//
//  SendContractViewController.swift
//  Gopher
//
//  Created by User on 2/13/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import SystemConfiguration
import AFNetworking
import SWRevealViewController
import CoreLocation
import GoogleMapsCore
import GooglePlaces

class SendContractViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate,MyProtocol{

    //MARK:- IBOutlet properties
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var parentScrollView: UIScrollView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var enterAmount: UITextField!
    @IBOutlet weak var deadlineTimeParentView: UIView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    var datePickerView = UIDatePicker()

    @IBOutlet weak var deadLineTime: UITextField!
    @IBOutlet weak var datetimePickerParentView: UIView!
    
    //MARK:- Variables
    let locationManager = CLLocationManager()
    var searchResults = [GMSAutocompletePrediction]()
    let searchbarView = UIView()
    var searchController: UISearchController?
    let tableView = UITableView()
    var searchView = UIView()
    var hidden: Bool = false
    var placesClient = GMSPlacesClient.shared()
    var deadlineDate = "" 
    var paymentType = "0"
    var state = ""
    var city = ""
    var country = ""
    var longitude = ""
    var lat = ""
    var location_string = ""
    var categoryList = NSMutableArray()
    var isDatePickerON = false;
    var sellerId = ""
    var data = ["Flat", "Hourly"]
    var defaultXValueforView = 5;
    var defaultCategoryScrollContentSize = 100;
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parentScrollView.isUserInteractionEnabled = true
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        parentScrollView.contentSize = CGSize(width: screenWidth, height: viewParent.frame.height+10)
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.addDoneButtonOnKeyboard()
        self.hideKeyBoardOnTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        let enterAmountTextFieldPH = NSAttributedString(string: "Enter Amount $" , attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        enterAmount.attributedPlaceholder = enterAmountTextFieldPH
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CreateView for Category
    
    func createViewForCatogry(name: String, heightOfParent: Int) -> UIView {
        
        let catogeryView=UIView(frame: CGRect(x:defaultXValueforView, y:5, width:100, height:30))
        catogeryView.backgroundColor = Commons.UIColorFromRGB(rgbValue: 0xdfdfdf)
        
        let categoryName: UILabel = UILabel()
        categoryName.frame = CGRect(x: 8, y:5, width:80, height:21)
        categoryName.textColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        categoryName.textAlignment = NSTextAlignment.center
        categoryName.text = name
        categoryName.font = categoryName.font.withSize(10)
        catogeryView.addSubview(categoryName)
        defaultXValueforView = defaultXValueforView + 110;
        return catogeryView
    }

    func addCategoriesToView()
    {
        for i in 0..<categoryList.count {
            
            let catogry = categoryList[i] as! CategoryModel
            defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 90
            categoryScrollView.addSubview(self.createViewForCatogry(name: catogry.catName, heightOfParent: Int(categoryScrollView.frame.size.height)))
            categoryScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
            
        }
        defaultCategoryScrollContentSize = defaultCategoryScrollContentSize + 40
        categoryScrollView.contentSize = CGSize(width: defaultCategoryScrollContentSize, height:40)
        categoryScrollView.showsHorizontalScrollIndicator = false
        categoryScrollView.showsVerticalScrollIndicator = false
    }

    //MARK:- IBAction Methods

    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backSmallBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        self.openPreviewVc()
    }
    @IBAction func nextBtnLargeClick(_ sender: Any) {
        self.openPreviewVc()
    }
    
    @IBAction func addCAtegoriesBtn(_ sender: Any) {
        self.addCategory()

    }
    
    @IBAction func currentLocationBTN(_ sender: Any) {
    }
    
    @IBAction func didBeganEditingTextFiled(_ sender: Any) {
        var doneButton:UIBarButtonItem?
        deadLineTime.inputView = datePickerView
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        // Sets up the "button"
        
        // Creates the toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Commons.UIColorFromRGB(rgbValue: 0x55A0BF)
        toolBar.sizeToFit()
        
        // Adds the buttons
        //doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SendContractViewController.doneClick(_:)))
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SendContractViewController.doneClick(sender:)))

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SendContractViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton!], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        // Adds the toolbar to the view
        
        
        deadLineTime.inputAccessoryView = toolBar
    }
    
    func doneClick(sender:UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        deadlineDate = dateFormatter.string(from: datePickerView.date)
        deadLineTime.text = Commons.changeDateFormat(dateFrom: deadlineDate)
        deadLineTime.resignFirstResponder()
    }
    
    
    
    func cancelClick() {
        deadLineTime.resignFirstResponder()
    }
    
    // MARK: Next Preview VC Methods

    func openPreviewVc() {
        let (isValid, error) = validateFields()
        
        if !isValid {
            Commons.showAlert(error!, VC: self)
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "previewSendContractVC") as! PreviewSendContractViewController
        
        nextViewController.descriptionFromPostVC = descriptionText.text
        nextViewController.categorieListFromPostVC = categoryList
        nextViewController.locationFromPostVC = address.text!
        nextViewController.deadLineFromPostVC = deadlineDate
        nextViewController.paymentFromPostVC = enterAmount.text!
        nextViewController.paymentTimeFromPostVC = paymentType
        nextViewController.stateFromPostVC = self.state
        nextViewController.cityFromPostVC = self.city
        nextViewController.countryFromPostVC = self.country
        nextViewController.longitudeFromPostVC = self.longitude
        nextViewController.latFromPostVC = self.lat
       // nextViewController.sellerId = self.sellerId
        nextViewController.location_stringFromPostVC = self.location_string
        self.navigationController?.pushViewController(nextViewController, animated:true) 
        
    }
    
    // MARK: Validation Methods
    fileprivate func validateFields() -> (Bool, String?) {
        
        if (descriptionText.text?.isEqual(""))! {
            return (false, "Please add description")
        }
        
        if (categoryList.count==0) {
            return (false, "Please add category or catgories")
        }
        
        if (address.text?.isEqual(""))! {
            return (false, "Please Choose location")
        }
        
        if (enterAmount.text?.isEqual(""))! {
            
            return (false , "Please enter amount")
            
        }
        
        if (deadlineDate.isEqual("")) {
            return (false,"Please enter deadline date")
        }
        if (paymentType.isEqual("")) {
            return (false,"Please choose payment type")
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
            paymentType = "0"
        }
        else
        {
            paymentType = "1"
        }
//        gradeTextField.text = gradePickerValues[row]
//        self.view.endEditing(true)
    }
    
    //MARK:- TextEdit Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == address {
            address.resignFirstResponder()
            self.secondAnimatedView(placeHolder: "Search Places")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Keyboard Show/Hide Methods
    // MARK: Close Keyboard
    
    
    func addDoneButtonOnKeyboard()
    {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:screenWidth, height:50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SendContractViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.enterAmount.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.enterAmount.resignFirstResponder()
    }
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.parentScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.parentScrollView.contentInset = contentInset

    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.parentScrollView.contentInset = contentInset
    }
    
    func hideKeyBoardOnTap()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
//        if(isDatePickerON==true)
//        {
//            isDatePickerON = false
//            self.dateTimePicker.isHidden = true;
//            self.datetimePickerParentView.isHidden = true;
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
//            deadlineDate = dateFormatter.string(from: dateTimePicker.date)
//            deadLineTime.text = deadlineDate
//        }
        
    }
    
   //MARK:- Category Popover View Controller
    
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
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    //MARK:- Delegate Category Methods
    
    func sendArrayToPreviousVC(myArray:NSMutableArray) {
        //DO YOUR THING
        for view in self.categoryScrollView.subviews {
            view.removeFromSuperview()
        }
        defaultCategoryScrollContentSize = 100
        defaultXValueforView = 5;
        categoryList = NSMutableArray()
        categoryList = myArray
        self.addCategoriesToView()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- extension CLLocationManagerDelegate
extension SendContractViewController: CLLocationManagerDelegate {
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
//            let lat = location.coordinate.latitude
//            let long = location.coordinate.longitude
//            let location = "\(lat),\(long)"
//            updateLocation(location: location)
//            print(location)
//            locationManager.stopUpdatingLocation()
//        }
//    }
}


//MARK:- Custom Location Address
extension SendContractViewController {
    func setUpSearchController() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(SendContractViewController.keyboardWillShowFor(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
        clearButton.addTarget(self, action: #selector(SendContractViewController.clearButtonAction), for: UIControlEvents.touchUpInside)
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
        NotificationCenter.default.addObserver(self, selector: #selector(SendContractViewController.keyboardWillShowFor(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
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
        clearButton.addTarget(self, action: #selector(SendContractViewController.clearButtonAction), for: UIControlEvents.touchUpInside)
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
        
        let recongnizer = UITapGestureRecognizer(target: self, action: #selector(SendContractViewController.hideSearchView))
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
extension SendContractViewController: UISearchControllerDelegate, UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
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
        
        return self.searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

            if !hidden {
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.layer.cornerRadius = 5.0
                cell.backgroundColor = UIColor.clear
                let plac = self.searchResults[(indexPath as NSIndexPath).row]
                cell.textLabel?.attributedText = plac.attributedFullText
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.numberOfLines = 0
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plc = self.searchResults[(indexPath as NSIndexPath).row]
        print(plc)
        placesClient.lookUpPlaceID(plc.placeID!, callback: { (place, errpr) in
            print(place)
            self.address.text = place!.name
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

            let plc = self.searchResults[(indexPath?.row)!]
            print(plc)
            placesClient.lookUpPlaceID(plc.placeID!, callback: { (place, errpr) in
                print(place)
                self.address.text = place!.name
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
        return true
    }
    
}
