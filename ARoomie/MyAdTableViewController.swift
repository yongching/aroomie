//
//  MyAdTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 23/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import Kingfisher

class MyAdTableViewController: UITableViewController {

    // MARK: - Properties
    
    var advertisementIds: [Int] = []
    var roomUrls: [String] = []
    var placeNames: [String] = []
    var total = 0
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        getAdvertisements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if placeNames.count == total {
            return total
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertisementCell", for: indexPath) as! AdvertisementTableViewCell
        
        if placeNames.count == total {
            let url = URL(string: roomUrls[indexPath.row])
            cell.roomImage.kf.setImage(with: url)
            cell.labelPlace.text = self.placeNames[indexPath.row]
            if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
                tableView.endUpdates()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "NewAdvertisement") as! UINavigationController
        let selectLocationViewController = navigationController.viewControllers[0] as! SelectLocationViewController
        selectLocationViewController.advertisementId = advertisementIds[indexPath.row]
        present(navigationController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
                action in
                
                APIManager.shared.deleteAdvertisement(byId: self.advertisementIds[indexPath.row], completionHandler: { json in
                    
                    if json != nil {
                        self.advertisementIds.remove(at: indexPath.row)
                        self.roomUrls.remove(at: indexPath.row)
                        self.placeNames.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    }
                })
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    func getAdvertisements() {
        
        advertisementIds.removeAll()
        roomUrls.removeAll()
        placeNames.removeAll()
        
        APIManager.shared.getUserAdvertisements(completionHandler: { json in

            if json != nil {
                self.total = json.arrayValue.count
                
                for result in json.arrayValue {
                    self.advertisementIds.append(result["id"].intValue)
                    self.roomUrls.append(result["photo"].stringValue)
                    self.placeNames.append(result["place_name"].stringValue)
                }
                self.tableView.reloadData()
                
            }
        })
    }

}
