//
//  NewAdDetailsTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 12/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class NewAdDetailsTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    // Segue
    var advertisementId: Int?
    var lat: String = "0"
    var lng: String = "0"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewCameraIcon: UIImageView!
    @IBOutlet weak var labelAddPhoto: UILabel!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var buttonGenderPref: DropDownButton!
    @IBOutlet weak var buttonRacePref: DropDownButton!
    @IBOutlet weak var textViewRules: UITextView!
    @IBOutlet weak var textViewAmenities: UITextView!
    
    // UIImagePickerController
    let imagePicker = UIImagePickerController()
    
    // DateFormatter
    let dateFormatter = DateFormatter()

    // DropDown
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
        initializeAdvertisement()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 6
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
        self.labelAddPhoto.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setup
    
    func setupImagePicker() {
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
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
        
        textFields[2].inputView = datePicker
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
    
    // For advertisement update
    func initializeAdvertisement() {
        
        if let id = self.advertisementId {
            
            self.imageViewCameraIcon.isHidden = true
            self.labelAddPhoto.isHidden = true
            self.navigationItem.title = "Edit Details"
            self.rightBarButton.title = "Update"
            APIManager.shared.getAdvertisement(byId: id, completionHandler: { json in
                
                if json != nil {
                    do {
                        self.imageView.image = try UIImage(data: Data(contentsOf: URL(string: json["photo"].stringValue)!))
                    } catch _ {}
                    self.textFields[0].text = json["place_name"].stringValue
                    self.textFields[1].text = json["rental"].stringValue
                    self.textFields[2].text = json["move_in"].stringValue
                    self.textFields[3].text = json["deposit"].stringValue
                    self.genderPrefDropDown.selectRow(at: json["gender_pref"].intValue)
                    self.buttonGenderPref.setTitle(self.genderOptions[json["gender_pref"].intValue], for: .normal)
                    self.racePrefDropDown.selectRow(at: json["race_pref"].intValue)
                    self.buttonRacePref.setTitle(self.raceOptions[json["race_pref"].intValue], for: .normal)
                    self.textViewRules.text = json["rule"].stringValue
                    self.textViewAmenities.text = json["amenity"].stringValue
                }
            })
        }
    }
    
    @IBAction func postButton(_ sender: Any) {
        
        var path = ""
        var method: HTTPMethod?
        
        if let id = self.advertisementId {
            path = "api/advertisement/edit/\(id)/"
            method = HTTPMethod.put
            
        } else {
            path = "api/advertisement/add/"
            method = HTTPMethod.post
        }
        
        let baseURL = NSURL(string: BASE_URL)
        let url = baseURL!.appendingPathComponent(path)
        let parameters: [String: Any] = [
            "access_token": Default.shared.getAccessToken(),
            "place_name": textFields[0].text!,
            "rental": textFields[1].text!,
            "move_in": textFields[2].text!,
            "deposit": textFields[3].text!,
            "amenity": textViewAmenities.text!,
            "rule": textViewRules.text!,
            "lat": lat,
            "lng": lng,
            "gender_pref": genderPrefDropDown.indexForSelectedRow ?? -1,
            "race_pref": racePrefDropDown.indexForSelectedRow ?? -1
        ]
        
        SVProgressHUD.show()
        
        Alamofire.upload(multipartFormData: { MultipartFormData in
            
            if let image = self.imageView.image {
                MultipartFormData.append(UIImageJPEGRepresentation(image, 0.8)!, withName: "photo", fileName: "picture", mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: true)!, withName:key)
            }
        
        }, to: url!, method: method!, encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    SVProgressHUD.dismiss()
                    
                    debugPrint(response)
                    //print(JSON(response.result.value!))
                    
                    if response.response?.statusCode == 200 {
                        
                        var title = ""
                        
                        if let _ = self.advertisementId {
                            title = "Successfully Updated!"
                            
                        } else {
                            title = "Successfully Posted!"
                        }
                        
                        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
                            completionHandler in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        var title = ""
                        
                        if let _ = self.advertisementId {
                            title = "Error Updating!"
                            
                        } else {
                            title = "Error Posting!"
                        }
                        
                        let alert = UIAlertController(title: title, message: "This may be due to slow internet connection", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                break
                
            case .failure( _):
                SVProgressHUD.dismiss()
                break
            }
        })
    }
    
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
        self.textFields[2].text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func changeGenderPref(_ sender: Any) {
        genderPrefDropDown.show()
    }
    
    @IBAction func changeRacePref(_ sender: Any) {
        racePrefDropDown.show()
    }
    
}
