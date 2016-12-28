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
    
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var raceButton: UIButton!
    
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
    
    // MARK: - The Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
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
    }
    
    func setupGenderDropDown() {
        genderDropDown.anchorView = genderButton
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        genderDropDown.bottomOffset = CGPoint(x: 0, y: genderDropDown.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        genderDropDown.dataSource = [
            "10 €",
            "20 €",
            "30 €",
            "40 €",
            "50 €",
            "60 €",
            "70 €",
            "80 €",
            "90 €",
            "100 €",
            "110 €",
            "120 €"
        ]
        
        // Action triggered on selection
        genderDropDown.selectionAction = { [unowned self] (index, item) in
            self.genderButton.setTitle(item, for: .normal)
        }
    }

    func setupRaceDropDown() {
        raceDropDown.anchorView = genderButton
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        raceDropDown.bottomOffset = CGPoint(x: 0, y: raceDropDown.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        raceDropDown.dataSource = [
            "10 €",
            "20 €",
            "30 €",
            "40 €",
            "50 €",
            "60 €",
            "70 €",
            "80 €",
            "90 €",
            "100 €",
            "110 €",
            "120 €"
        ]
        
        // Action triggered on selection
        raceDropDown.selectionAction = { [unowned self] (index, item) in
            self.raceButton.setTitle(item, for: .normal)
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
