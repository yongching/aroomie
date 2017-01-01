//
//  DropDownButton.swift
//  DropDown
//
//  Created by Kevin Hirsch on 06/06/16.
//  Copyright © 2016 Kevin Hirsch. All rights reserved.
//

import UIKit

class DropDownButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let imageName = "ic_keyboard_arrow_down"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        addConstraint(NSLayoutConstraint(
            item: imageView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
            )
        )
        
        addConstraint(NSLayoutConstraint(
            item: imageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0
            )
        )
        
        addConstraint(NSLayoutConstraint(
            item: imageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 20
            )
        )
        
        addConstraint(NSLayoutConstraint(
            item: imageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: 20
            )
        )
        
    }
    
}
