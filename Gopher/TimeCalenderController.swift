//
//  TimeCalenderController.swift
//  Gopher
//
//  Created by User on 6/30/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalenderDatesProtocol: class {
    func sendDatesArrayToPreviousVC(dates: Array<String>)
}
class TimeCalenderController:UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDelegate, UIGestureRecognizerDelegate  {
   
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var imageUrl = "" as String
    var gigTitle = "" as String
    
    @IBOutlet weak var calender: FSCalendar!
    var selectedDatesArray=NSMutableArray()
    
    fileprivate let formatter: DateFormatter = {
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
    weak var datesDelegate: CalenderDatesProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)

        
        
        
        //mainTitleLabel.text=gigTitle
        
        
        if selectedDatesArray.count>0 {
            
            for i in 0..<calender.selectedDates.count {
                
                calender.deselect(calender.selectedDates[i])
            }
            
            
            for (_, object) in selectedDatesArray.enumerated()
            {
                let item = object as! CalenderObject
                
                print(item.calenderDate)
                
                if let selectedDate=Commons.getDatefromString(dateFrom: item.calenderDate){
                    
                    
                    calender.select(selectedDate)
                    datesArray.append(self.formatter.string(from: selectedDate))
                    
                }
                
                
                
            }
            
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        print(datesArray)
        datesDelegate?.sendDatesArrayToPreviousVC(dates: self.datesArray)
        _ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- UIGestureRecognizerDelegate
    
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
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool{
        
        //        if selectedDatesArray.count>0 {
        //            return false
        //        }
        
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.formatter.string(from: date))")
        datesArray.append(self.formatter.string(from: date))
        // self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        if let index = datesArray.index(of: self.formatter.string(from: date)) {
            datesArray.remove(at: index)
        }
        
        print("did deselect date \(self.formatter.string(from: date))")
        //  self.configureVisibleCells()
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [2,20][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = ["cell_month", "cell_week"][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            return cell
        }
    }
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            //let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            //calendar.setScope(scope, animated: self.animationSwitch.isOn)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
