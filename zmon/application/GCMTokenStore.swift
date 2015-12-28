//
//  GCMTokenStore.swift
//  zmon
//
//  Created by Andrej Kincel on 18/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class GCMTokenStore: NSObject {
    
    private struct Keys {
        static let deviceToken = "zmon.gcm.deviceToken"
    }
    
    static let sharedInstance: GCMTokenStore = GCMTokenStore()
    private let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func setDeviceToken(deviceToken: String) {
        userDefaults.setObject(deviceToken, forKey: Keys.deviceToken)
    }
    
    func deviceToken() -> String? {
        return userDefaults.objectForKey(Keys.deviceToken) as? String
    }
    
}
