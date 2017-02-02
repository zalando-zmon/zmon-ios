//
//  ZmonStatusService.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

class ZmonStatusService: NSObject {
    
    func status(_ success: @escaping (ZmonStatus)->()) {
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()
        ZmonService.sharedInstance.getObject("/status", parameters: [:], headers: headers, success: success)
    }
}
