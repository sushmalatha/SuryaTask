//
//  DetailsTableViewCell.swift
//  SuryaSoftwaree
//
//  Created by Mac on 06/12/18.
//  Copyright © 2018 Sushma. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var myImageView: UIImageView!

    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
