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
        getDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 30
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
            return 4
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
    
    func getDetails() {
        if let id = userId {
            
            APIManager.shared.getUserProfile(byId: id, completionHandler: { json in
                if json != nil {
                    do {
                        self.imageView.image = try UIImage(data: Data(contentsOf: URL(string: json["profile"]["avatar"].stringValue)!))
                    } catch _ {
                        print("Creator image not found")
                    }
                    self.labelName.text = json["basic"]["first_name"].stringValue + json["basic"]["last_name"].stringValue
                    self.labelAgeRange.text = json["age_range"].stringValue
                    self.labelGender.text = json["profile"]["gender"].stringValue
                    self.labelRace.text = self.raceOptions[json["profile"]["race"].intValue]
                    self.labelPhone.text = json["profile"]["phone"].stringValue
                    self.labelEmail.text = json["basic"]["email"].stringValue
                }
            })
        }
    }

    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueNewMessage" {
            let controller = segue.destination as! NewMessageViewController
            if let id = userId {
                controller.receiverId = id
            }
        }
    }
    
}
