//
//  NotificationTableViewCell.swift
//  Gopher
//
//  Created by User on 3/13/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var rentalTotalLabel: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var ignoreBtn: UIButton!
    @IBOutlet weak var gigImage: UIImageView!
    //@IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    //@IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var rentalPeriodLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
