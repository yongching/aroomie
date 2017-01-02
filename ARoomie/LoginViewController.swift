//
//  LoginViewController.swift
//  ARoomie
//
//  Created by Yong Ching on 16/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var needHelpButton: UIButton!
   
    // MARK: - Actions
    
    @IBAction func facebookLogin(_ sender: AnyObject) {
    
        if (FBSDKAccessToken.current() != nil) {
            /**
            APIManager.shared.login(completionHandler: { (error) in
                if error == nil {
                    self.viewDidAppear(true)
                }
            })
            **/
            self.viewDidAppear(true)
            
        } else {
            
            FBManager.shared.logIn(
                withReadPermissions: ["public_profile", "email"],
                from: self,
                handler: {( result, error) in
                    if (error == nil) {
                        /**
                        FBManager.getFBUserData(completionHandler: {
                            self.viewDidAppear(true)
                        })
                        **/
                        APIManager.shared.login(completionHandler: { error in
                            if error == nil {
                                self.viewDidAppear(true)
                            }
                        })
                    }
            })
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil) {
            print("FBSDKToken exist")
        } else {
            print("no fb sdk token")
        }
        
        setupButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("viewDidAppear")
        if (FBSDKAccessToken.current() != nil) {
            print("DA FBSDKToken exist")
        } else {
            print("DA no fb sdk token")
        }

        if (FBSDKAccessToken.current() != nil) {
            
            APIManager.shared.getUserInfo(completionHandler: { json in
                
                if json != nil {
                    User.currentUser.setInfo(json: json)
                }
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
                self.present(tabBarViewController, animated: true, completion: nil)
            })
        }
    }

    // MARK: Setup
    
    func setupButton() {
        loginButton.layer.cornerRadius = 20
        needHelpButton.layer.cornerRadius = 20
    }
    
}
