//
//  ActiveProjectTableViewCell.swift
//  Gopher
//
//  Created by User on 2/16/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class ActiveProjectTableViewCell: UITableViewCell {
   
    @IBOutlet weak var userProfilePic: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var ratingStar1: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var ratingStar2: UIImageView!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var ratingStar3: UIImageView!
    @IBOutlet weak var ratingStar4: UIImageView!
    @IBOutlet weak var ratingStar5: UIImageView!
    @IBOutlet weak var readMoreLabel: UILabel!
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var completeAndPay: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
