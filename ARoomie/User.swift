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
    /**
    var name: String?
    var age_range: String?
    var gender: String?
    var email: String?
    var pictureURL: String?
    **/
 
    var pictureURL: String?
    var name: String?
    var age_range: String?
    var gender: String?
    var race: Int?
    var email: String?
    var phone: String?
    
    static let currentUser = User()
    
    /**
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.age_range = json["age_range"].string
        self.gender = json["gender"].string
        self.email = json["email"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
        //self.pictureURL = json["picture"]["data"]["url"].string
    }
    **/
    
    func setInfo(json: JSON) {
        self.pictureURL = json["profile"]["avatar"].string
        self.name = json["basic"]["first_name"].string! + json["basic"]["last_name"].string!
        self.age_range = json["age_range"].string
        self.gender = json["profile"]["gender"].string
        let index = json["profile"]["race"].stringValue
        if !(index == "") {
            self.race = Int(index)
        }
        self.email = json["basic"]["email"].string
        self.phone = json["profile"]["phone"].string
    }
    
    func resetInfo() {
        self.pictureURL = nil
        self.name = nil
        self.age_range = nil
        self.gender = nil
        self.race = nil
        self.email = nil
        self.phone = nil
    }
}
