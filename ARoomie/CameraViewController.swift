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
    
    var newAnnotations: [ARAnnotation] = []
    
    var newButton = UIButton()
    var filterButton = UIButton()
    var refreshButton = UIButton()
    
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
        
        self.getAnnotationsFromAPI(completionHandler: { newAnnotations in
            
            // Check if device has hardware needed for augmented reality
            let result = ARViewController.createCaptureSession()
            if result.error != nil
            {
                //let message = result.error?.userInfo["description"] as? String
                //let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Close")
                //alertView.show()
                return
            }

            if newAnnotations.count > 0 {

                // Present ARViewController
                self.dataSource = self
                self.maxVisibleAnnotations = 100
                self.maxVerticalLevel = 5
                self.headingSmoothingFactor = 0.05
                self.trackingManager.userDistanceFilter = 25
                self.trackingManager.reloadDistanceFilter = 75
                //self.setAnnotations(dummyAnnotations)
                self.setAnnotations(newAnnotations)
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
        
        self.newAnnotations.removeAll()
        
        APIManager.shared.getAdvertisements(completionHandler: { json in
            
            if json != nil {
                for result in json.arrayValue {
                    let annotation = ARAnnotation()
                    annotation.advertisementId = result["id"].intValue
                    annotation.location = CLLocation(latitude: result["lat"].doubleValue, longitude: result["lng"].doubleValue)
                    annotation.title = result["place_name"].stringValue
                    annotation.createdBy = result["created_by"].intValue
                    
                    if let id = annotation.createdBy {
                        
                        APIManager.shared.getUserProfile(byId: id, completionHandler: { json in
                            if json != nil {
                                annotation.pictureUrl = json["profile"]["avatar"].stringValue
                                
                            } else {
                                print("Error getting advertisement creator photo")
                            }
                            self.newAnnotations.append(annotation)
                            completionHandler(self.newAnnotations)
                        })
                    }
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
        let rightMargin: CGFloat = 16.0
        let bottomMargin: CGFloat = 49.0
        let width: CGFloat = 50.0
        let height: CGFloat = 50.0
        let x = screen.width - rightMargin - width
        
        let customButtonView1 = UIView(frame: CGRect(x: x, y: screen.height - bottomMargin - (height * 1 + 40), width: width, height: height))
        let customButtonView2 = UIView(frame: CGRect(x: x, y: screen.height - bottomMargin - (height * 2 + 50), width: width, height: height))
        let customButtonView3 = UIView(frame: CGRect(x: x, y: screen.height - bottomMargin - (height * 3 + 60), width: width, height: height))
        
        customButtonView1.layer.cornerRadius = customButtonView1.bounds.size.width / 2
        customButtonView2.layer.cornerRadius = customButtonView1.bounds.size.width / 2
        customButtonView3.layer.cornerRadius = customButtonView1.bounds.size.width / 2
        
        customButtonView1.backgroundColor = UIColor.white
        customButtonView2.backgroundColor = UIColor.white
        customButtonView3.backgroundColor = UIColor.white

        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.refresh))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.filter))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(CameraViewController.new(_:)))
        
        customButtonView1.addGestureRecognizer(tapGesture1)
        customButtonView2.addGestureRecognizer(tapGesture2)
        customButtonView3.addGestureRecognizer(tapGesture3)
        
        let iconWidth = width / 2
        let iconHeight = height / 2
        let iconX = width / 2 - (iconWidth / 2)
        let iconY = height / 2 - (iconHeight / 2)
        
        refreshButton.setImage(UIImage(named: "ic_refresh_48pt"), for: UIControlState())
        refreshButton.frame = CGRect(x: iconX, y: iconY, width: iconWidth, height: iconHeight)
        refreshButton.addTarget(self, action: #selector(CameraViewController.refresh), for: UIControlEvents.touchUpInside)
        
        filterButton.setImage(UIImage(named: "ic_filter_48pt"), for: UIControlState())
        filterButton.frame = CGRect(x: iconX, y: iconY, width: iconWidth, height: iconHeight)
        filterButton.addTarget(self, action: #selector(CameraViewController.filter), for: UIControlEvents.touchUpInside)
        
        newButton.setImage(UIImage(named: "ic_add_48pt"), for: UIControlState())
        newButton.frame = CGRect(x: iconX, y: iconY, width: iconWidth, height: iconHeight)
        newButton.addTarget(self, action: #selector(CameraViewController.new), for: UIControlEvents.touchUpInside)

        customButtonView1.addSubview(refreshButton)
        customButtonView2.addSubview(filterButton)
        customButtonView3.addSubview(newButton)
        
        self.view.addSubview(customButtonView1)
        self.view.addSubview(customButtonView2)
        self.view.addSubview(customButtonView3)
    }
    
    // MARK : - Actions
    
    func refresh() {
        self.getAnnotationsFromAPI(completionHandler: { newAnnotations in
            
            // Check if device has hardware needed for augmented reality
            let result = ARViewController.createCaptureSession()
            if result.error != nil
            {
                //let message = result.error?.userInfo["description"] as? String
                //let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Close")
                //alertView.show()
                return
            }
            
            if newAnnotations.count > 0 {
                
                // Present ARViewController
                self.dataSource = self
                self.maxVisibleAnnotations = 100
                self.maxVerticalLevel = 5
                self.headingSmoothingFactor = 0.05
                self.trackingManager.userDistanceFilter = 25
                self.trackingManager.reloadDistanceFilter = 75
                //self.setAnnotations(dummyAnnotations)
                self.setAnnotations(newAnnotations)
            }
        })
    }
    
    func filter() {
        print("filter")
    }
    
    func new(_ sender: UITapGestureRecognizer) {
        let newAds = storyboard!.instantiateViewController(withIdentifier: "NewAdvertisement") as! UINavigationController
        present(newAds, animated: true, completion: nil)
    }
    
}
