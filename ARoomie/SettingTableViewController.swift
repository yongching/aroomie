//
//  SettingTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 28/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit
import DropDown

class SettingTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAgeGroup: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var buttonRace: DropDownButton!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var textFieldPhone: UITextField!
    let raceOptions: [String] = [
        "malay",
        "chinese",
        "indian",
        "others"
    ]
    
    // MARK: - DropDown
    
    let raceDropDown = DropDown()
    lazy var dropDown: DropDown = {
        return self.raceDropDown
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        setupAvatar()
        setupDropDown()
        setupTextField()
        hideKeyboardWhenTappedAround()
        getUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 3
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func setupTextField() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UIViewController.dismissKeyboard)
            )], animated: true)
        
        keyboardToolbar.sizeToFit()
        textFieldPhone.delegate = self
        textFieldPhone.inputAccessoryView = keyboardToolbar
    }

    func getUserData() {
        
        APIManager.shared.getUserProfile(completionHandler: { json in
            
            if json != nil {
                User.currentUser.setInfo(json: json)
                self.imageAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
                self.labelName.text = User.currentUser.name
                self.labelAgeGroup.text = User.currentUser.age_range
                self.labelGender.text = User.currentUser.gender
                if User.currentUser.race != nil {
                    self.dropDown.selectRow(at: User.currentUser.race)
                    self.buttonRace.setTitle(self.raceOptions[User.currentUser.race!], for: .normal)
                }
                self.labelEmail.text = User.currentUser.email
                self.textFieldPhone.text = User.currentUser.phone

            } else {
                let message = "There is some problem getting user profile!"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func buttonSave(_ sender: Any) {
        
        let params: [String: Any] = [
            "race": raceDropDown.indexForSelectedRow!,
            "phone": textFieldPhone.text!,
            "lifestyle_info": "",
            "gender_pref": "",
            "race_pref": "",
            "budget_pref": "",
            "move_in_pref": ""
        ]
        
        let screenSize: CGRect = UIScreen.main.bounds
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: screenSize.height)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(indicator)
        indicator.startAnimating()
        
        APIManager.shared.updateUserProfile(params: params, completionHandler: { json in
            
            indicator.stopAnimating()
            
            if json != nil {
                let alert = UIAlertController(title: "Successfully Saved!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let message = "There is some problem saving profile!"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func chooseRace(_ sender: Any) {
        raceDropDown.show()
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: {
            action in
            
            APIManager.shared.logout(completionHandler: { error in
                
                if error == nil {
                    FBManager.shared.logOut()
                    User.currentUser.resetInfo()
                    Default.shared.resetUserDefault()
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.present(loginViewController, animated: true, completion: nil)
                    
                } else {
                    let message = "There is some problem logging out!"
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
