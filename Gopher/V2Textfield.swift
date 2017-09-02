//
//  V2Textfield.swift
//  V2SwiftComponents
//
//  Created by Dinesh.sharma on 12/09/16.
//  Copyright © 2016 manish.k. All rights reserved.
//

import Foundation
import UIKit

let textFieldBorderWidth = 1.0
let textFieldCornerRadius = 2.0
let textFieldDefaultText = ""
let textFieldDefaultEmailText = "Email"
let textFieldDefaultPasswordText = "Password"
let textFieldDefaultPhoneText = "Phone Number"
let textFieldDefaultZIPCodeText = "ZIP Code"

enum V2TextFieldStatus: Int {
    case V2TextFieldStatusDefault
    case V2TextFieldStatusError
}

enum V2TextFieldStyle: Int {
    case V2TextFieldStyleDefault
    case V2TextFieldStyleEmail
    case V2TextFieldStylePassword
    case V2TextFieldStylePhoneNumber
    case V2TextFieldStyleZipcode
    case V2TextFieldStyleDatePicker
    case V2TextFieldStyleUserName
    case V2TextFieldStylePicker
    case V2TextFieldStylePasswordWithBottomBorder
    case V2TextFieldStyleNumberOfRecordsCountDefault
}

enum V2TextFieldBorder: Int {
    case Left
    case Right
    case Top
    case Bottom
    case All
}

enum V2TextFieldBorderStyle: Int {
    case V2TextFieldWithBorder
    case V2TextFieldWithOutBorder
}

