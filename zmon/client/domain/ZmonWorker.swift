//
//  ZmonWorker.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import EVReflection

class ZmonWorker: EVObject {
    var lastExecutionTime: NSDate?
    var name: String = ""
    
    var checkInvocations: Int = 0
}
