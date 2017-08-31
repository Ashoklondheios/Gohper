//
//  SelectDateTimeController.swift
//  Gopher
//
//  Created by User on 7/4/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import FSCalendar
import AFNetworking
import IQKeyboardManagerSwift


protocol DateTimeProtocol: class {
    func sendSelectedDateTimeArrayToPreviousVC(dates: Array<String>)
}

class SelectDateTimeController: BaseViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var imageUrl = "" as String
    var gigTitle = "" as String
    
    var itemSelected=false
    
    var gigDetail=LatLongDetail()
    
    
    @IBOutlet weak var calender: FSCalendar!
    var selectedDatesArray=NSMutableArray()
    var arrayOfDates=[Date]()
    var hour=12
    var ampm="AM"
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return formatter
    }()
    
    
    fileprivate let formatterDateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calender, action: #selector(self.calender.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    var datesArray = [String]()
    weak var dateTimeDelegate: DateTimeProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideProgressLoader()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        //calender
        //        if imageUrl != ""
        //        {
        //            mainImage.sd_setImage(with: URL(string: imageUrl))
        //        }
        //        else
        //        {
        //            mainImage.image=UIImage(named: "placeholder.png")
        //        }
        //
        //        mainTitleLabel.text=gigTitle
        
        //        if imageUrl != "" {
        //
        //
        //        }
        
