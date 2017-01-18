//
//  APIManager.swift
//  ARoomie
//
//  Created by Yong Ching on 01/01/2017.
//  Copyright © 2017 Yong Ching. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit
import SVProgressHUD

class APIManager {
    
    static let shared = APIManager()
    
    let baseURL = NSURL(string: BASE_URL)
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    // API - Login
    func login(completionHandler: @escaping (NSError?) -> Void) {
        
        let fbToken: String?
        if let token = FBSDKAccessToken.current() {
            
            fbToken = token.tokenString
        
            let path = "api/social/convert-token/"
            let url = baseURL!.appendingPathComponent(path)
            let params: [String: Any] = [
                "grant_type": "convert_token",
                "client_id": CLIENT_ID,
                "client_secret": CLIENT_SECRET,
                "backend": "facebook",
                "token": fbToken!
            ]
            
            Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
                .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        let jsonData = JSON(value)
                        
                        self.accessToken = jsonData["access_token"].string!
                        self.refreshToken = jsonData["refresh_token"].string!
                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                        
                        let defaults = UserDefaults.standard
                        defaults.set(self.accessToken, forKey: "access_token")
                        defaults.set(self.refreshToken, forKey: "refresh_token")
                        defaults.set(self.expired, forKey: "expired")
                        
                        completionHandler(nil)
                        break
                        
                    case .failure(let error):
                        completionHandler(error as NSError?)
                        break
                    }
            }
        }
    }
        
    // API - Logout
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        
        let path = "api/social/revoke-token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "token": Default.shared.getAccessToken()
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .responseString { response in

            switch response.result {
            case .success:
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
        }
    }
    
    // API - Refresh token
    func refreshTokenIfNeed(completionHandler: @escaping () -> Void) {
        
        let path = "api/social/token/"
        let url = baseURL?.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "refresh_token",
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "refresh_token": Default.shared.getRefreshToken()
        ]
        
        //if let expired = defaults.object(forKey: "expired") as? Date {
        if let expired = Default.shared.getExpired() as? Date {

            if Date() > expired {
                print("token refreshing")
                Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
                    .responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        let jsonData = JSON(value)
                        print(value)
                        self.accessToken = jsonData["access_token"].string!
                        self.refreshToken = jsonData["refresh_token"].string!
                        self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                        
                        let defaults = UserDefaults.standard
                        defaults.set(self.accessToken, forKey: "access_token")
                        defaults.set(self.refreshToken, forKey: "refresh_token")
                        defaults.set(self.expired, forKey: "expired")
                        
                        print("token refresh success")
                        completionHandler()
                        break
                        
                    case .failure:
                        print("token refresh failed")
                        completionHandler()
                        break
                    }
                }
                
            } else {
                //print("token haven't expired")
                completionHandler()
            }
        }
    }
    
    // Alamofire Wrapper
    func requestServer(_ method: HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping (JSON) -> Void ) {
        
        let url = baseURL?.appendingPathComponent(path)
        
        refreshTokenIfNeed( completionHandler: {
            
            SVProgressHUD.show()
            
            Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: nil)
                .responseJSON { response in
                
                SVProgressHUD.dismiss()
                    
                switch response.result {
                case .success(let value):
                    if response.response?.statusCode == 200 {
                        let jsonData = JSON(value)
                        completionHandler(jsonData)
                    } else {
                        completionHandler(nil)
                    }
                    break
                
                case .failure(let error):
                    print("Alamofire failed \(error)")
                    completionHandler(nil)
                    break
                }
            }
        })
    }

    /********** USER **********/
    
    // API - Get user profile
    func getUserProfile(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/user/profile/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Get other user profile
    func getUserProfile(byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/user/profile/other/\(byId)/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Update user profile
    func updateUserProfile(params: [String: Any], completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/user/profile/edit/"
        let params2: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        let merged = params2.merged(with: params)
        requestServer(.post, path, merged, URLEncoding(), completionHandler)
    }
    
    // API - Get advertisement list
    func getAdvertisements(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisements/"
        let params: [String: Any] = [:]
        
        requestServer(.get, path, params, URLEncoding(), completionHandler)
    }
    
    func getAdvertisement(byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisement/\(byId)/"
        requestServer(.get, path, nil, URLEncoding(), completionHandler)
    }
}
