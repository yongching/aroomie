////
////  SettingViewController.swift
////  ARoomie
////
////  Created by Yong Ching on 24/12/2016.
////  Copyright © 2016 Yong Ching. All rights reserved.
////
//
//import UIKit
//
//enum contentTypes {
//    case profile, matching
//}
//
//class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
//    
//    // MARK: Outlet properties
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var headerView: UIView!
//    @IBOutlet weak var profileView: UIView!
//    @IBOutlet weak var segmentedView: UIView!
//    @IBOutlet weak var avatarImage: UIImageView!
//    @IBOutlet weak var handleLabel: UILabel!
//    @IBOutlet weak var headerLabel: UILabel!
//    
//    // MARK: Class properties
//    
//    var offset_HeaderStop = CGFloat() // At this offset the Header stops its transformations
//    let distance_W_LabelHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label
//    
//    let profileCellTitle = ["Gender", "Age Range", "Race", "Phone"]
//    let matchingCellTitle = ["Gender", "Race", "Bugdet", "Move-in"]
//    
//    var headerBlurImageView: UIImageView!
//    var headerImageView: UIImageView!
//    var contentToDisplay : contentTypes = .profile
//
//    
//    // MARK: Views
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        offset_HeaderStop = self.headerView.frame.height - 64.0
//        
//        // add extra scrollable space at top n bottom
//        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0.0, (44.0 * 4.0), 0.0)
//        tableView.tableHeaderView = profileView
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        // Header - Image
//        headerImageView = UIImageView(frame: headerView.bounds)
//        headerImageView?.image = UIImage(named: "header")
//        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
//        headerView.insertSubview(headerImageView, belowSubview: headerLabel)
//        
//        // Header - Blurred Image
//        headerBlurImageView = UIImageView(frame: headerView.bounds)
//        headerBlurImageView?.image = UIImage(named: "header")?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
//        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
//        headerBlurImageView?.alpha = 0.0
//        headerView.insertSubview(headerBlurImageView, belowSubview: headerLabel)
//        
//        headerView.clipsToBounds = true
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: Table view processing
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        switch contentToDisplay {
//        case .profile:
//            return 4
//            
//        case .matching:
//            return 4
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        var cell: CustomCell
//        var cellDetail = [String]()
//        
//        switch contentToDisplay {
//        case .profile:
//            cellDetail = ["Male", "Above 21", "Chinese", "+60 0169927979"]
//            
//            // todo: try to get cell height programatically
//            cell = CustomCell(frame: CGRect(x: 0.0, y:0.0, width: self.view.frame.width, height: 44.0),
//                                  title: profileCellTitle[indexPath.row], detail: cellDetail[indexPath.row])
//        case .matching:
//            cellDetail = ["Male", "Chinese", "MYR 500", "01-01-2017"]
//            
//            cell = CustomCell(frame: CGRect(x: 0.0, y:0.0, width: self.view.frame.width, height: 44.0),
//                                  title: matchingCellTitle[indexPath.row], detail: cellDetail[indexPath.row])
//        }
//       
//        return cell
//    }
//    
//    // MARK: Scroll view delegate
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let offset = scrollView.contentOffset.y + headerView.bounds.height
//        print(offset)
//        
//        var avatarTransform = CATransform3DIdentity
//        var headerTransform = CATransform3DIdentity
//        
//        // Pull down
//        if offset < 0 {
//            
//            // Header
//            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
//            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2
//            headerTransform = CATransform3DTranslate(headerTransform, 0.0, headerSizevariation, 0.0)
//            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0.0)
//            
//            // Hide views if scrolled super fast
//            headerView.layer.zPosition = 0
//            headerLabel.isHidden = true
//        }
//            
//        // Scroll up or down
//        else {
//            
//            // Header will stop it's transformation to smaller until a point, negative because moving up.
//            headerTransform = CATransform3DTranslate(headerTransform, 0.0, max(-offset_HeaderStop, -offset), 0.0)
//            
//            // Label
//            headerLabel.isHidden = false
//            let alignToNameLabel = -offset + handleLabel.frame.origin.y + headerView.frame.height + offset_HeaderStop
//            
//            headerLabel.frame.origin = CGPoint(x: headerLabel.frame.origin.x, y: max(alignToNameLabel, distance_W_LabelHeader + offset_HeaderStop))
//            
//            // Blur
//            headerBlurImageView?.alpha = min (1.0, (offset - alignToNameLabel)/distance_W_LabelHeader)
//            
//            // Avatar
//            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 2.3 // Slow down the animation
//            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
//            avatarTransform = CATransform3DTranslate(avatarTransform, 0.0, avatarSizeVariation, 0.0)
//            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0.0)
//            
//            // Set frontmost layer to avatar if offset <= offset_HeaderStop
//            if offset <= offset_HeaderStop {
//                if avatarImage.layer.zPosition < headerView.layer.zPosition {
//                    headerView.layer.zPosition = 0
//                }
//            } else {
//                // set frontmost layer to header
//                if avatarImage.layer.zPosition >= headerView.layer.zPosition {
//                    headerView.layer.zPosition = 2
//                }
//            }
//        }
//        
//        // Apply Transformations
//        headerView.layer.transform = headerTransform
//        avatarImage.layer.transform = avatarTransform
//        
//        // Segment control
//        let segmentViewOffset = profileView.frame.height - segmentedView.frame.height - offset
//
//        var segmentTransform = CATransform3DIdentity
//        // Scroll the segment view until its offset reaches the same offset at which the header stopped shrinking
//        segmentTransform = CATransform3DTranslate(segmentTransform, 0.0, max(segmentViewOffset, -offset_HeaderStop)+32, 0.0)
//        segmentedView.layer.transform = segmentTransform
//        
//        // Set scroll view insets just underneath the segment control
//        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(segmentedView.frame.maxY, 0.0, 0.0, 0.0)
//    }
//    
//    // MARK: Interface buttons
//
//    @IBAction func selectContent(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0 {
//            contentToDisplay = .profile
//        }
//        else {
//            contentToDisplay = .matching
//        }
//        
//        tableView.reloadData()
//    }
//}
