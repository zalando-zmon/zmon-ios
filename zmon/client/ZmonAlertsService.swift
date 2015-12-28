//
//  ZmonAlertsService.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

class ZmonAlertsService: NSObject {

    func list(success success: ([ZmonAlertStatus]) -> ()) {
        ZmonService.sharedInstance.getObjectList(path: "/active-alerts", parameters: [:], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }
    
    func listByTeam(teamName teamName: String, success: ([ZmonAlertStatus]) -> ()) {
        log.debug("Listing alerts for teams with query ?team=\(teamName)")
        ZmonService.sharedInstance.getObjectList(path: "/active-alerts", parameters: ["team": teamName], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }
    
    func registerDevice(deviceSubscription deviceSubscription: DeviceSubscription, success: () -> (), failure: (NSError) -> ()) {
        let parameters: [String:String] = deviceSubscription.toDictionary() as! [String:String]
        
        ZmonService.sharedInstance.postJson(path: "/device", parameters: parameters, headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success, failure: failure)
    }
}
