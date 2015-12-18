//
//  ZmonStatusService.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

class ZmonStatusService: NSObject {
    
    func status(success success: (ZmonStatus)->()) {
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()
        ZmonService.sharedInstance.getObject(path: "/status", parameters: [:], headers: headers, success: success)
    }
}
