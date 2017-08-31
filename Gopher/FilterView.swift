//
//  FilterView.swift
//  Gopher
//
//  Created by Ashok Londhe on 26/08/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class FilterView: UIView {

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var sortTextField: V2Textfield!
    
    @IBOutlet weak var categoryTextField: V2Textfield!
    
    @IBOutlet weak var distanceTextField: V2Textfield!
    
    @IBOutlet weak var priceTextField: V2Textfield!
    
    @IBOutlet weak var paymentTypeTextField: V2Textfield!
    
    @IBOutlet weak var availiablityCalenderTextField: V2Textfield!
    
    @IBOutlet weak var filterHeaderView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    

    override func awakeFromNib() {
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        
        Bundle.main.loadNibNamed("FilterView", owner: self, options: nil)
        self.addSubview(self.view)
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = UIColor.white
        self.view.layoutIfNeeded()
       // setupTextFields()
    }

    
    func setupTextFields() {
        sortTextField.setStyle(.V2TextFieldStylePicker)
        categoryTextField.setStyle(.V2TextFieldStylePicker)
        distanceTextField.setStyle(.V2TextFieldStyleNumberOfRecordsCountDefault)
        priceTextField.setStyle(.V2TextFieldStyleDefault)
        paymentTypeTextField.setStyle(.V2TextFieldStylePicker)
        availiablityCalenderTextField.setStyle(.V2TextFieldStyleDefault)
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
