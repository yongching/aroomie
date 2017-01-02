//
//  SettingTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 28/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit
import DropDown

class SettingTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAgeGroup: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var buttonRace: DropDownButton!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var textFieldPhone: UITextField!
    
    let raceOptions: [String] = [
        "chinese",
        "malay",
        "indian",
        "other"
    ]
    
    // MARK: - DropDown
    
    let raceDropDown = DropDown()
    
    lazy var dropDown: DropDown = {
        return self.raceDropDown
    }()
    
    // MARK: - Actions
    @IBAction func chooseRace(_ sender: Any) {
        raceDropDown.show()
    }

    @IBAction func buttonLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: {
            action in
            
            APIManager.shared.logout(completionHandler: { (error) in
                if error == nil {
                    
                    FBManager.shared.logOut()
                    User.currentUser.resetInfo()
                    Default.shared.resetUserDefault()
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(loginViewController, animated: true, completion: nil)
                    
                } else {
                    
                    let message = "There is some problem logging out"
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatar()
        setupDropDown()
        
        /**
        APIManager.shared.getUserInfo(completionHandler: { json in
            
            if json != nil {
                self.imageAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: json["profile"]["avatar"].string!)!))
                self.labelName.text = json["basic"]["first_name"].stringValue + " " + json["basic"]["last_name"].stringValue
                self.labelGender.text = json["profile"]["gender"].stringValue
                self.labelAgeGroup.text = json["age_range"].stringValue
                let index = json["profile"]["race"].stringValue
                if !(index == "") {
                    self.dropDown.selectRow(at: Int(index))
                    self.buttonRace.setTitle(self.raceOptions[Int(index)!], for: .normal)
                }
                self.labelEmail.text = json["basic"]["email"].stringValue
                self.textFieldPhone.text = json["profile"]["phone"].stringValue
                self.tableView.reloadData()
            }
        })
        **/
        
        imageAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        labelName.text = User.currentUser.name
        labelAgeGroup.text = User.currentUser.age_range
        labelGender.text = User.currentUser.gender
        if User.currentUser.race != nil {
            dropDown.selectRow(at: User.currentUser.race)
            buttonRace.setTitle(self.raceOptions[User.currentUser.race!], for: .normal)
        }
        labelEmail.text = User.currentUser.email
        textFieldPhone.text = User.currentUser.phone
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    
    func setupAvatar() {
        imageAvatar.layer.cornerRadius = 60 / 2
        imageAvatar.layer.borderWidth = 1.0
        imageAvatar.layer.borderColor = UIColor.white.cgColor
        imageAvatar.clipsToBounds = true
    }
    
    func setupDropDown() {
        setupRaceDropDown()
        dropDown.dismissMode = .onTap
        dropDown.direction = .bottom
    }
    
    func setupRaceDropDown() {
        raceDropDown.anchorView = buttonRace
        
        raceDropDown.bottomOffset = CGPoint(x: 0, y: raceDropDown.bounds.height)
        
        raceDropDown.dataSource = raceOptions
        
        // Action triggered on selection
        raceDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonRace.setTitle(item, for: .normal)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 2
        case 4:
            return 1
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
    
}
