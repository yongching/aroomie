//
//  AdDetailsTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 17/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import MapKit

class AdDetailsTableViewController: UITableViewController, MKMapViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var roomPicture: UIImageView!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var labelCreatorName: UILabel!
    @IBOutlet weak var textFieldRental: UILabel!
    @IBOutlet weak var labelMoveInDate: UILabel!
    @IBOutlet weak var labelDeposit: UILabel!
    @IBOutlet weak var textViewRules: UITextView!
    @IBOutlet weak var textViewAmenities: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var creatorId: Int?
    
    // Map View
    let lat: Double? = 0.0
    let lng: Double? = 0.0
    
    // Segue
    var advertisementId: Int?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupMapView()
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
        case 1:
            return 22
        default:
            return 30
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
            return 1
        case 5:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1:
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Setup
    
    func setupImageView() {
        profileAvatar.layer.cornerRadius = 60 / 2
        profileAvatar.layer.borderWidth = 1.0
        profileAvatar.layer.borderColor = UIColor.white.cgColor
        profileAvatar.clipsToBounds = true
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    // MARK: - Actions
    
    func getDetails() {
        
        if let id = advertisementId {
            
            APIManager.shared.getAdvertisement(byId: id, completionHandler: { json in
                if json != nil {
                    
                    self.creatorId = json["created_by"].intValue
                    
                    do {
                        self.roomPicture.image = try UIImage(data: Data(contentsOf: URL(string: json["photo"].stringValue)!))
                    } catch _ {
                        print("Room image not found")
                    }
                    
                    APIManager.shared.getUserProfile(false, byId: json["created_by"].intValue, completionHandler: { json in
                        if json != nil {
                            do {
                                self.profileAvatar.image = try UIImage(data: Data(contentsOf: URL(string: json["profile"]["avatar"].stringValue)!))
                            } catch _ {
                                print("Creator image not found")
                            }
                            self.labelCreatorName.text = json["basic"]["first_name"].stringValue + " " + json["basic"]["last_name"].stringValue
                        }
                    })
                    
                    self.textFieldRental.text = json["rental"].stringValue
                    self.labelMoveInDate.text = json["move_in"].stringValue
                    self.labelDeposit.text = json["deposit"].stringValue
                    self.textViewRules.text = json["rule"].stringValue
                    self.textViewAmenities.text = json["amenity"].stringValue
                    
                    let coordinate = CLLocationCoordinate2D(latitude: json["lat"].doubleValue, longitude: json["lng"].doubleValue)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = json["place_name"].stringValue
                    self.mapView.addAnnotation(annotation)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(coordinate, span)
                    self.mapView.setRegion(region, animated: true)
                }
            })
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueProfileDetails" {
            let controller = segue.destination as! UserProfileTableViewController
            if let id = creatorId {
                controller.userId = id
            }
        }
    }

}
