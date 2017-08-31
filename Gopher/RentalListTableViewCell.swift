//
//  RentalListTableViewCell.swift
//  Gopher
//
//  Created by Ashok Londhe on 24/05/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class RentalListTableViewCell: UITableViewCell {

    @IBOutlet weak var rentButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var gigImage: UIImageView!
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var dailyRatesLabel: UILabel!
    @IBOutlet weak var hourlyRatesLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        rentButton.layer.borderWidth = 1
        rentButton.layer.borderColor = UIColor(red: 85.0/255.0, green: 160.0/255.0, blue: 191.0/255.0, alpha: 1).cgColor
        
        contactButton.layer.borderWidth = 1
        contactButton.layer.borderColor = UIColor(red: 85.0/255.0, green: 160.0/255.0, blue: 191.0/255.0, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
