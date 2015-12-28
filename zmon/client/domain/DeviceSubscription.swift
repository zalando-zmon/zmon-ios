//
//  DeviceSubscription.swift
//  zmon
//
//  Created by Andrej Kincel on 18/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import EVReflection

class DeviceSubscription: EVObject {
    
    var registrationToken: String = ""
    
    static func withRegistrationToken(registrationToken registrationToken: String) -> DeviceSubscription {
        let deviceSubscription = DeviceSubscription()
        
        deviceSubscription.registrationToken = registrationToken
        return deviceSubscription
    }

}
