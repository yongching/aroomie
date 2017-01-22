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
   
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil) {
            print("viewDidLoad FBSDKToken exist")
        } else {
            print("viewDidLoad FBSDKToken empty")
            //Default.shared.resetUserDefault()
        }
        
        setupButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (FBSDKAccessToken.current() != nil) {
            print("viewDidAppear FBSDKToken exist")
        } else {
            print("viewDidAppear FBSDKToken empty")
            //Default.shared.resetUserDefault()
        }
        
        if (FBSDKAccessToken.current() != nil) {
            print(Default.shared.getAccessToken())
            print(Default.shared.getRefreshToken())
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            self.present(tabBarViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: Setup
    
    func setupButton() {
        loginButton.layer.cornerRadius = 20
        needHelpButton.layer.cornerRadius = 20
    }
    
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
            print("Performing fb login")
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
                        print("Success fb login")
                        APIManager.shared.login(completionHandler: { error in
                            if error == nil {
                                self.viewDidAppear(true)
                            }
                        })
                    }
            })
        }
    }
    
}
