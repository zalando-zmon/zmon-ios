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
    
    static let sharedInstance: ZmonService = ZmonService()

    private let authEndpoint = "https://token.auth.zalando.com"
    private let zmonEndpoint = "https://zmon-notification-service.stups.zalan.do/api/v1/mobile"
    
    func getAuthToken(path path: String, parameters: [String:String], headers: [String:String], success: (String)->(), failure: (NSError)->()) {
        Alamofire
            .request(.GET, "\(authEndpoint)\(path)", parameters: parameters, encoding: .URL, headers: headers)
            .validate()
            .responseString(completionHandler: { (response: Response<String, NSError>) -> Void in
                switch response.result {
                case .Success:
                    let token: String = response.result.value!
                    log.debug("Authorization successfull, returned token: \(token)")
                    
                    //STRIP \n which is curiously appended to the end of token
                    success(token.substringToIndex(token.endIndex.advancedBy(-1)))
                    break
                case .Failure(let error):
                    log.error(error.description)
                    failure(error)
                    break
                }
            })
    }
    
    func getString(path path: String, parameters: [String:String], headers: [String:String], success: (String)->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters, encoding: .URL, headers: headers)
            .responseString(completionHandler: { (response: Response<String, NSError>) -> Void in
                if let string = response.result.value {
                    success(string)
                }
            })
    }
    
    func getObject<T: EVObject>(path path: String, parameters: [String:String], headers: [String:String], success: (T)->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters, encoding: .URL, headers: headers)
            .validate()
            .responseObject { (response: Result<T, NSError>) in
                if response.isSuccess {
                    success(response.value!)
                }
                else {
                    log.error(response.debugDescription)
                }
                
        }
    }
    
    func getObjectList<T: EVObject>(path path: String, parameters: [String:String], headers: [String:String], success: ([T])->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters, encoding: .URL, headers: headers)
            .responseArray { (response: Result<[T], NSError>) in
                if let array = response.value {
                    success(array)
                }
        }
    }
    
    func getStringList(path path: String, parameters: [String:String], headers: [String:String], success: ([String])->()) {
        Alamofire
            .request(.GET, "\(zmonEndpoint)\(path)", parameters: parameters, encoding: .URL, headers: headers)
            .responseJSON { (response: Response<AnyObject, NSError>) -> Void in
                if let stringList = response.result.value as? [String] {
                    success(stringList)
                }
        }
    }
}
