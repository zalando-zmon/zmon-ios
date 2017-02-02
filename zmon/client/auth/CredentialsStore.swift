//
//  CredentialsStore.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class CredentialsStore: NSObject {
    
    fileprivate struct Keys {
        static let username = "zmon.credentials.username"
        static let password = "zmon.credentials.password"
        static let saveCredentials = "zmon.credentials.save"
        static let accessToken = "zmon.credentials.accesstoken"
    }
    
    static let sharedInstance: CredentialsStore = CredentialsStore()
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    fileprivate var userToken: String = ""
    
    func setCredentials(_ credentials: Credentials) {
        userDefaults.set(credentials.username, forKey: Keys.username)
        userDefaults.set(credentials.password, forKey: Keys.password)
    }
    
    func credentials() -> Credentials? {
        let username = userDefaults.object(forKey: Keys.username) as? String
        let password = userDefaults.object(forKey: Keys.password) as? String
        
        if (username != nil && password != nil) {
            return Credentials(username: username!, password: password!)
        }
        else {
            return nil
        }
    }
    
    func clearCredentials() {
        userDefaults.removeObject(forKey: Keys.username)
        userDefaults.removeObject(forKey: Keys.password)
    }
    
    func clearToken() {
        userDefaults.removeObject(forKey: Keys.accessToken)
        
    }
    
    func setSaveCredentials(_ saveCredentials: Bool) {
        userDefaults.set(saveCredentials, forKey: Keys.saveCredentials)
        if !saveCredentials {
            self.clearCredentials()
        }
    }
    
    func saveCredentials() -> Bool {
        return userDefaults.bool(forKey: Keys.saveCredentials)
    }
    
    func setAccessToken(_ accessToken: String) {
        userDefaults.set(accessToken, forKey: Keys.accessToken)
        self.userToken = accessToken
    }
    
    func accessToken() -> String? {
        return userDefaults.object(forKey: Keys.accessToken) as? String
    }
    
    //TODO: temporary approach (should introduce something similiar to RequestInterceptors used in Zmon-Android version
    func accessTokenHeader() -> [String:String] {
        return ["Authorization": "Bearer \(self.userToken)"]
    }

}
