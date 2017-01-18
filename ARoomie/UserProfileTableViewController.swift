//
//  UserProfileTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 18/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewScore: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAgeRange: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelRace: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    let raceOptions: [String] = [
        "malay",
        "chinese",
        "indian",
        "others"
    ]
    
    // Segue
    var userId: Int?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        setupImageView()
        getDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        default:
            return 25
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 3
        case 3:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 3:
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    func setupImageView() {
        imageView.layer.cornerRadius = 60 / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
    }
    
    func getDetails() {
        if let id = userId {
            
            APIManager.shared.getUserProfile(byId: id, completionHandler: { json in
                if json != nil {
                    do {
                        self.imageView.image = try UIImage(data: Data(contentsOf: URL(string: json["profile"]["avatar"].stringValue)!))
                    } catch _ {
                        print("Creator image not found")
                    }
                    self.labelName.text = json["basic"]["first_name"].stringValue + " " + json["basic"]["last_name"].stringValue
                    self.labelAgeRange.text = json["age_range"].stringValue
                    self.labelGender.text = json["profile"]["gender"].stringValue
                    self.labelRace.text = self.raceOptions[json["profile"]["race"].intValue]
                    self.labelPhone.text = json["profile"]["phone"].stringValue
                    self.labelEmail.text = json["basic"]["email"].stringValue
                }
            })
        }
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
    
    @IBAction func NewMessage(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NewMessage") as! UINavigationController
        let viewMessageView = navigationController.viewControllers[0] as! NewMessageViewController
        viewMessageView.receiverId = userId
        let currentViewController = self.getCurrentViewController()
        currentViewController?.present(navigationController, animated: true, completion: nil)
    }
    
}
