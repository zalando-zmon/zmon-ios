//
//  Credentials.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class Credentials: NSObject {
    
    let username: String
    let password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}