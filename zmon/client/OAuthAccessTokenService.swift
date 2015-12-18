//
//  OAuthAccessTokenService.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

class OAuthAccessTokenService: NSObject {
    
    func login(username username: String, password: String, success: (String)->(), failure: (NSError)->()) -> () {
        let basicAuthEncoded = "\(username):\(password)".base64()
        let authHeader = "Basic \(basicAuthEncoded)"
        
        ZmonService.sharedInstance.getAuthToken(path: "/access_token", parameters: [:], headers: ["Authorization" : authHeader], success: success, failure: failure)
    }
    
}
