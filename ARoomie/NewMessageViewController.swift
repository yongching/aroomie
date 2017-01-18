//
//  NewMessageViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 18/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    
    @IBOutlet weak var textView: UITextView!
    
    let countsLimit: Int = 500
    var labelPlaceholder : UILabel!
    var labelCount: UILabel!
    
    // Segue
    var receiverId: Int?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
        setupCustomView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Setup
    
    func setupTextView() {
        
        textView.delegate = self
        labelPlaceholder = UILabel()
        labelPlaceholder.text = "Enter some text..."
        labelPlaceholder.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        labelPlaceholder.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        labelPlaceholder.sizeToFit()
        labelPlaceholder.textColor = UIColor.lightGray
        labelPlaceholder.isHidden = !textView.text.isEmpty
        textView.addSubview(labelPlaceholder)
    }
    
    func setupCustomView() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        labelCount = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 5, width: 50, height: 20))
        labelCount.text = String(countsLimit)
        labelCount.textColor = UIColor.lightGray
        labelCount.font = UIFont.italicSystemFont(ofSize: 20)
        customView.addSubview(labelCount)
        textView.inputAccessoryView = customView
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        labelPlaceholder.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        let count = countsLimit - numberOfChars
        labelCount.text = String(count)
        return numberOfChars < countsLimit
    }

    
    // MARK: - Actions
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: Any) {
        
        self.textView.endEditing(true)
        
        if let id = receiverId {
            APIManager.shared.sendMessage(toId: id, contents: textView.text, completionHandler: { json in
                
                if json != nil {
                    let alert = UIAlertController(title: "Successfully Sent!", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { completionHandler in 
                        self.dismiss(animated: true, completion: nil)
                    }))
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
    
}
