//
//  UserProfileTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 18/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import HCSStarRatingView

class UserProfileTableViewController: UITableViewController {

    // MARK: - Properties
    
    // Segue
    var userId: Int?
    var lifestyle: String?
    var isOns: [Int] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAgeRange: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelRace: UILabel!
    @IBOutlet weak var labelLifestyleInfo: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    let emojiUnicodes: Array<String> = ["\u{1F3CA}", "\u{1F3C4}", "\u{1F485}", "\u{1F6B4}", "\u{1F4DA}", "\u{1F483}", "\u{1F3AE}", "\u{1F4AA}", "\u{1F3C0}", "\u{1F3BE}", "\u{26BD}", "\u{26BE}", "\u{1F3B5}", "\u{1F3B1}", "\u{1F3A8}", "\u{1F3A4}", "\u{1F3A6}", "\u{1F3A3}", "\u{1F37B}", "\u{1F355}", "\u{1F3B3}"]
    
    // Star rating
    let starRatingView = HCSStarRatingView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
    
    // Drop down options
    let raceOptions: [String] = [
        "malay",
        "chinese",
        "indian",
        "others"
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        setupImageView()
        getDetails()
        getRating()
        getLifestyleInfo()
        checkRating()
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
       
        return 5
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
            return 1
        case 4:
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
    
    func checkRating() {
        
        if let id = userId {
            if id != User.currentUser.id {
                APIManager.shared.ratingCheck(userId: id, completionHandler: { json in
                    if json != nil {
                        if json["rated"].boolValue == false {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Give Rating", style: .plain, target: self, action: #selector(UserProfileTableViewController.rateUser))
                        }
                    }
                })
            }
        }
    }
    
    func setupImageView() {
        imageView.layer.cornerRadius = 60 / 2
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
    }
    
    func getRating() {
        
        if let id = userId {
            
            APIManager.shared.getRating(byId: id, completionHandler: { json in
                if json != nil {
                    // Star rating View
                    self.starRatingView.removeFromSuperview()
                    self.starRatingView.value = CGFloat(json["score"].intValue)
                    self.starRatingView.minimumValue = 0
                    self.starRatingView.maximumValue = 5
                    self.starRatingView.tintColor = UIColor.gray
                    self.starRatingView.backgroundColor = UIColor.clear
                    self.starRatingView.isUserInteractionEnabled = false
                    self.starView.addSubview(self.starRatingView)
                }
            })
        }
    }
    
    func getLifestyleInfo() {
        
        if let ls = lifestyle {
            let array = ls.components(separatedBy: ",")
            
            var selected = ""
            
            for item in array {
                isOns.append(Int(item)!)
            }
            
            for (index, choice) in (isOns.enumerated()) {
                if choice == 1 {
                    selected += emojiUnicodes[index]
                }
            }
            self.labelLifestyleInfo.text = selected
            self.tableView.reloadData()
        }
    }
    
    func getDetails() {
        
        if let id = userId {
            
            APIManager.shared.getUserProfile(true, byId: id, completionHandler: { json in
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
    
    func rateUser() {
        
        let margin:CGFloat = 10.0
        let alertController = UIAlertController(title: "\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Custom view
        let customViewWidth = alertController.view.bounds.size.width - margin * 4.0
        let rect = CGRect(x: margin, y: margin, width: customViewWidth, height: 65)
        let customView = UIView(frame: rect)
        
        // Star rating View
        let width = alertController.view.bounds.size.width - margin * 6.0
        let y = (customView.bounds.height - 30) / 2
        let starRatingView = HCSStarRatingView(frame: CGRect(x: margin, y: y, width: width, height: 30))
        starRatingView.value = 0
        starRatingView.minimumValue = 0
        starRatingView.maximumValue = 5
        starRatingView.tintColor = UIColor.gray
        starRatingView.backgroundColor = UIColor.clear
        customView.addSubview(starRatingView)
        
        // Alert controller
        alertController.view.addSubview(customView)
        let submitAction = UIAlertAction(title: "Confirm", style: .default, handler: { (alert: UIAlertAction!) in
            if starRatingView.value != 0 {
                if let id = self.userId {
                    APIManager.shared.addRating(toUserId: id, score: Int(starRatingView.value), completionHandler: { json in
                        if json != nil {
                            let alert = UIAlertController(title: "Successfully Rated!", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { completionHandler in
                                self.getRating()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            let message = "There is some problem sending your rating score!"
                            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
