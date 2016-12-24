//
//  SettingViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 24/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label


enum contentTypes {
    case tweets, media
}

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // MARK: Outlet properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var segmentedView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    // MARK: Class properties
    
    var headerBlurImageView: UIImageView!
    var headerImageView: UIImageView!
    var contentToDisplay : contentTypes = .tweets
    
    // MARK: Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add extra scrollable space at top n bottom
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, (headerView.frame.height * 2) + 12, 0)
        tableView.tableHeaderView = profileView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Header - Image
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView?.image = UIImage(named: "header")
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        headerBlurImageView = UIImageView(frame: headerView.bounds)
        headerBlurImageView?.image = UIImage(named: "header")?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        headerView.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        headerView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table view processing
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch contentToDisplay {
        case .tweets:
            return 3
            
        case .media:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch contentToDisplay {
        case .tweets:
            cell.textLabel?.text = "Tweet Tweet!"
            
        case .media:
            cell.textLabel?.text = "Piccies!"
            cell.imageView?.image = UIImage(named: "bg")
        }
        
        return cell
    }
    
    // MARK: Scroll view delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        //print("scrollViewoffset\(scrollView.contentOffset.y)")
        //print("headerViewheight\(headerView.bounds.height)")
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // Pull down
        if offset < 0 {
            
            // Header
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            // Hide views if scrolled super fast
            headerView.layer.zPosition = 0
            headerLabel.isHidden = true
        }
            
        // Scroll up or down
        else {
            
            // Header will stop it's transformation to smaller when it reaches 40
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            //print(-offset_HeaderStop)
            //print(-offset)
            
            // Label
            headerLabel.isHidden = false
            let alignToNameLabel = -offset + handleLabel.frame.origin.y + headerView.frame.height + offset_HeaderStop
            
            headerLabel.frame.origin = CGPoint(x: headerLabel.frame.origin.x, y: max(alignToNameLabel, distance_W_LabelHeader + offset_HeaderStop))
            
            // Blur
            headerBlurImageView?.alpha = min (1.0, (offset - alignToNameLabel)/distance_W_LabelHeader)
            
            // Avatar
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            // Set frontmost layer to avatar if offset <= offset_HeaderStop
            if offset <= offset_HeaderStop {
                if avatarImage.layer.zPosition < headerView.layer.zPosition {
                    headerView.layer.zPosition = 0
                }
            } else {
                // set frontmost layer to header
                if avatarImage.layer.zPosition >= headerView.layer.zPosition {
                    headerView.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
        
        // Segment control
        let segmentViewOffset = profileView.frame.height - segmentedView.frame.height - offset
        //print("\(profileView.frame.height),\(segmentedView.frame.height),\(offset)")
        //print(segmentViewOffset)
        
        var segmentTransform = CATransform3DIdentity
        // Scroll the segment view until its offset reaches the same offset at which the header stopped shrinking
        segmentTransform = CATransform3DTranslate(segmentTransform, 0, max(segmentViewOffset, -offset_HeaderStop), 0)
        segmentedView.layer.transform = segmentTransform
        
        // Set scroll view insets just underneath the segment control
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(segmentedView.frame.maxY, 0, 0, 0)
    }
    
    // MARK: Interface buttons
    
    @IBAction func selectContentType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            contentToDisplay = .tweets
        }
        else {
            contentToDisplay = .media
        }
        
        tableView.reloadData()
    }
    
}

