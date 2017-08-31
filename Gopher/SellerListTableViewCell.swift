//
//  GigListTableViewCell.swift
//  Gopher
//
//  Created by User on 3/7/17.
//  Copyright © 2017 Dinosoft. All rights reserved.
//

import UIKit

class SellerListTableViewCell: UITableViewCell {
    @IBOutlet weak var gigProfileImg: UIButton!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var deadLineText: UILabel!
    @IBOutlet weak var gigContact: UIButton!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var gigDistance: UILabel!
    @IBOutlet weak var gigName: UILabel!
    @IBOutlet weak var amountAndType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
