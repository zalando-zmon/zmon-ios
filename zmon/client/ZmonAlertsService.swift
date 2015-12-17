//
//  ZmonAlertsService.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

class ZmonAlertsService: NSObject {

    func list(success success: ([ZmonAlertStatus]) -> ()) {
        ZmonService.sharedInstance.getObjectList(path: "/rest/allAlerts", parameters: [:], success: success)
    }
    
    func listByTeam(teamName teamName: String, success: ([ZmonAlertStatus]) -> ()) {
        log.debug("Listing alerts for teams with query ?team=\(teamName)")
        ZmonService.sharedInstance.getObjectList(path: "/rest/allAlerts", parameters: ["team": teamName], success: success)
    }
}
