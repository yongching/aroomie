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
            
            SVProgressHUD.show()
            
            Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
                .responseJSON { response in
                    
                    SVProgressHUD.dismiss()
                    
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
        
        SVProgressHUD.show()
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
            .responseString { response in
                
            SVProgressHUD.dismiss()
                
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
                SVProgressHUD.show()
                Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil)
                    .responseJSON { response in
                    
                    SVProgressHUD.dismiss()
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
    func requestServer(_ loadingAnimation: Bool, _ method: HTTPMethod,_ path: String,_ params: [String: Any]?,_ encoding: ParameterEncoding,_ completionHandler: @escaping (JSON) -> Void ) {
        
        let url = baseURL?.appendingPathComponent(path)
        
        refreshTokenIfNeed( completionHandler: {
            
            if loadingAnimation {
                SVProgressHUD.show()
            }
            
            Alamofire.request(url!, method: method, parameters: params, encoding: encoding, headers: nil)
                .responseJSON { response in
                
                if loadingAnimation {
                    SVProgressHUD.dismiss()
                }
        
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
    
    // API - User
    func getUserProfile(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/user/profile/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(true, .get, path, params, URLEncoding(), completionHandler)
    }
    
    func getUserProfile(_ animation: Bool, byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/user/profile/other/\(byId)/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(animation, .get, path, params, URLEncoding(), completionHandler)
    }
    
    func updateUserProfile(params: [String: Any], completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/user/profile/edit/"
        let defaultParam: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        let merged = defaultParam.merged(with: params)
        requestServer(true, .post, path, merged, URLEncoding(), completionHandler)
    }
    
    func updateDeviceToken(token: String, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/device/apns/create/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken(),
            "device_token": token
        ]
        requestServer(false, .post, path, params, URLEncoding(), completionHandler)
    }
    
    // API - Advertisement
    func getAdvertisements(params: [String: Any], completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisements/"
        requestServer(true, .get, path, params, URLEncoding(), completionHandler)
    }
    
    func getAdvertisement(byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisement/\(byId)/"
        requestServer(true, .get, path, nil, URLEncoding(), completionHandler)
    }
    
    func getUserAdvertisements(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisements/self/"
        let param: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(true, .get, path, param, URLEncoding(), completionHandler)
    }
    
    func updateAdvertisement(params: [String: Any], byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisement/edit/\(byId)"
        requestServer(true, .put, path, params, URLEncoding(), completionHandler)
    }
    
    func deleteAdvertisement(byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/advertisement/delete/\(byId)/"
        requestServer(true, .delete, path, nil, URLEncoding(), completionHandler)
    }
    
    // API - Message
    func sendMessage(toId: Int, content: String, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/message/send/\(toId)/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken(),
            "content": content
        ]
        requestServer(true, .post, path, params, URLEncoding(), completionHandler)
    }
    
    func getMessages(animation: Bool, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/messages/"
        let param: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(animation, .get, path, param, URLEncoding(), completionHandler)
    }
    
    func getMessageThread(byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/message/\(byId)/"
        let param: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(true, .get, path, param, URLEncoding(), completionHandler)
    }
    
    // API - Rating
    func getRating(byId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/rating/\(byId)/"
        requestServer(true, .get, path, nil, URLEncoding(), completionHandler)
    }
    
    func addRating(toUserId: Int, score: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/rating/add/\(toUserId)/"
        let params: [String: Any] = [
            "access_token": Default.shared.getAccessToken(),
            "score": score
        ]
        requestServer(true, .post, path, params, URLEncoding(), completionHandler)
    }
    
    func ratingCheck(userId: Int, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/rating/check/\(userId)/"
        let param: [String: Any] = [
            "access_token": Default.shared.getAccessToken()
        ]
        requestServer(true, .get, path, param, URLEncoding(), completionHandler)
    }
}
