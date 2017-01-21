//
//  MessageTableViewCell.swift
//  ARoomie
//
//  Created by Yong Ching on 20/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        profileAvatar.layer.cornerRadius = 50 / 2
        profileAvatar.layer.borderWidth = 0.5
        profileAvatar.layer.borderColor = UIColor.black.cgColor
        profileAvatar.clipsToBounds = true
    }

}