//        if selectedDatesArray.count>0 {
//            
//            for i in 0..<calender.selectedDates.count {
//                
//                calender.deselect(calender.selectedDates[i])
//            }
//            
//            
//            for (_, object) in selectedDatesArray.enumerated()
//            {
//                let item = object as! CalenderObject
//                
//                print(item.calenderDate)
//                
//                //if let selectedDate=Commons.getDatefromString(dateFrom: item.calenderDate){
//                
//                
//                //calender .select(selectedDate)
//                
//                //}
//                
//                
//                
//            }
//            
//            
//        }
        
        // Do any additional setup after loading the view.
        
        if selectedDatesArray.count>0 {
            
            datesArray.removeAll()
            itemSelected=true
            
            let firstObj=selectedDatesArray.firstObject as! CalenderObject
            
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
            
            let selectedDate = dateFormatter.date(from: firstObj.calenderDate)
            
            calender .select(selectedDate)
            
            for (_, object) in selectedDatesArray.enumerated()
            {
                let item = object as! CalenderObject
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy HH:mm:ss"
                
                let selectedItemDate = dateFormatter.date(from: item.calenderDate)
                
                //calender .select(selectedDate)

            
                datesArray.append(self.formatter.string(from: selectedItemDate!))
            
                let selectedTime=Commons.getTimeStringFromDate(dateFrom: item.calenderDate) 
            
                self.tableView.selectRow(at: IndexPath(row:Int(selectedTime)!,section:0), animated: true, scrollPosition: UITableViewScrollPosition.init(rawValue: 0)!)
                
                //print(Int(selectedTime) ?? "s")
                            
                

            
            
        
            }

        
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //IQKeyboardManager.sharedManager().enable = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        //        print(datesArray)
                dateTimeDelegate?.sendSelectedDateTimeArrayToPreviousVC(dates: self.datesArray)
        _ = navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    //    public func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{
    //
    //        calender .select(date)
    //
    //
    //        return false
    //
    //    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{
        
        
        
        
        return true
    }
    
    //    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    //
    //        return UIColor.green
    //    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        
        //let currentDate=Date()
        
        if calendar.today==date {
            
            return UIColor.white
        }
        
        if arrayOfDates.contains(date) {
            return UIColor.green
        }
        
        
        
        return nil
        
        
    }
    
    
    func MakeAPICall()
    {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        
        let currentDateTime = formatter.string(from: date)
        
        let params = ["buyer_id" : UserModel.getUserData().userId ,"seller_id":gigDetail.userId,"datetime":currentDateTime,"gig_post_id":gigDetail.gig_post_id,"calender": self.getdatesArray()] as [String : Any]
        print(params)
        self.showProgressLoader()
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(Constants.RentAPIURL, parameters: params, success:
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
        let dict = convertToDictionary(text: response)
        let code = dict?["code"] as! Int
        self.hideProgressLoader()
        print(code)
        
        if code == 201 {
            self.showAlert("You have already applied for this gig"  ,"Oops", VC: self)
        }
        if code == 401 {
            
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        if code == 400 {
            self.showAlert(dict?["msg"] as! String,"Oops", VC: self)
        }
        
        if(code == 200)
        {
            self.showAlertPostedGig("Your request has been submitted.","Congratulations", VC: self)
            //            navigationController?.popViewController(animated: false)
            //
            //            dismiss(animated: false, completion: nil)
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            //
            //            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "postGigMapVC") as! PostGigViewController
            //            nextViewController.amount = paymentFromPostVC
            //            nextViewController.deadLine = deadLineFromPostVC
            //            nextViewController.profilePicUrl = UserModel.getUserData().profile_img
            //            nextViewController.mLatitude = latFromPostVC
            //            nextViewController.mLongitutde = longitudeFromPostVC
            //            self.present(nextViewController, animated:true, completion:nil)
            //
            // self.showAlert("Gig has been posted successfully","Congratulations", VC: self)
        }
    }
    
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?{
//        
//        
//        //let currentDate=Date()
//        
//        if calendar.today==date {
//            
//            return UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
//        }
//        
//        if arrayOfDates.contains(date) {
//            return UIColor.black
//        }
//        
//        
//        
//        return UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
//        
//    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("did select date \(self.formatter.string(from: date))")
        
        itemSelected=true
        datesArray.removeAll()
        datesArray.append(self.formatter.string(from: date))
        
        deselectAllRows()
        
        self.tableView.selectRow(at: IndexPath(row:0,section:0), animated: true, scrollPosition: UITableViewScrollPosition.init(rawValue: 0)!)
        
        print("did select dates \(datesArray)")
        
        
        // self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {

        
        
    
    }
    
    func showAlert(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        VC.present(alertView, animated: true, completion: nil)
        
    }
    func showAlertPostedGig(_ error: String,_ title: String, VC: UIViewController) {
        
        let alertView = UIAlertController(title: title, message: error, preferredStyle:
            UIAlertControllerStyle.alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: closeVC))
        VC.present(alertView, animated: true, completion: nil)
        
    }
    
    func closeVC(action: UIAlertAction) {
        _=navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getdatesArray () -> NSMutableArray
    {
        let ids = NSMutableArray()
        var dicSet = NSMutableDictionary()
        
        for i in 0..<datesArray.count {
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
            let date = dateFormatter.date(from: datesArray[i])
            let dateFormatterNew = DateFormatter()
            dateFormatterNew.dateFormat = "yyyy-MM-dd"
            let postDate =  dateFormatterNew.string(from: date! as Date)
            
            dicSet = NSMutableDictionary()
            dicSet.setValue(postDate, forKey: "date")
            ids.add(dicSet)
            
        }
        
        return ids
    }
    
    
    @IBAction func sendRequest(_ sender: Any) {
        
        if(datesArray.count == 0)
        {
            self.showAlert("Please Select at least one date","Oops", VC: self)        }else if(connectedToNetwork())
        {
            MakeAPICall()
        }
        else
        {
            self.showAlert("Please check your connection","Oops", VC: self)
        }
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        //
        //        if let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        ////            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        //            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { (zeroAddress) -> in
        //              SCNetworkReachabilityCreateWithAddress(nil, zeroAddress)
        //            })
        //        }) else {
        //            return false
        //        }
        //
        //
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    //
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch calender.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "timeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
//        cell.textLabel?.text="\(String(format: "%02d", indexPath.row)):00:00"
//        cell.textLabel?.textAlignment=NSTextAlignment.center
//        cell.textLabel?.font=UIFont.systemFont(ofSize: 14)
        
        
        if indexPath.row == 0{
            
            ampm="AM"
            hour = 12
            
        }else if indexPath.row < 12{
            
            ampm="AM"
            hour = indexPath.row
            
        }else if indexPath.row == 12{
            
            ampm="PM"
            hour = indexPath.row
            
        }else if indexPath.row > 12{
            
            ampm="PM"
            hour = indexPath.row-12
            
        }
        
        //cell.textLabel?.text="\(String(format: "%02d", indexPath.row)):00:00"
        cell.textLabel?.text="\(hour):00 \(ampm)"
        cell.textLabel?.textAlignment=NSTextAlignment.center
        cell.textLabel?.font=UIFont.systemFont(ofSize: 13)
        
        return cell
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemSelected == false {
        
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let alert = UIAlertController(title: "Alert",
                                          message: "Please Select a Date First",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)

        
        }else{
            
        datesArray.removeAll()
            
        let selectedDate=self.formatterDateOnly.string(from: calender.selectedDate!)
        
        let rows = self.tableView.indexPathsForSelectedRows?.map{$0.row}
          
        
        
        var minValue=rows?.min() as Int!
        let maxValue=rows?.max()
        
        while minValue!<=maxValue!{
            
            let indexpathNew=IndexPath(row: minValue!, section: 0)
            
            self.tableView.selectRow(at: indexpathNew, animated: true, scrollPosition: UITableViewScrollPosition.init(rawValue: indexPath.row)!)
            
            datesArray.append("\(selectedDate) \(String(format: "%02d", indexpathNew.row)):00:00")
            
            
            minValue?+=1
            }
            
            
            print(datesArray)
        
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?{
    
        let selectedDate=self.formatterDateOnly.string(from: calender.selectedDate!)
        
        let rows = self.tableView.indexPathsForSelectedRows?.map{$0.row}
        
        //print(rows ?? "none")
        
        let minValue=rows?.min()
        let maxValue=rows?.max()
        
        if indexPath.row == minValue || indexPath.row == maxValue {
            
            
            if let index = datesArray.index(of:"\(selectedDate) \(String(format: "%02d", indexPath.row)):00:00") {
                datesArray.remove(at: index)
            }
            print(datesArray)
            return indexPath
            
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = "headerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        return cell
        
    }
    
    func deselectAllRows(){
    
        let rows = self.tableView.indexPathsForSelectedRows?.map{$0.row}
        
        print(rows ?? "none")
        
        if rows != nil{
        
            var minValue=rows?.min() as Int!
            let maxValue=rows?.max()
        
            while minValue!<=maxValue!{
            
                let indexpathNew=IndexPath(row: minValue!, section: 0)
            
                self.tableView.deselectRow(at: indexpathNew, animated: true)
            
            
                minValue?+=1
            }
        }
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
