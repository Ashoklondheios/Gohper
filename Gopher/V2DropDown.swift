//
//  V2DropDown.swift
//  V2SwiftComponents
//
//  Created by apoorva on 12/09/16.
//  Copyright © 2016 manish.k. All rights reserved.
//

import UIKit
import Foundation

enum DropDownAnimationStyle {
    case DropDownDefault
    case DropDownBouncing
}

class V2DropDown: UIControl, UITableViewDelegate, UITableViewDataSource {
    
    var style: DropDownAnimationStyle = .DropDownDefault
    var placeholder: NSString!
    var optionsArray: NSMutableArray = []
    var detailsArray: NSMutableArray = []
    var filterCell: DropDownTableViewCell?
    var price = ""
    var selectedDate = ""
    var sort = ""
    var category = ""
    var distance = ""
    
    
    
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    var dateString = "" {
        didSet{
            self.table.reloadData()
        }
    }
    @IBOutlet var view: UIView!
    @IBOutlet weak var table: UITableView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("V2DropDown", owner: self, options: nil)
        table.register(UINib(nibName: "DropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        addSubview(view)
        
        rangeSlider.minimumValue = 0.0
        rangeSlider.maximumValue = 2000.0
        rangeSlider.lowerValue = 1
        rangeSlider.upperValue = 2000
        // table.isHidden = true
    }
    
    override func layoutSubviews() {
        view.frame = bounds
        view.setNeedsLayout()
    }
    
    
    
    func touch() {
        isSelected = !isSelected
        isSelected ? (showTable()) : (hideTable())
    }
    
    override func resignFirstResponder() -> Bool {
        if isSelected {
            hideTable()
        }
        return true
    }
    
    func showTable() {
        table.isHidden = false
        table.reloadData()
        
        
        switch style {
        case .DropDownDefault:
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1,
                           options: .transitionFlipFromTop,
                           animations: { () -> Void in
                            self.table.alpha = 1
            }, completion: { (finished: Bool) -> Void in
                self.table.isHidden = false
                self.isUserInteractionEnabled = true
                self.isSelected = true
            })
            table.reloadData()
            
            break
        case .DropDownBouncing:
            
            table.transform =  CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: .transitionCurlUp,
                           animations: { () -> Void in
                            
                            let rotate = CGAffineTransform(rotationAngle: 0.000)
                            self.table.transform = CGAffineTransform.identity
                            self.table.transform = rotate.translatedBy(x: 0.0, y: 0.0)
                            self.table.alpha = 1
            }, completion: { (finished: Bool) -> Void in
                self.table.isHidden = false
                self.isUserInteractionEnabled = true
                self.isSelected = true
            })
            table.reloadData()
            break
        }
        table.reloadData()
    }
    
    func hideTable() {
        //    table.isHidden = true
        
        switch style {
        case .DropDownDefault:
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.1,
                           options: .transitionFlipFromBottom,
                           animations: { () -> Void in
                            self.table.alpha = 0
            }, completion: { (finished: Bool) -> Void in
                //self.table.isHidden = true
                self.isUserInteractionEnabled = true
                self.isSelected = false
            })
            table.reloadData()
            break
            
        case .DropDownBouncing:
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.1,
                           options: .transitionCurlUp,
                           animations: { () -> Void in
                            self.table.alpha = 0
            }, completion: { (finished: Bool) -> Void in
                // self.table.isHidden = true
                self.isUserInteractionEnabled = true
                self.isSelected = false
            })
            table.reloadData()
            break
        }
        table.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
        DropDownTableViewCell
        filterCell = cell
        cell!.preservesSuperviewLayoutMargins = false
        cell?.titleLabel?.text = optionsArray[indexPath.row] as? String
        cell?.filteredText?.text = detailsArray[indexPath.row] as? String
        if indexPath.row == 0 {
            cell?.filteredTextField.tag = 100
            cell?.filteredTextField.rightImageName = "downArrow"
            cell?.filteredTextField.setStyle(.V2TextFieldStylePicker)
            sort = (cell?.filteredTextField.text)!
        }
        if indexPath.row == 1 {
            cell?.filteredTextField.tag = 101
            cell?.filteredTextField.placeholder = "Calender"
            cell?.filteredTextField.rightImageName = "calender_icon"
            cell?.filteredTextField.resignFirstResponder()
            cell?.filteredTextField.endEditing(true)
            self.view.endEditing(true)
            cell?.filteredTextField.setStyle(.V2TextFieldStyleDefault)
            //cell?.filteredTextField.endEditing(false)
            cell?.filteredTextField.addTarget(self, action: #selector(self.calenderTapped), for: .editingDidBegin)
            cell?.filteredTextField.text = dateString
            
        }
        
        if indexPath.row == 2 {
            cell?.filteredTextField.tag = 102
            cell?.filteredTextField.placeholder = "Category"
            cell?.filteredTextField.rightImageName = "downArrow"
            cell?.filteredTextField.setStyle(.V2TextFieldStylePicker)
            category = (cell?.filteredTextField.text)!
        }
        
        if indexPath.row == 3 {
            cell?.filteredTextField.placeholder = "Distance"
            cell?.filteredTextField.rightImageName = ""
            cell?.filteredTextField.setStyle(.V2TextFieldStyleNumberOfRecordsCountDefault)
            cell?.filteredTextField.isSelected = true
            cell?.filteredTextField.tag = 103
            distance =  (cell?.filteredTextField.text)!
        }
        
        if indexPath.row == 4 {
            cell?.filteredTextField.rightImageName = ""
            cell?.filteredTextField.placeholder = "Min-Max"
            cell?.filteredTextField.rightImageName = ""
            cell?.filteredTextField.setStyle(.V2TextFieldStyleNumberOfRecordsCountDefault)
            setUpRangeSlider()
            cell?.filteredTextField.tag = 104
        }
        filterCell = cell
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // self.hideTable()
        self.table.reloadData()
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        self.isHidden = true
        var minPrice = ""
        var maxPrice = ""
        for i in 0..<5 {
            filterCell = self.table.cellForRow(at: IndexPath(row: i, section: 0)) as? DropDownTableViewCell
            if i == 0 {
                sort = (filterCell?.filteredTextField.text)!
            } else if i == 1 {
                dateString = (filterCell?.filteredTextField.text)!
                
            } else if i == 2{
                category = (filterCell?.filteredTextField.text)!
                
            } else if i == 3 {
                distance = (filterCell?.filteredTextField.text)!
                distance = distance.replacingOccurrences(of: " Miles", with: "")
                
            } else {
                //  sort = (filterCell?.filteredTextField.text)!
                minPrice = "\(Int(rangeSlider.lowerValue))"
                maxPrice = "\(Int(rangeSlider.upperValue))"
            }
            
            
            
        }
        let userInfo = ["sort": sort, "date": dateString, "category": category, "distance": distance, "minPrice": minPrice, "maxPrice": maxPrice]
        NotificationCenter.default.post(name:  NSNotification.Name(rawValue: "filterDoneTapped"), object: nil, userInfo: userInfo)
        
    }
    
    
    func calenderTapped() {
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "calenderTapped"), object: nil)
    }
    
    func sliderValueChanged(sender: UISlider)  {
        filterCell?.filteredTextField.text = "\(Int(sender.value))"
        print(sender.value)
    }
    
    func setUpRangeSlider(){
        rangeSlider.frame = CGRect(x: 45, y: (filterCell?.filteredTextField.frame.origin.y)! + 5, width: (self.filterCell?.frame.size.width)! - (self.filterCell?.filteredTextField.frame.width)!/2, height: 32.0)
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        filterCell?.addSubview(rangeSlider)
    }
    
    func rangeSliderValueChanged() { //rangeSlider: RangeSlider
        filterCell?.filteredTextField.text = "$\(Int(rangeSlider.lowerValue)) - $\(Int(rangeSlider.upperValue))"
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        filterCell?.filteredTextField.pickerView.isHidden = true
        
    }
    
    
}
