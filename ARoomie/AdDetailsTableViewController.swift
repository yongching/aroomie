//
//  AdDetailsTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 17/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class AdDetailsTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var textFieldRental: UILabel!
    @IBOutlet weak var labelMoveInDate: UILabel!
    @IBOutlet weak var labelDeposit: UILabel!
    
    // Segue
    var userId: Int?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = userId {
            print(id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 42
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

    // MARK: - Actions
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
