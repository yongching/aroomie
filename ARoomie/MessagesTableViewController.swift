//
//  MessagesTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 20/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {

    // MARK: - Properties
    
    var counts: Int = 0
    var userIds: [Int] = []
    var avatarUrls: [String] = []
    var userNames: [String] = []
    var contents: [String] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counts
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell

        if avatarUrls.count > 0 {
            do {
                cell.profileAvatar.image = try UIImage(data: Data(contentsOf: URL(string: avatarUrls[indexPath.row])!))
            } catch _ {

            }
        }
        cell.labelName.text = userNames[indexPath.row]
        cell.labelContent.text = contents[indexPath.row]
        return cell
    }
    
    // MARK: - Actions
    
    func getMessages() {
        var count = 0
        APIManager.shared.getMessages(completionHandler: { json in
            if json != nil {
                for result in json["messages_received"].arrayValue {
                    APIManager.shared.getUserProfile(byId: result["sent_by"].intValue, completionHandler: { json2 in
                        count += 1
                        if json2 != nil {
                            self.counts = count
                            self.avatarUrls.append(json2["profile"]["avatar"].stringValue)
                            self.tableView.reloadData()
                        }
                    })
                    self.userIds.append(result["sent_by"].intValue)
                    self.userNames.append(result["sent_by_name"].stringValue)
                    self.contents.append(result["content"].stringValue)
                }
                self.tableView.reloadData()
            }
        })
    }

}
