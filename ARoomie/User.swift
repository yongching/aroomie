//
//  User.swift
//  ARoomie
//
//  Created by Yong Ching on 25/12/2016.
//  Copyright © 2016 Yong Ching. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var name: String?
    var email: String?
    var age_range: String?
    var pictureURL: String?
    
    static let currentUser = User()
    
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.email = json["email"].string
        self.age_range = json["age_range"].string
        
        //let image = json["picture"].dictionary
        //let imageData = image?["data"]?.dictionary
        //self.pictureURL = imageData?["url"]?.string
        self.pictureURL = json["picture"]["data"]["url"].string
    }
    
    func resetInfo() {
        self.name = nil
        self.email = nil
        self.age_range = nil
        self.pictureURL = nil
    }
}
