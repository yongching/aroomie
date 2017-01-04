//
//  PreferenceTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 29/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit
import DropDown

class PreferenceTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var buttonGender: DropDownButton!
    @IBOutlet weak var buttonRace: DropDownButton!
    @IBOutlet weak var textFieldBudget: UITextField!
    @IBOutlet weak var textFieldMoveIn: UITextField!
    let genderOptions: [String] = [
        "male",
        "female"
    ]
    let raceOptions: [String] = [
        "malay",
        "chinese",
        "indian",
        "others"
    ]
    let dateFormatter = DateFormatter()
    
    // MARK: - DropDown
    
    let genderDropDown = DropDown()
    let raceDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.genderDropDown,
            self.raceDropDown
        ]
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
        setupTextField()
        setupDatePicker()
        getUserData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // MARK: - Setup
    
    func setupDropDowns() {
        setupGenderDropDown()
        setupRaceDropDown()
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
    }
    
    func setupGenderDropDown() {
        genderDropDown.anchorView = buttonGender
        
        genderDropDown.bottomOffset = CGPoint(x: 0, y: genderDropDown.bounds.height)
        
        genderDropDown.dataSource = genderOptions
        
        // Action triggered on selection
        genderDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonGender.setTitle(item, for: .normal)
        }
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
        
        // Keyboard toolbar
        let keyboardToolbar = UIToolbar()
        
        keyboardToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PreferenceTableViewController.dismissKeyboard)
            )], animated: true)
        
        keyboardToolbar.sizeToFit()
        
        textFieldBudget.delegate = self
        textFieldBudget.keyboardType = UIKeyboardType.decimalPad
        textFieldBudget.inputAccessoryView = keyboardToolbar
    }
    
    func setupDatePicker() {
        
        // Keyboard toolbar
        let keyboardToolbar = UIToolbar()
        
        keyboardToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PreferenceTableViewController.dismissKeyboard)
            )], animated: true)
        
        keyboardToolbar.sizeToFit()
        
        
        // Date picker
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        
        textFieldMoveIn.delegate = self
        textFieldMoveIn.inputView = datePicker
        textFieldMoveIn.inputAccessoryView = keyboardToolbar
        datePicker.addTarget(self, action: #selector(PreferenceTableViewController.datePickerChanged), for: UIControlEvents.valueChanged)
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getUserData() {

        if User.currentUser.gender_pref != nil {
            genderDropDown.selectRow(at: User.currentUser.gender_pref!)
            buttonGender.setTitle(self.genderOptions[User.currentUser.gender_pref!], for: .normal)
        }
        
        if User.currentUser.race_pref != nil {
            raceDropDown.selectRow(at: User.currentUser.race_pref!)
            buttonRace.setTitle(self.raceOptions[User.currentUser.race_pref!], for: .normal)
        }
        
        textFieldBudget.text = User.currentUser.budget_pref
        textFieldMoveIn.text = User.currentUser.move_in_pref
    }

    // MARK: - Actions
    
    @IBAction func buttonSave(_ sender: Any) {
        let params: [String: Any] = [
            "race": "",
            "phone": "",
            "lifestyle_info": "",
            "gender_pref": genderDropDown.indexForSelectedRow!,
            "race_pref": raceDropDown.indexForSelectedRow!,
            "budget_pref": textFieldBudget.text!,
            "move_in_pref": textFieldMoveIn.text!
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
                
                User.currentUser.setPreferences(gender: self.genderDropDown.indexForSelectedRow!, race: self.raceDropDown.indexForSelectedRow!, budget: self.textFieldBudget.text!, moveIn: self.textFieldMoveIn.text!)
                
                let alert = UIAlertController(title: "Successfully save", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let message = "There is some problem saving preferences"
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func chooseGender(_ sender: Any) {
        genderDropDown.show()
    }
    
    @IBAction func chooseRace(_ sender: Any) {
        raceDropDown.show()
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        self.textFieldMoveIn.text = dateFormatter.string(from: datePicker.date)
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
