//
//  CameraViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 03/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

import AVFoundation
import CoreLocation

class CameraViewController: ARViewController, ARDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: - Properties
    
    var newButton = UIButton()
    var filterButton = UIButton()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showARViewController()
        setupButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showARViewController()
    {
        
        /**
        // Create random annotations around center point
        // @TODO
        // FIXME: set your initial position here, this is used to generate random POIs
        let lat = 2.9257442
        let lon = 101.63672679999999
        let delta = 0.05
        let count = 50
        //let dummyAnnotations = self.getDummyAnnotations(centerLatitude: lat, centerLongitude: lon, delta: delta, count: count)
        **/
        
        self.uiOptions.debugEnabled = true
        self.uiOptions.closeButtonEnabled = false
        
        self.getAnnotationsFromAPI(completionHandler: { annotations in
            
            // Check if device has hardware needed for augmented reality
            let result = ARViewController.createCaptureSession()
            if result.error != nil
            {
                //let message = result.error?.userInfo["description"] as? String
                //let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Close")
                //alertView.show()
                return
            }

            if annotations.count > 0 {

                // Present ARViewController
                self.dataSource = self
                self.maxVisibleAnnotations = 100
                self.maxVerticalLevel = 5
                self.headingSmoothingFactor = 0.05
                self.trackingManager.userDistanceFilter = 25
                self.trackingManager.reloadDistanceFilter = 75
                //self.setAnnotations(dummyAnnotations)
                self.setAnnotations(annotations)
            }
        })
    }
    
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView
    {
        // Annotation views should be lightweight views, try to avoid xibs and autolayout all together.
        let annotationView = AnnotationView()
        annotationView.frame = CGRect(x: 0,y: 0,width: 150,height: 50)
        return annotationView
    }
    
    fileprivate func getAnnotationsFromAPI(completionHandler: @escaping ([ARAnnotation]) -> Void )  {
        
        var annotations: [ARAnnotation] = []
        
        let screenSize: CGRect = UIScreen.main.bounds
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: screenSize.height)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(indicator)
        indicator.startAnimating()
        
        APIManager.shared.getAdvertisements(completionHandler: { json in
            indicator.stopAnimating()
            
            if json != nil {
                
                for result in json.arrayValue {
                    let annotation = ARAnnotation()
                    annotation.location = CLLocation(latitude: result["lat"].doubleValue, longitude: result["lng"].doubleValue)
                    annotation.title = result["place_name"].stringValue
                    
                    APIManager.shared.getUserProfile(completionHandler: { json in
                        
                        if json != nil {
                            annotation.pictureUrl = json["profile"]["avatar"].stringValue
                        } else {
                            print("Error getting advertisement creator photo")
                        }
                    })
                    
                    annotations.append(annotation)
                    completionHandler(annotations)
                }
                
            } else {
                print("Error getting advertisements")
            }
        })
    }
    
    fileprivate func getDummyAnnotations(centerLatitude: Double, centerLongitude: Double, delta: Double, count: Int) -> Array<ARAnnotation>
    {
        var annotations: [ARAnnotation] = []
        
        srand48(3)
        for _ in stride(from: 0, to: count, by: 1)
        {
            let annotation = ARAnnotation()
            annotation.location = self.getRandomLocation(centerLatitude: centerLatitude, centerLongitude: centerLongitude, delta: delta)
            // annotation.title = "POI \(i)"
            let title = ["Cyberia", "The Arc", "Crescent", "Mutiara"]
            let diceRoll = Int(arc4random_uniform(4))
            annotation.title = title[diceRoll]
            annotations.append(annotation)
        }
        return annotations
    }
    
    fileprivate func getRandomLocation(centerLatitude: Double, centerLongitude: Double, delta: Double) -> CLLocation
    {
        var lat = centerLatitude
        var lon = centerLongitude
        
        let latDelta = -(delta / 2) + drand48() * delta
        let lonDelta = -(delta / 2) + drand48() * delta
        lat = lat + latDelta
        lon = lon + lonDelta
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    // MARK: - Setups
    func setupButtons() {
        
        let screen = UIScreen.main.bounds
        
        newButton.setImage(UIImage(named: "Filter"), for: UIControlState())
        newButton.frame = CGRect(x: screen.width-24, y: 48, width: 21, height: 21)
        newButton.addTarget(self, action: #selector(CameraViewController.newButtonTapped), for: UIControlEvents.touchUpInside)
        
        filterButton.setImage(UIImage(named: "Filter"), for: UIControlState())
        filterButton.frame = CGRect(x: screen.width-24, y: 48, width: 21, height: 21)
        filterButton.addTarget(self, action: #selector(CameraViewController.filterButtonTapped), for: UIControlEvents.touchUpInside)
    }
    
    // MARK : - Actions
    
    func newButtonTapped() {
        let newAds = storyboard!.instantiateViewController(withIdentifier: "NewAdvertisement") as! UINavigationController
        present(newAds, animated: true, completion: nil)
        
    }
    
    func filterButtonTapped() {
        
    }
    
}
