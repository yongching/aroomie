//
//  LifestyleTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 29/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit

class LifestyleTableViewController: UITableViewController {
    
    // MARK: - View lifecycle
    
    var isOns: [Int] = []
    
    let emojiUnicodes: Array<String> = ["\u{1F3CA}", "\u{1F3C4}", "\u{1F485}", "\u{1F6B4}", "\u{1F4DA}", "\u{1F483}", "\u{1F3AE}", "\u{1F4AA}", "\u{1F3C0}", "\u{1F3BE}", "\u{26BD}", "\u{26BE}", "\u{1F3B5}", "\u{1F3B1}", "\u{1F3A8}", "\u{1F3A4}", "\u{1F3A6}", "\u{1F3A3}", "\u{1F37B}", "\u{1F355}", "\u{1F3B3}"]
    
    let emojiDescriptions: Array<String> = ["Swimming", "Surfing", "Nail Polish", "Cycling", "Reading", "Dancing", "Games", "Gym Workout", "Basketball", "Tennis", "Football", "Baseball", "Music", "Snorker", "Painting", "Singing", "Shooting", "Fishing", "Drinking", "Pizza Lover", "Bowling"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        getLifestyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLifestyle()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiUnicodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        cell.labelEmojiUnicode.text = emojiUnicodes[indexPath.row]
        cell.labelDescription.text = emojiDescriptions[indexPath.row]
        
        if isOns.count > 0 {
            cell.buttonSwitch.isOn = isOns[indexPath.row] == 0 ? false : true
            cell.buttonSwitch.restorationIdentifier = "\(indexPath.row)"
            cell.buttonSwitch.addTarget(self, action: #selector(LifestyleTableViewController.switchChanged), for: .valueChanged)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    func getLifestyle() {
        
        isOns.removeAll()
        let lifestyle = User.currentUser.lifestyle
        let array = lifestyle?.components(separatedBy: ",")
        
        if let ary = array {
            for item in ary {
                isOns.append(Int(item)!)
            }
        }
        self.tableView.reloadData()
    }
    
    func switchChanged(selectedSwitch: UISwitch) {

        if selectedSwitch.isOn {
            self.isOns[Int(selectedSwitch.restorationIdentifier!)!] = 1
        } else {
            self.isOns[Int(selectedSwitch.restorationIdentifier!)!] = 0
        }
    }
    
    @IBAction func save(_ sender: Any) {

        var lifestyle: String = ""
        for (index, item) in self.isOns.enumerated() {
            lifestyle += String(item)
            if index != self.isOns.count-1 {
                lifestyle += ","
            }
        }
        
        let params: [String: Any] = [
            "race": "",
            "phone": "",
            "lifestyle_info": lifestyle,
            "gender_pref": "",
            "race_pref": "",
            "budget_pref": "",
            "move_in_pref": ""
        ]
        
        APIManager.shared.updateUserProfile(params: params, completionHandler: { json in
            if json != nil {
                let alert = UIAlertController(title: "Successfully Saved!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "There is error saving your lifestyle info!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Error", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
}
