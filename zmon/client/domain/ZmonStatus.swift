//
//  ZmonStatus.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import EVReflection

class ZmonStatus: EVObject {
    var alertsActive: Int = 0
    var workersActive: Int = 0
    var workersTotal: Int = 0
    
    var checkInvocations: Int = 0
    var queueSize: Int = 0
    
    var queues = [ZmonQueue]()
    var workers = [ZmonWorker]()
}
