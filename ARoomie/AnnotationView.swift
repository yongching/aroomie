//
//  AnnotationView.swift
//  ARoomie
//
//  Created by Yong Ching on 03/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import Kingfisher

open class AnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    open var titleLabel: UILabel?
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
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        if let pictureUrl = self.annotation?.pictureUrl {
            let url = URL(string: pictureUrl)
            imageView.kf.setImage(with: url)
            /*
            do {
                imageView.image = try UIImage(data: Data(contentsOf: URL(string: pictureUrl)!))
            } catch _ {
                print("Profile picture not found")
            }
            */
        }
        self.addSubview(imageView)
        self.profileImage = imageView
        
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:)))
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
        let width: CGFloat = 40
        let height: CGFloat = 40
        
        self.titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - width - 5, height: self.frame.size.height)
        self.profileImage?.frame = CGRect(x: self.frame.size.width - width - 10, y: self.frame.size.height/2 - height/2, width: width, height: height)
    }
    
    // This method is called whenever distance/azimuth is set
    override open func bindUi()
    {
        if let annotation = self.annotation, let title = annotation.title
        {
            let distance = annotation.distanceFromUser > 1000 ? String(format: "%.1fkm", annotation.distanceFromUser / 1000) : String(format:"%.0fm", annotation.distanceFromUser)
            
            // let text = String(format: "%@\nAZ: %.0f°\nDST: %@", title, annotation.azimuth, distance)
            let text = String(format: "%@\nDST: %@", title, distance)
            self.titleLabel?.text = text
        }
    }
    
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layoutUi()
    }
    
    func tapGesture(_ sender: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "ViewAdvertisement") as! UINavigationController
        let adDetailsTableViewController = navigationController.viewControllers[0] as! AdDetailsTableViewController
        adDetailsTableViewController.advertisementId = self.annotation?.advertisementId
        let currentViewController = self.getCurrentViewController()
        currentViewController?.present(navigationController, animated: true, completion: nil)
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
