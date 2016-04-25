//
//  ZmonAlertsService.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import Alamofire

class ZmonAlertsService: NSObject {

    func list(success success: ([ZmonAlertStatus]) -> ()) {
        ZmonService.sharedInstance.getObjectList(path: "/active-alerts", parameters: [:], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }
    
    func listByTeam(teamName teamName: String, success: ([ZmonAlertStatus]) -> ()) {
        log.debug("Listing alerts for teams with query ?team=\(teamName)")
        ZmonService.sharedInstance.getObjectList(path: "/active-alerts", parameters: ["team": teamName], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }
    
    func listRemoteObservableAlertsWithCompletion(completion: (alerts: [ZmonServiceResponse.Alert]?) -> ()) {
        
        let path = "https://zmon-notification-service.stups.zalan.do/api/v1/mobile/alert"
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()
        
        Alamofire.request(.GET, path, parameters: [:], encoding: .URL, headers: headers).responseJSON { response in
            
            guard let rootJsonObject = response.result.value else {
                log.error("Failed to fetch remote observable alerts with error: \(response.result.error)")
                completion(alerts: nil)
                return
            }
            
            guard let jsonArray = rootJsonObject as? NSArray else {
                log.error("Error while parsing remote alerts data: invalid JSON object found where NSArray was expected")
                completion(alerts: nil)
                return
            }
            
            let parsedAlerts = ZmonServiceResponse.parseAlertCollectionWithJSONArray(jsonArray)
            completion(alerts: parsedAlerts)
        }
    }
    
    func registerDevice(deviceSubscription deviceSubscription: DeviceSubscription, success: () -> (), failure: (NSError) -> ()) {
        let parameters: [String:String] = deviceSubscription.toDictionary() as! [String:String]
        
        ZmonService.sharedInstance.postJson(path: "/device", parameters: parameters, headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success, failure: failure)
    }
    
    func registerDeviceWithToken(token: String, success: () -> (), failure: (NSError) -> ()) {
        
        // TODO: We cannot use the ZmonSerivce class as it uses /mobile endpoint for all calls. This is why the path is explicit. Better solution needed...
        
        let path = "https://zmon-notification-service.stups.zalan.do/api/v1/device"
        
        Alamofire
            .request(.POST, path, parameters: ["registration_token":token], encoding: .JSON, headers: CredentialsStore.sharedInstance.accessTokenHeader())
            .validate()
            .response { (request, response, data, error) -> Void in
                if error == nil {
                    success()
                }
                else {
                    log.error(response.debugDescription)
                    failure(error!)
                }
        }
    }
    
    func subscribeToAlertWithID(alertID: String, success: ()->(), failure: (NSError)->()) {
        
        let path = "https://zmon-notification-service.stups.zalan.do/api/v1/subscription"
        let parameters = ["alert_id":alertID]
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()
        
        Alamofire
            .request(.POST, path, parameters: parameters, encoding: .JSON, headers: headers)
            .validate()
            .response { (request, response, data, error) -> Void in
                if error == nil {
                    success()
                }
                else {
                    log.error(response.debugDescription)
                    failure(error!)
                }
        }
    }
    
    func unsubscribeFromAlertWithID(alertID: String, success: () -> (), failure: (NSError) -> ()) {
        
        let path = "https://zmon-notification-service.stups.zalan.do/api/v1/subscription/\(alertID)"
        let headers = CredentialsStore.sharedInstance.accessTokenHeader()

        Alamofire
            .request(.DELETE, path, parameters: [:], encoding: .URL, headers: headers)
            .validate()
            .response { (request, response, data, error) -> Void in
                if error == nil {
                    success()
                }
                else {
                    log.error(response.debugDescription)
                    failure(error!)
                }
        }
    }
}
