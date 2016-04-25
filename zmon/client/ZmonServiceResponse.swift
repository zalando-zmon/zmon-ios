//
//  ZmonServiceResponse.swift
//  zmon
//
//  Created by Wojciech Lukasz Czerski on 25/04/16.
//  Copyright © 2016 Zalando Tech. All rights reserved.
//

import Foundation

struct ZmonServiceResponse {
    
    struct Alert {
        let id: Int
        let name: String
        let team: String
        let responsibleTeam: String
    }
    
    static func parseAlertWithJsonNDictionary(jsonDictionary: NSDictionary) -> Alert? {
        
        guard let id = jsonDictionary.objectForKey("id") as? Int else {

            log.error("Failed to parse Alert JSON dictionary: missing Int value for 'id' key")
            return nil
        }

        guard let name = jsonDictionary.objectForKey("name") as? String else {

            log.error("Failed to parse Alert JSON dictionary: missing String value for 'name' key")
            return nil
        }

        guard let team = jsonDictionary.objectForKey("team") as? String else {

            log.error("Failed to parse Alert JSON dictionary: missing String value for 'team' key")
            return nil
        }

        guard let responsibleTeam = jsonDictionary.objectForKey("responsible_team") as? String else {

            log.error("Failed to parse Alert JSON dictionary: missing String value for 'responsible_team' key")
            return nil
        }
        
        return Alert(id: id, name: name, team: team, responsibleTeam: responsibleTeam)
    }
    
    static func parseAlertCollectionWithJSONArray(jsonArray: NSArray) -> [Alert] {
        
        var allAlerts = [Alert]()
        
        for jsonObject in jsonArray {
            
            guard let jsonDictionary = jsonObject as? NSDictionary else {
                
                log.error("Error while parsing Alert collection JSON: invalid object found where NSDictionary was expected")
                continue
            }
            
            guard let alert = parseAlertWithJsonNDictionary(jsonDictionary) else {
                continue
            }
            
            allAlerts.append(alert)
        }
        
        return allAlerts
    }

}
