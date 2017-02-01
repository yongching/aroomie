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
        getMessages(animation: true)
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

        if senderIds.count == self.counts {
            do {
                cell.profileAvatar.image = try UIImage(data: Data(contentsOf: URL(string: avatarUrls[indexPath.row])!))
            } catch _ {}
            cell.labelName.text = senderNames[indexPath.row]
            cell.labelContent.text = contents[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if senderIds.count == self.counts {
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
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.getMessages(animation: false)
    }
    
    func resetArray() {
        self.avatarUrls.removeAll()
        self.senderIds.removeAll()
        self.senderNames.removeAll()
        self.contents.removeAll()
    }
    
    func getMessages(animation: Bool) {
        
        self.resetArray()
        
        APIManager.shared.getMessages(animation: animation, completionHandler: { json in
            if json != nil {
                
                self.counts = json["messages_received"].arrayValue.count
                
                for result in json["messages_received"].arrayValue {
                    self.userId = result["sent_to"].intValue
                    self.senderIds.append(result["sent_by"].intValue)
                    self.senderNames.append(result["sent_by_name"].stringValue)
                    self.contents.append(result["content"].stringValue)
                    self.avatarUrls.append(result["sender_avatar"].stringValue)
                    
                    if self.avatarUrls.count == self.counts {
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }
            }
        })
    }

}
