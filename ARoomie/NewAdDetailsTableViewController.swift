//
//  NewAdDetailsTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 12/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import DropDown

class NewAdDetailsTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet var textFields: [UITextField]!
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var buttonGenderPref: DropDownButton!
    @IBOutlet weak var buttonRacePref: DropDownButton!
    
    @IBOutlet weak var textViewRules: UITextView!
    @IBOutlet weak var textViewAmenities: UITextView!
    
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
    
    // MARK: - UIImagePickerController
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - DropDown
    
    let genderPrefDropDown = DropDown()
    let racePrefDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.genderPrefDropDown,
            self.racePrefDropDown
        ]
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.black

        setupImagePicker()
        setupTextFieldsAndTextViews()
        setupDatePicker()
        setupDropDowns()
        hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup
    
    func setupImagePicker() {
        self.imagePicker.delegate = self
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewAdDetailsTableViewController.imageViewTapped)))
        self.imageView.isUserInteractionEnabled = true
    }
    
    func setupTextFieldsAndTextViews() {
        
        let keyboardToolbar = UIToolbar()
        
        keyboardToolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(UIViewController.dismissKeyboard)
            )], animated: true)
        
        keyboardToolbar.sizeToFit()
        
        textFields.forEach {
            $0.delegate = self
            $0.inputAccessoryView = keyboardToolbar
        }
        
        textViewRules.delegate = self
        textViewAmenities.delegate = self
        
        textViewRules.inputAccessoryView = keyboardToolbar
        textViewAmenities.inputAccessoryView = keyboardToolbar
    }
    
    func setupDatePicker() {
        
        // Date picker
        let datePicker:UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        
        textFields[1].inputView = datePicker
        datePicker.addTarget(self, action: #selector(NewAdDetailsTableViewController.datePickerChanged), for: UIControlEvents.valueChanged)
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"

    }
    
    func setupDropDowns() {
        setupGenderPrefDropDown()
        setupRacePrefDropDown()
        
        dropDowns.forEach {
            $0.dismissMode = .onTap
            $0.direction = .bottom
        }
    }
    
    func setupGenderPrefDropDown() {
        genderPrefDropDown.anchorView = buttonGenderPref
        
        genderPrefDropDown.bottomOffset = CGPoint(x: 0, y: genderPrefDropDown.bounds.height)
        
        genderPrefDropDown.dataSource = genderOptions
        
        // Action triggered on selection
        genderPrefDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonGenderPref.setTitle(item, for: .normal)
        }
    }
    
    func setupRacePrefDropDown() {
        racePrefDropDown.anchorView = buttonRacePref
        
        racePrefDropDown.bottomOffset = CGPoint(x: 0, y: racePrefDropDown.bounds.height)
        
        racePrefDropDown.dataSource = raceOptions
        
        // Action triggered on selection
        racePrefDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonRacePref.setTitle(item, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    func imageViewTapped() {
        let alert = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: {
            action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            action in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        self.textFields[1].text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func changeGenderPref(_ sender: Any) {
        genderPrefDropDown.show()
    }
    
    @IBAction func changeRacePref(_ sender: Any) {
        racePrefDropDown.show()
    }
    
}
