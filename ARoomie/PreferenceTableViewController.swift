//
//  PreferenceTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 29/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit
import DropDown

class PreferenceTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var buttonGender: DropDownButton!
    @IBOutlet weak var buttonRace: DropDownButton!
    
    // MARK: - DropDown
    
    let genderDropDown = DropDown()
    let raceDropDown = DropDown()

    lazy var dropDowns: [DropDown] = {
        return [
            self.genderDropDown,
            self.raceDropDown
        ]
    }()
    
    // MARK: - Actions
    
    @IBAction func chooseGender(_ sender: Any) {
        genderDropDown.show()
    }
    
    @IBAction func chooseRace(_ sender: Any) {
        raceDropDown.show()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // If you want to have the dropdown underneath your anchor view, you can do this:
        genderDropDown.bottomOffset = CGPoint(x: 0, y: genderDropDown.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        genderDropDown.dataSource = [
            "10 €",
            "20 €",
            "30 €"
        ]
        
        // Action triggered on selection
        genderDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonGender.setTitle(item, for: .normal)
        }
    }

    func setupRaceDropDown() {
        raceDropDown.anchorView = buttonRace
        
        // If you want to have the dropdown underneath your anchor view, you can do this:
        raceDropDown.bottomOffset = CGPoint(x: 0, y: raceDropDown.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        raceDropDown.dataSource = [
            "10 €",
            "20 €",
            "30 €"
        ]
        
        // Action triggered on selection
        raceDropDown.selectionAction = { [unowned self] (index, item) in
            self.buttonRace.setTitle(item, for: .normal)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
