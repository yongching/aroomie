//
//  AnnotationView.swift
//  ARoomie
//
//  Created by Yong Ching on 03/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

open class AnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    open var titleLabel: UILabel?
    //public var infoButton: UIButton?
    open var profileImage: UIImageView?
    
    override open func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        if self.titleLabel == nil
        {
            self.loadUi()
        }
    }
    
    func loadUi()
    {
        // Title label
        self.titleLabel?.removeFromSuperview()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        self.addSubview(label)
        self.titleLabel = label
        
        // Profile Image
        self.profileImage?.removeFromSuperview()
        let imageView = UIImageView()
        
        //self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SettingTableViewController.imageViewTapped)))
        //imageView.frame = CGRect(x: 30, y: 0, width: 20, height: 20)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        var randomPic = ["1", "2", "3", "4", "5"]
        let diceRoll = Int(arc4random_uniform(5))
        imageView.image = UIImage(named: randomPic[diceRoll])
        self.addSubview(imageView)
        self.profileImage = imageView
        
        /*
         // Info button
         self.infoButton?.removeFromSuperview()
         let button = UIButton(type: UIButtonType.DetailDisclosure)
         button.userInteractionEnabled = false   // Whole view will be tappable, using it for appearance
         self.addSubview(button)
         self.infoButton = button
         */
        
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AnnotationView.tapGesture))
        self.addGestureRecognizer(tapGesture)
        
        // Other
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.cornerRadius = 5
        
        if self.annotation != nil
        {
            self.bindUi()
        }
    }
    
    func layoutUi()
    {
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        
        self.titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - buttonWidth - 5, height: self.frame.size.height);
        self.profileImage?.frame = CGRect(x: self.frame.size.width - buttonWidth - 10, y: self.frame.size.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight);
        //self.infoButton?.frame = CGRectMake(self.frame.size.width - buttonWidth, self.frame.size.height/2 - buttonHeight/2, buttonWidth, buttonHeight);
    }
    
    // This method is called whenever distance/azimuth is set
    override open func bindUi()
    {
        if let annotation = self.annotation, let title = annotation.title
        {
            let distance = annotation.distanceFromUser > 1000 ? String(format: "%.1fkm", annotation.distanceFromUser / 1000) : String(format:"%.0fm", annotation.distanceFromUser)
            
            //            let text = String(format: "%@\nAZ: %.0f°\nDST: %@", title, annotation.azimuth, distance)
            let text = String(format: "%@\nDST: %@", title, distance)
            self.titleLabel?.text = text
        }
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layoutUi()
    }
    
    open func tapGesture()
    {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ViewAdvertisement") as! UINavigationController
        //let currentViewController = self.getCurrentViewController()
        //currentViewController?.present(vc, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
}
