//
//  MyAdTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 23/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class MyAdTableViewController: UITableViewController {

    // MARK : - Properties
    var advertisementIds: [Int] = []
    var roomUrls: [String] = []
    var placeNames: [String] = []
    
    // MARK : - View lifecycle
    
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
        
        return placeNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvertisementCell", for: indexPath) as! AdvertisementTableViewCell
        
        do {
            cell.roomImage.image = try UIImage(data: Data(contentsOf: URL(string: roomUrls[indexPath.row])!))
            
        } catch _ {
            
        }
        cell.labelPlace.text = self.placeNames[indexPath.row]
        
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
            
            APIManager.shared.deleteAdvertisement(byId: advertisementIds[indexPath.row], completionHandler: { json in
                
                if json != nil {
                    self.advertisementIds.remove(at: indexPath.row)
                    self.roomUrls.remove(at: indexPath.row)
                    self.placeNames.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            })
        }
    }
    
    // MARK : - Actions
    
    func getAdvertisements() {
        
        advertisementIds.removeAll()
        roomUrls.removeAll()
        placeNames.removeAll()
        
        APIManager.shared.getUserAdvertisements(completionHandler: { json in

            if json != nil {
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
