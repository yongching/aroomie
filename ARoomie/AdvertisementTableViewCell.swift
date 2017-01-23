//
//  AdvertisementTableViewCell.swift
//  ARoomie
//
//  Created by Yong Ching on 23/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class AdvertisementTableViewCell: UITableViewCell {

    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var labelPlace: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
