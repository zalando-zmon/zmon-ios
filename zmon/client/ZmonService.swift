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
    
    func getObject<T: EVObject>(path path: String, parameters: [String:String], success: (T)->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters)
            .responseObject { (response: Result<T, NSError>) in
                if let object = response.value {
                    success(object)
                }
        }
    }
    
    func getObjectList<T: EVObject>(path path: String, parameters: [String:String], success: ([T])->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters)
            .responseArray { (response: Result<[T], NSError>) in
                if let array = response.value {
                    success(array)
                }
        }
    }
    
    func getStringList(path path: String, parameters: [String:String], success: ([String])->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters)
            .responseJSON { (response: Response<AnyObject, NSError>) -> Void in
                if let stringList = response.result.value as? [String] {
                    success(stringList)
                }
        }
    }
}
