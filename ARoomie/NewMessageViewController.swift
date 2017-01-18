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
    var labelPlaceholder : UILabel!
    var labelCount: UILabel!
    let countsLimit: Int = 500
    
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
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        labelCount = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 40, y: 0, width: 40, height: 20))
        labelCount.text = String(countsLimit)
        labelCount.textColor = UIColor.lightGray
        labelCount.font = UIFont.italicSystemFont(ofSize: 20)
        labelCount.sizeToFit()
        customView.addSubview(labelCount)
        textView.inputAccessoryView = customView
    }
    
    // MARK: - Actions
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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

}
