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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
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
        
        genderDropDown.bottomOffset = CGPoint(x: 0, y: genderDropDown.bounds.height)
        
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
        
        raceDropDown.bottomOffset = CGPoint(x: 0, y: raceDropDown.bounds.height)
        
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

    // MARK: - Actions
    
    @IBAction func chooseGender(_ sender: Any) {
        genderDropDown.show()
    }
    
    @IBAction func chooseRace(_ sender: Any) {
        raceDropDown.show()
    }
    
}