class V2Textfield: UITextField, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var datePickerView: UIDatePicker?
    
    var status: V2TextFieldStatus = .V2TextFieldStatusDefault
    var style: V2TextFieldStyle = .V2TextFieldStyleDefault
    var textFieldBorderStyle: V2TextFieldBorderStyle = .V2TextFieldWithOutBorder
    var borderColors = [AnyObject]()
    var placeHolderString = ""
    var inputMaskString: String?
    var textFieldImage: UIImage!
    var datePicker: UIDatePicker!
    var date: NSDate?
    var pickerView = UIPickerView()
    var data = [String]()
    var sortData = [String]()
    var data1 = [String]()
    var data2 = [String]()
    var minimumPrice = ""
    var maximumPrice = ""
    var rightImageName: String?
    
    func commonInit() {
        
        self.font = UIFont.systemFont(ofSize: 12)
        self.delegate = self
        datePickerView = UIDatePicker()
        textFieldBorderStyle = V2TextFieldBorderStyle(rawValue: V2TextFieldBorderStyle.V2TextFieldWithOutBorder.rawValue)!
        self.borderColors = [UIColor.black, UIColor.black]
        self.textColor = UIColor.black
        
        self.leftViewMode =  .always
        self.autocorrectionType = .no
        self.layoutIfNeeded()
        
        self.updateSelf()
        date = NSDate()
        sortData = ["Best Match", "Lowest to Highest Price", "Highest to Lowest Price"]
       // data1 = priceArray
       // data2 = priceArray
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func setStatus(status: V2TextFieldStatus) {
        self.commonInit()
        self.status = status
    }
    
    func setStyle(style: V2TextFieldStyle, border: V2TextFieldBorderStyle) {
        if style != style {
            self.style = style
            self.font =  UIFont.systemFont(ofSize: 15)
            self.textFieldBorderStyle = border
        }
        self.font = UIFont.systemFont(ofSize: 15)
        
        self.commonInit()
        self.style = style
        self.textFieldBorderStyle = border
        self.updateStyle()
    }
    
    
    func setStyle(_ style: V2TextFieldStyle) {
        if style != style {
            self.style = style
            self.font = UIFont.systemFont(ofSize: 15)
        }
        self.font = UIFont.systemFont(ofSize: 15)
        
        self.commonInit()
        self.style = style
        self.updateStyle()
    }
    
    func setBorderStyle(borderStyle: V2TextFieldBorderStyle) {
        self.textFieldBorderStyle = borderStyle
    }
    
    
    func updateSelf() {
        self.layer.borderColor = self.borderColors[self.status.rawValue].cgColor
        self.layer.layoutIfNeeded()
        self.layer.masksToBounds = true
    }
    
    
    
    func updateStyle() {
        
        if self.textFieldBorderStyle == .V2TextFieldWithBorder {
            self.delegate = self
            self.layoutIfNeeded()
            self.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.black, withBorderWidth: 1)
        }
        else {
            self.borderStyle = .none
        }
        
        switch self.style {
            
        case .V2TextFieldStyleDatePicker:
            self.delegate = self
            self.text = ""
            self.textColor = UIColor.black
            self.leftViewMode = .always
            
            let imageView = UIImageView(image: UIImage(named: "downArrow")!)
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 8))
            
            let rightPaddingForTextField = UIView(frame: rect)
            rightPaddingForTextField.addSubview(imageView)
            self.rightViewMode = .always
            self.rightView? = rightPaddingForTextField
            self.setAttributedText(defaultPlaceholder: "DOB")
            break
        case .V2TextFieldStylePicker:
            self.delegate = self
            pickerView.delegate = self
            pickerView.dataSource = self
            
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 30, height: 30))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            
            if String(self.tag) == "100" {
                data = sortData
            }
            break
        case .V2TextFieldStyleUserName:
            self.delegate = self
            self.text = ""
            self.textColor = UIColor.black
            self.keyboardType = .default
            self.setAttributedText(defaultPlaceholder: textFieldDefaultText)
            break
        case .V2TextFieldStyleEmail:
            self.delegate = self
            self.textColor = UIColor.black
            self.backgroundColor = UIColor.white
            self.keyboardType = .emailAddress
            self.setAttributedText(defaultPlaceholder: textFieldDefaultEmailText)
            break
        case .V2TextFieldStylePasswordWithBottomBorder:
            self.delegate = self
            self.text = ""
            self.textFieldImage = UIImage(named: "passwordImage")!
            self.textColor = UIColor.black
            self.setAttributedText(defaultPlaceholder: textFieldDefaultPasswordText)
            self.keyboardType = .default
            self.isSecureTextEntry = true
            let leftIcon = UIImageView(image: self.textFieldImage)
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.textFieldImage.size.width + 15, height: self.frame.size.height))
            
            leftIcon.frame = rect
            leftIcon.contentMode = .left
            self.leftViewMode = .always
            self.leftView! = leftIcon
            self.autocorrectionType = .no
            break
        case .V2TextFieldStylePassword:
            self.delegate = self
            self.textFieldBorderStyle = .V2TextFieldWithBorder
            self.textColor = UIColor.black
            self.keyboardType = .default
            self.isSecureTextEntry = true
            self.setAttributedText(defaultPlaceholder: textFieldDefaultPasswordText
            
            )
            break
            
        case .V2TextFieldStyleDefault:
            self.keyboardType = .default
            self.textColor = UIColor.black
            self.setAttributedText(defaultPlaceholder: textFieldDefaultText)
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 40, height: 40))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            break
            
        case .V2TextFieldStyleNumberOfRecordsCountDefault:
            self.keyboardType = .numberPad
            self.textColor = UIColor.black
            break
        case .V2TextFieldStyleZipcode:
            self.textColor = UIColor.black
            self.backgroundColor = UIColor.white
            self.setAttributedText(defaultPlaceholder: textFieldDefaultZIPCodeText)
            self.keyboardType = .numberPad
            break
        case .V2TextFieldStylePhoneNumber:
            self.textColor = UIColor.black
            self.backgroundColor = UIColor.white
           self.setAttributedText(defaultPlaceholder: textFieldDefaultPhoneText)
            self.keyboardType = .phonePad
            break
            
        }
    }
    
    func setAttributedText(defaultPlaceholder: String) {
        if self.placeHolderString.isEmpty || self.placeHolderString == "" {
            self.attributedPlaceholder = NSAttributedString(string: defaultPlaceholder, attributes: [NSForegroundColorAttributeName: UIColor.black])
        }
        else {
            self.attributedPlaceholder = NSAttributedString(string: self.placeHolderString, attributes: [NSForegroundColorAttributeName: UIColor.black])
        }
    }
    
    func setBorderToTextField(vBorder: V2TextFieldBorder, withBorderColor borderColor: UIColor, withBorderWidth borderWidth: CGFloat) {
        let border = CALayer()
        var rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        switch vBorder {
        case .Left:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: borderWidth, height: self.frame.size.height))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .Right:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: self.frame.size.width - borderWidth, y: 0), size: CGSize(width: borderWidth, height: self.frame.size.height))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .Top:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.size.width, height: borderWidth))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .Bottom:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: 0, y: self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: 2))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .All:
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        }
    }
    
    func formatInput(aTextField: UITextField, aString: String, aRange: NSRange) {
        // Copying the contents of UITextField to an variable to add new chars later
        let value = aTextField.text
        var formattedValue = value
        // Make sure to retrieve the newly entered char on UITextField
        // aRange.length = 1
        let myNSRange = NSRange(location: aRange.location, length: 1)
        // var mask  = inputMaskString.substring(with: myNSRange<String.Index>)
        let index1 = inputMaskString?.index((inputMaskString?.endIndex)!, offsetBy: myNSRange.length)
        
        let mask = inputMaskString?.substring(to: index1!)
        // Checking if there's a char mask at current position of cursor
        
        if mask != nil {
            let regex = "[0-9]*"
            let regextest = NSPredicate(format: "SELF MATCHES %@", regex)
            // Checking if the character at this position isn't a digit
            if !regextest.evaluate(with: mask) {
                // If the character at current position is a special char this char must be appended to the user entered text
                formattedValue = formattedValue! + mask!
            }
            if aRange.location + 1 < (self.inputMaskString?.characters.count)! {
                let range = NSRange(location: aRange.location + 1, length: 1)
                let index1 = inputMaskString?.index((inputMaskString?.endIndex)!, offsetBy: range.length)
                let mask = inputMaskString?.substring(to: index1!)
                if mask == " " {
                    formattedValue = formattedValue! + mask!
                }
            }
        }
        
        // Adding the user entered character
        formattedValue = formattedValue! + aString
        // Refreshing UITextField value
        aTextField.text = formattedValue
    }
    
    func setText(string: String, For aTextField: UITextField) {
        aTextField.text = aTextField.text! + string
    }
    
    
    func convertDateFromstring(textField: String, dateFormatter: DateFormatter) -> NSDate {
        let regex = try! NSRegularExpression(pattern: " / ", options: NSRegularExpression.Options.caseInsensitive)
        // Replace the matches
        let modifiedString = regex.stringByReplacingMatches(in: textField, options: [], range: NSMakeRange(0, textField.characters.count), withTemplate: "/")
        let date = dateFormatter.date(from: modifiedString)!
        return date as NSDate
    }
    
    func addDatePickerToTextField() {
        datePickerView?.datePickerMode = .date
        datePickerView?.maximumDate = Date()
        self.inputView = datePickerView
        datePickerView?.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
    }
    
    func handleDatePicker(sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date = (sender as! UIDatePicker).date as NSDate!
    }
    
    func setDateFormat(selectDate: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let strDate = dateFormatter.string(from: selectDate as Date)
        return strDate
    }
    
    func addButtonToPickerTextField() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputView = datePickerView
        self.inputAccessoryView = toolBar
    }
    
    func donePicker() {
        if self.style == .V2TextFieldStyleDatePicker {
            if (self.text?.characters.count)! > 1 {
                self.text = self.setDateFormat(selectDate: date!)
            }
            else {
                self.text = self.setDateFormat(selectDate: date!)
            }
        }
        self.resignFirstResponder()
        
    }
    
    func cancelDatePicker() {
        if self.style == .V2TextFieldStyleDatePicker {
            if (self.text?.characters.count)! > 1 {
            }
            else {
                self.text = ""
            }
        }
        self.resignFirstResponder()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.style == .V2TextFieldStyleDatePicker {
            self.addDatePickerToTextField()
            self.addButtonToPickerTextField()
        }

        
        
        if self.textFieldBorderStyle == .V2TextFieldWithBorder {
            self.delegate = self
        }
        
        if self.tag == 103 {
            if (self.text?.contains(" Miles"))! {
                self.text = self.text?.replacingOccurrences(of: " Miles", with: "")
                
            }
        }

        
        if self.style == .V2TextFieldStylePicker {
            if self.tag == 100 {
                self.data = sortData
            }
            if self.tag == 102 {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                self.data = (appDelegate?.categoryNameArray)!

            }
            self.inputView = pickerView
            self.addButtonToPickerViewTextField()
        }

    }
    
    func addButtonToPickerViewTextField() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputView = pickerView
        self.inputAccessoryView = toolBar
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if self.text?.characters.count == 0 || range.location == 0 {
            if string.characters.count > 0 {
                if !(string == "") {
                    self.formatInput(aTextField: textField, aString: string, aRange: range)
                    return false
                }
                return true
            }
            return true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.delegate = self
        cancelDatePicker()
        
        let trimmedString = textField.text?.trimmingCharacters(in: .whitespaces)
        textField.text = trimmedString
        if self.textFieldBorderStyle == .V2TextFieldWithBorder {
            
        }
        
        if self.style == .V2TextFieldStylePicker {
            DispatchQueue.main.async {
               self.resignFirstResponder() 
            }
            
        }
        
        if self.tag == 103 {
            if !(self.text?.contains(" Miles"))! && ((self.text?.characters.count)! > 0){
                self.text = self.text?.appending(" Miles")

            }
        }
       

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.tag == 104 {
            return 2
        }
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if self.tag == 104 {
            if component == 0 {
                return data1.count

            }  else {
                return data2.count

            }
        }
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.tag == 104 {
            if component == 0 {
                return data1[row]
                
            }  else {
                return data2[row]
                
            }
        }

        return data[row]
        //return "\(String(describing: data[row].value(forKey: "Name")!))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if self.tag == 104 {
            
            if component == 0 {
               // self.text = data1[row]
                minimumPrice = data1[row]
                self.text  = minimumPrice + "-" + maximumPrice

                
            }  else {
                maximumPrice = data2[row]
                self.text  = minimumPrice + "-" + maximumPrice
            }
            

            
        }else {
            self.text = data[row]
        }
    }

}
