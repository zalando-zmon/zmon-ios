//
//  ZmonTeamService.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

class ZmonTeamService: NSObject {
    
    func listTeams(_ success: @escaping ([String])->()) {
        ZmonService.sharedInstance.getStringList("/all-teams", parameters: [:], headers: CredentialsStore.sharedInstance.accessTokenHeader(), success: success)
    }

}
