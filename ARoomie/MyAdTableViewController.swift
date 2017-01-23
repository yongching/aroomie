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
    
    var counts = 0
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
        
        return counts
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

    // MARK : - Actions
    
    func getAdvertisements() {
        
        roomUrls.removeAll()
        placeNames.removeAll()
        
        APIManager.shared.getUserAdvertisements(completionHandler: { json in
            print(json)
            if json != nil {
                self.counts = json.arrayValue.count
                for result in json.arrayValue {
                    self.roomUrls.append(result["photo"].stringValue)
                    self.placeNames.append(result["place_name"].stringValue)
                }
                self.tableView.reloadData()
            }
        })
    
    }
}
