//
//  ZmonAlertStatus.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import EVReflection

class ZmonAlertStatus: EVObject {

    var message: String = ""
    var entities: [ZmonEntity] = []
    var alertDefinition: ZmonAlertDefinition?
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        //NOOP
    }
}
