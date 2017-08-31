//
//  DropDownTableViewCell.swift
//  V2SwiftComponents
//
//  Created by apoorva on 14/09/16.
//  Copyright © 2016 manish.k. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var filteredText: UILabel!

    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var filteredTextField: V2Textfield!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        filteredTextField.setStyle(.V2TextFieldStylePicker)
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
