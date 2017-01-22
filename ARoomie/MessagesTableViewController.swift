//
//  MessagesTableViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 20/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessagesTableViewController: UITableViewController {

    // MARK: - Properties
    
    var counts: Int = 0
    var userId: Int?
    var senderIds: [Int] = []
    var avatarUrls: [String] = []
    var senderNames: [String] = []
    var contents: [String] = []
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupPullToRefresh()
        getMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
        cell.labelName.text = senderNames[indexPath.row]
        cell.labelContent.text = contents[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if contents.count > 0 {
            let chatView = MessageDetailsViewController()
            chatView.userId = self.userId
            chatView.oppositeSenderId = senderIds[indexPath.row]
            chatView.oppositeSenderName = senderNames[indexPath.row]
            self.navigationController?.pushViewController(chatView, animated: true)
        }
    }
    
    // MARK: - Setup
    
    func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MessagesTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    // MARK: - Actions
    
    func resetArray() {
        self.avatarUrls.removeAll()
        self.senderIds.removeAll()
        self.senderNames.removeAll()
        self.contents.removeAll()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        print("pulling")
        self.resetArray()
        self.getMessages()
    }
    
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
                            self.userId = result["sent_to"].intValue
                            self.senderIds.append(result["sent_by"].intValue)
                            self.senderNames.append(result["sent_by_name"].stringValue)
                            self.contents.append(result["content"].stringValue)
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    })
                }
            }
        })
    }

}
