//
//  AvailabilityCalenderViewController.swift
//  Gopher
//
//  Created by Ashok Londhe on 23/05/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

import FSCalendar

protocol AvailabilityCalenderDatesProtocol: class {
    func sendDatesArrayToPreviousVC(dates: Array<String>)
    
}

class AvailabilityCalenderViewController: UIViewController, FSCalendarDelegate {
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    var imageUrl = "" as String
    var gigTitle = "" as String

    @IBOutlet weak var calender: FSCalendar!
    
    var selectedDatesArray = NSMutableArray()
    var selectedImageArray = NSMutableArray()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    var datesArray = [String]()
    weak var datesDelegate: AvailabilityCalenderDatesProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //calender
        if imageUrl != ""
        {
            mainImage.sd_setImage(with: URL(string: imageUrl))
        }
        else
        {
            mainImage.image=UIImage(named: "placeholder.png")
        }
        
        mainTitleLabel.text=gigTitle
        
//        if imageUrl != "" {
//            
//            
//        }
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
