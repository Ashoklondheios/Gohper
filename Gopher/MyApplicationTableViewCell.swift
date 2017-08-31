//
//  MyApplicationTableViewCell.swift
//  Gopher
//
//  Created by User on 4/4/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class MyApplicationTableViewCell: UITableViewCell {
    @IBOutlet weak var myAppuserProfilePic: UIButton!
    @IBOutlet weak var myAppuserName: UILabel!
    @IBOutlet weak var myAppdescriptionText: UILabel!
    @IBOutlet weak var myApprate: UILabel!
    @IBOutlet weak var myAppratingStar1: UIImageView!
    @IBOutlet weak var myApplocation: UILabel!
    @IBOutlet weak var myAppcategories: UILabel!
    @IBOutlet weak var myAppratingStar2: UIImageView!
    @IBOutlet weak var myAppdeadline: UILabel!
    @IBOutlet weak var myAppratingStar3: UIImageView!
    @IBOutlet weak var myAppratingStar4: UIImageView!
    @IBOutlet weak var myAppratingStar5: UIImageView!
    @IBOutlet weak var myAppreadMore: UIButton!
    @IBOutlet weak var myAppcompleteAndPay: UIButton!
    @IBOutlet weak var readMoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
