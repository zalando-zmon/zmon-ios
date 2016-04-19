//
//  CredentialsStore.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class CredentialsStore: NSObject {
    
    private struct Keys {
        static let username = "zmon.credentials.username"
        static let password = "zmon.credentials.password"
        static let saveCredentials = "zmon.credentials.save"
        static let accessToken = "zmon.credentials.accesstoken"
    }
    
    static let sharedInstance: CredentialsStore = CredentialsStore()
    private let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    private var userToken: String = ""
    
    func setCredentials(credentials credentials: Credentials) {
        userDefaults.setObject(credentials.username, forKey: Keys.username)
        userDefaults.setObject(credentials.password, forKey: Keys.password)
    }
    
    func credentials() -> Credentials? {
        let username = userDefaults.objectForKey(Keys.username) as? String
        let password = userDefaults.objectForKey(Keys.password) as? String
        
        if (username != nil && password != nil) {
            return Credentials(username: username!, password: password!)
        }
        else {
            return nil
        }
    }
    
    func clearCredentials() {
        userDefaults.removeObjectForKey(Keys.username)
        userDefaults.removeObjectForKey(Keys.password)
    }
    
    func clearToken() {
        userDefaults.removeObjectForKey(Keys.accessToken)
        
    }
    
    func setSaveCredentials(saveCredentials saveCredentials: Bool) {
        userDefaults.setBool(saveCredentials, forKey: Keys.saveCredentials)
        if !saveCredentials {
            self.clearCredentials()
        }
    }
    
    func saveCredentials() -> Bool {
        return userDefaults.boolForKey(Keys.saveCredentials)
    }
    
    func setAccessToken(accessToken: String) {
        userDefaults.setObject(accessToken, forKey: Keys.accessToken)
        self.userToken = accessToken
    }
    
    func accessToken() -> String? {
        return userDefaults.objectForKey(Keys.accessToken) as? String
    }
    
    //TODO: temporary approach (should introduce something similiar to RequestInterceptors used in Zmon-Android version
    func accessTokenHeader() -> [String:String] {
        return ["Authorization": "Bearer \(self.userToken)"]
    }

}
