//
//  FBManager.swift
//  ARoomie
//
//  Created by Yong Ching on 16/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FBManager {
    
    static let shared = FBSDKLoginManager()
    
    public class func getFBUserData(completionHandler: @escaping () -> Void) {
        if (FBSDKAccessToken.current() != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, age_range, email, picture.type(normal)"])
                .start(completionHandler: { ( connection, result, error) in
                
                if (error == nil) {
                    let json = JSON(result!)
                    print(json)
                    
                    User.currentUser.setInfo(json: json)
                    completionHandler()
                }
            })
        }
    }
}

