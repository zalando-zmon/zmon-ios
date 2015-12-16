//
//  ZmonService.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import Alamofire
import AlamofireJsonToObjects
import EVReflection

class ZmonService: NSObject {

    let zmonEndpoint = "https://zmon2.zalando.net"
    static let sharedInstance: ZmonService = ZmonService()
    
    func get<T: EVObject>(path path: String, parameters: [String:String], success: (T)->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters)
            .responseObject { (response: Result<T, NSError>) in
                if let status = response.value {
                    success(status)
                }
        }
    }
}
