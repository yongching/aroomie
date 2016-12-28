//
//  CustomCell.swift
//  ARoomie
//
//  Created by Yong Ching on 25/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import Foundation

class CustomCell: UITableViewCell {

    var titleLabel: UILabel!
    var detailLabel: UILabel!
    
    init(frame: CGRect, title: String, detail: String) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "profileCell")
        
        let titleLabel_x: CGFloat = 16.0
        let titleLabel_width: CGFloat = 80.0
        let y: CGFloat = 4.0
        let height: CGFloat = 40.0
        
        titleLabel = UILabel(frame: CGRect(x: titleLabel_x, y: y, width: titleLabel_width, height: height))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.text = title
        
        detailLabel = UILabel(frame: CGRect(x: titleLabel_x + titleLabel_width, y: y, width: 200.0, height: height))
        detailLabel.textColor = UIColor.gray
        detailLabel.font = UIFont.systemFont(ofSize: 15.0)
        detailLabel.text = detail

        addSubview(titleLabel)
        addSubview(detailLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
