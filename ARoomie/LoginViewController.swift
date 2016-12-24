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

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var needHelpButton: UIButton!
    
    var fbLoginSuccess = false
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 20
        needHelpButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true) {
            //performSegue(withIdentifier: "CameraView", sender: self)
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            self.present(logInViewController, animated: true, completion: nil)
        }
    }

    @IBAction func facebookLogin(_ sender: AnyObject) {
        if (FBSDKAccessToken.current() != nil) {
            fbLoginSuccess = true
            self.viewDidAppear(true)
        } else {
            FBManager.shared.logIn(
                withReadPermissions: ["public_profile", "email"],
                from: self,
                handler: {( result, error) in
                    if (error == nil) {
                        self.fbLoginSuccess = true
                    }
            })
        }
    }
    
}

