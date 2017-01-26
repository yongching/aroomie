//
//  Default.swift
//  ARoomie
//
//  Created by Yong Ching on 01/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import UIKit

class Default {
    
    static let shared = Default()
    
    let defaults = UserDefaults.standard
    
    // Getter
    func getDeviceToken() -> String {
        if let accessToken = defaults.object(forKey: "device_token") {
            return accessToken as! String
        }
        return ""
    }
    
    func getAccessToken() -> String {
        if let accessToken = defaults.object(forKey: "access_token") {
            return accessToken as! String
        }
        return ""
    }
    
    func getRefreshToken() -> String {
        if let refreshToken = defaults.object(forKey: "refresh_token") {
            return refreshToken as! String
        }
        return ""
    }

    func getExpired() -> Any {
        if let expired = defaults.object(forKey: "expired") {
            return expired as! Date
        }
        return ""
    }
    
    // Reset user default
    func resetUserDefault() -> Void {
        if !(getAccessToken().isEmpty) {
            defaults.removeObject(forKey: "device_token")
        }
        
        if !(getAccessToken().isEmpty) {
            defaults.removeObject(forKey: "access_token")
        }
        
        if !(getRefreshToken().isEmpty) {
            defaults.removeObject(forKey: "refresh_token")
        }
        
        if (defaults.object(forKey: "expired") as? Date) != nil {
            defaults.removeObject(forKey: "expired")
        }
    }
}
