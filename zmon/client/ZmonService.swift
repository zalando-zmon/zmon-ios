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

    fileprivate let authEndpoint = "https://token.auth.zalando.com"
    fileprivate let zmonEndpoint = "https://notification-service.zmon.zalan.do/api/v1/mobile"
    
    func getAuthToken(_ path: String, parameters: [String:String], headers: [String:String], success: @escaping (String)->(), failure: @escaping (NSError)->()) {
        Alamofire
            .request(URL(string: "\(authEndpoint)\(path)")!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers)
            .validate()
            .responseString(completionHandler: { (response) -> Void in
                switch response.result {
                case .success(let value):
                    let token = value
                    log.debug("Authorization successfull, returned token: \(token)")

                    //STRIP \n which is curiously appended to the end of token
                    success(token.substring(to: token.index(before: token.endIndex)))
                    break
                case .failure(let error):
                    log.error((error as NSError).description)
                    failure(error as NSError)
                    break
                }
            })
    }
    
    func getString(_ path: String, parameters: [String:String], headers: [String:String], success: @escaping (String)->()) {
        Alamofire
            .request(URL(string: "\(zmonEndpoint)\(path)")!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers)
            .responseString(completionHandler: { (response) -> Void in
                if case .success(let string) = response.result {
                    success(string)
                }
            })
    }
    
    func getObject<T: EVObject>(_ path: String, parameters: [String:String], headers: [String:String], success: @escaping (T)->()) {
        Alamofire
            .request(URL(string: "\(zmonEndpoint)\(path)")!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers)
            .validate()
            .responseObject { (response: DataResponse<T>) in
                if case .success(let object) = response.result {
                    success(object)
                }
                else {
                    log.error(response.debugDescription)
                }
                
        }
    }
    
    func getObjectList<T: EVObject>(_ path: String, parameters: [String:String], headers: [String:String], success: @escaping ([T])->()) {
        Alamofire
            .request(URL(string: "\(zmonEndpoint)\(path)")!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers)
            .responseArray { (response: DataResponse<[T]>) in
                if case .success(let array) = response.result {
                    success(array)
                }
        }
    }
    
    func getStringList(_ path: String, parameters: [String:String], headers: [String:String], success: @escaping ([String])->()) {
        Alamofire
            .request(URL(string: "\(zmonEndpoint)\(path)")!, method: .get, parameters: parameters, encoding: URLEncoding(), headers: headers)
            .responseJSON { (response) -> Void in
                if case .success(let object) = response.result {
                    success(object as! [String])
                }
        }
    }
    
    func postJson(_ path: String, parameters: [String:String], headers: [String:String], success: @escaping ()->(), failure: @escaping (NSError)->()) {
        Alamofire
            .request(URL(string: "\(zmonEndpoint)\(path)")!, method: .get, parameters: parameters, encoding: JSONEncoding(), headers: headers)
            .validate()
            .response { (response) -> Void in
                if let error = response.error as? NSError {
                    log.error(error.debugDescription)
                    failure(error)
                }
                else {
                    success()
                }
        }
    }
}
