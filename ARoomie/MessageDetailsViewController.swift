//
//  MessageDetailsViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 21/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessageDetailsViewController: JSQMessagesViewController {
    
    var userId: Int?
    var oppositeSenderId: Int?
    var oppositeSenderName: String?
    var messages = [JSQMessage]()
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if let id = userId {
            self.senderId = "\(id)"
            self.senderDisplayName = ""
            
        } else {
            self.senderId = ""
            self.senderDisplayName = ""
        }
        
        if let name = oppositeSenderName {
            self.title = name
        }
        
        // Get all the chat
        getAllChat()
        
        // Bubbles with tails
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        // Remove avatar
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        self.automaticallyScrollsToMostRecentMessage = true
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    func getAllChat() {

        if let id = oppositeSenderId {
            APIManager.shared.getMessageThread(byId: id, completionHandler: { json in
                
                if json != nil {
                    for result in json["message_thread"].arrayValue {
                        if let name = self.oppositeSenderName {
                            if let currentUserId = self.userId {
                                
                                // Current user
                                if result["sent_by"].intValue == currentUserId {
                                    let message = JSQMessage(senderId: String(currentUserId), displayName: name, text: result["content"].stringValue)
                                    self.messages.append(message!)
                                    self.finishSendingMessage()
                                
                                // Opposite user
                                } else {
                                    let message = JSQMessage(senderId: String(id), displayName: name, text: result["content"].stringValue)
                                    self.messages.append(message!)
                                    self.finishReceivingMessage()
                                }
                                
                            }
                        }
                    }
                }
            })
        }
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message!)
        self.finishSendingMessage(animated: true)
        
        if let id = oppositeSenderId {
            APIManager.shared.sendMessage(toId: id, content: text, completionHandler: { json in
                
                if json != nil {
                    let alert = UIAlertController(title: "Successfully Sent!", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                } else {
                    let message = "There is some problem sending your message!"
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
    }
    
    //MARK: - JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return Int(messages[indexPath.item].senderId) == userId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {

        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {

        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
}
