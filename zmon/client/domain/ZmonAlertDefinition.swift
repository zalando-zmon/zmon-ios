//
//  ZmonAlertDefinition.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import EVReflection

class ZmonAlertDefinition: EVObject {

    var id: Int = 0
    var checkDefinitionId: Int = 0
    var priority: Int = 0
    
    var cloneable: Bool = false
    var deletable: Bool = false
    var editable: Bool = false
    
    var name: String = ""
    var status: String = ""
    var condition: String = ""
    var lastModifiedBy: String = ""
    var team: String = ""
    var responsibleTeam: String = ""
    
    var lastModified: NSDate?
    
    override func setValue(_ value: Any!, forUndefinedKey key: String) {
        //NOOP
    }
}
