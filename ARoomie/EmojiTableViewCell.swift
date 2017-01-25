//
//  EmojiTableViewCell.swift
//  ARoomie
//
//  Created by Yong Ching on 25/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {

    @IBOutlet weak var labelEmojiUnicode: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
