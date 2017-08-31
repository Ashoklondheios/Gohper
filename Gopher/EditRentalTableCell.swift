//
//  EditRentalTableCell.swift
//  Gopher
//
//  Created by Ashok Londhe on 24/05/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class EditRentalTableCell: UITableViewCell {

    @IBOutlet weak var activeStatus: UISwitch!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var EditBtn: UIButton!
    @IBOutlet weak var gigImage: UIImageView!
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var dailyRatesLabel: UILabel!
    @IBOutlet weak var hourlyRatesLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        EditBtn.layer.borderWidth = 1
        EditBtn.layer.borderColor = UIColor(red: 85.0/255.0, green: 160.0/255.0, blue: 191.0/255.0, alpha: 1).cgColor
        
        deleteBtn.layer.borderWidth = 1
        deleteBtn.layer.borderColor = UIColor(red: 85.0/255.0, green: 160.0/255.0, blue: 191.0/255.0, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
