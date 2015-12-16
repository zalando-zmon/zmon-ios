//
//  ZmonStatusService.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import Alamofire
import AlamofireJsonToObjects

class ZmonStatusService: NSObject {
    
    func status(success success: (ZmonStatus)->()) {
        ZmonService.sharedInstance.get(path: "/rest/status", parameters: [:], success: success)
    }
}
