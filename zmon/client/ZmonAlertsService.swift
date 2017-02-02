//
//  ZmonAlertsService.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import Alamofire

class ZmonAlertsService: NSObject {

    func list(_ success: @escaping ([ZmonAlertStatus]) -> ()) {
        ZmonService.sharedInstance.getObjectList("/active-alerts", parameters: [:], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }
    
    func listByTeam(_ teamName: String, success: @escaping ([ZmonAlertStatus]) -> ()) {
        log.debug("Listing alerts for teams with query ?team=\(teamName)")
        ZmonService.sharedInstance.getObjectList("/active-alerts", parameters: ["team": teamName], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }
    
    func listRemoteObservableAlertsWithCompletion(_ completion: @escaping (_ alerts: [ZmonServiceResponse.Alert]?) -> ()) {
        
        let url = URL(string: "https://notification-service.zmon.zalan.do/api/v1/mobile/alert")!
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()

        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding(), headers: headers).responseJSON { response in
            
            guard let rootJsonObject = response.result.value else {
                log.error("Failed to fetch remote observable alerts with error: \(response.result.error)")
                completion(nil)
                return
            }
            
            guard let jsonArray = rootJsonObject as? NSArray else {
                log.error("Error while parsing remote alerts data: invalid JSON object found where NSArray was expected")
                completion(nil)
                return
            }
            
            let parsedAlerts = ZmonServiceResponse.parseAlertCollectionWithJSONArray(jsonArray)
            completion(parsedAlerts)
        }
    }
    
    func listUserObservedAlertsWithCompletion(_ completion: @escaping (_ alertIDs: [Int]?) -> ()) {
        
        let url = URL(string: "https://notification-service.zmon.zalan.do/api/v1/user/subscriptions")!
        
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding(), headers: headers).responseString { response in
            
            if let responseString = response.result.value {
                
                // The response is in format of "[123,456,789,...]"

                let skipChars = NSMutableCharacterSet(charactersIn: "[],")
                skipChars.formUnion(with: NSCharacterSet.whitespacesAndNewlines)

                let scanner = Scanner(string: responseString)
                scanner.charactersToBeSkipped = skipChars as CharacterSet
                
                var result: [Int] = []
                var scannedID:Int = 0
                
                while scanner.scanInt(&scannedID) {
                    result.append(scannedID)
                }
                
                completion(result)

            } else {
                log.error("Failed to list user observed alerts with error: \(response.result.error?.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func registerDevice(_ deviceSubscription: DeviceSubscription, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        let parameters: [String:String] = deviceSubscription.toDictionary() as! [String:String]
        
        ZmonService.sharedInstance.postJson("/device", parameters: parameters, headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success, failure: failure)
    }
    
    func registerDeviceWithToken(_ token: String, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        
        // TODO: We cannot use the ZmonSerivce class as it uses /mobile endpoint for all calls. This is why the path is explicit. Better solution needed...
        
        let url = URL(string: "https://notification-service.zmon.zalan.do/api/v1/device")!
        
        Alamofire
            .request(url, method: .post, parameters: ["registration_token":token], encoding: JSONEncoding(), headers: CredentialsStore.sharedInstance.accessTokenHeader())
            .validate()
            .response { (responseData) -> Void in
                if let error = responseData.error as? NSError {
                    log.error(responseData.response.debugDescription)
                    failure(error)
                } else {
                    success()
                }
        }
    }
    
    func subscribeToAlertWithID(_ alertID: String, success: @escaping ()->(), failure: @escaping (NSError)->()) {
        
        let url = URL(string: "https://notification-service.zmon.zalan.do/api/v1/subscription")!
        let parameters = ["alert_id":alertID]
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()
        
        Alamofire
            .request(url, method: .post, parameters: parameters, encoding: JSONEncoding(), headers: headers)
            .validate()
            .response { (responseData) -> Void in
                if let error = responseData.error as? NSError {
                    log.error(responseData.response.debugDescription)
                    failure(error)
                } else {
                    success()
                }
        }
    }
    
    func unsubscribeFromAlertWithID(_ alertID: String, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        
        let url = URL(string: "https://notification-service.zmon.zalan.do/api/v1/subscription/\(alertID)")!
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()

        Alamofire
            .request(url, method: .delete, parameters: [:], encoding: URLEncoding(), headers: headers)
            .validate()
            .response { (responseData) -> Void in
                if let error = responseData.error as? NSError {
                    log.error(responseData.response.debugDescription)
                    failure(error)
                } else {
                    success()
                }
        }
    }
}
