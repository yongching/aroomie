//
//  ViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 14/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor.black
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor.white
        
        self.selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.catchNotification), name: NSNotification.Name(rawValue: "notification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : - Actions
    
    func catchNotification(_ notification: Notification){
        
        let advertisementId: Int = notification.object as! Int
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "ViewAdvertisement") as! UINavigationController
        let adDetailsTableViewController = navigationController.viewControllers[0] as! AdDetailsTableViewController
        adDetailsTableViewController.advertisementId = advertisementId
        present(navigationController, animated: true, completion: nil)
    }

}
