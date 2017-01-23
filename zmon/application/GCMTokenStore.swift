//
//  GCMTokenStore.swift
//  zmon
//
//  Created by Andrej Kincel on 18/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class GCMTokenStore: NSObject {
    
    fileprivate struct Keys {
        static let deviceToken = "zmon.gcm.deviceToken"
    }
    
    static let sharedInstance: GCMTokenStore = GCMTokenStore()
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    
    func setDeviceToken(_ deviceToken: String) {
        userDefaults.set(deviceToken, forKey: Keys.deviceToken)
    }
    
    func deviceToken() -> String? {
        return userDefaults.object(forKey: Keys.deviceToken) as? String
    }
    
}
