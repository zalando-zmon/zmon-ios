//
//  Team.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import Foundation

class Team: NSObject {
    
    //Temporary storage
    private static var teamList: [Team] = []
    
    //MARK: Properties
    var name: String
    var observed: Bool
    
    //MARK: Initialization
    init(name: String, observed: Bool) {
        self.name = name
        self.observed = observed
    }
    
    func save() {
        let idx = Team.teamList.indexOf { (team: Team) -> Bool in
            return team.name == self.name
        }
        
        if (idx == nil) {
            Team.teamList.append(self)
        }
    }
    
    static func findByName(name name: String) -> Team? {
        let idx = Team.teamList.indexOf { (team: Team) -> Bool in
            return team.name == name
        }
        
        if (idx != nil) {
            return Team.teamList[idx!]
        }
        else {
            return nil
        }
    }
    
    static func allObservedTeamNames() -> [String] {
        return Team.teamList
            .filter({ (team: Team) -> Bool in
                return (team.observed) ? true: false
            })
            .map({ (team: Team) -> String in
                return team.name
            })
    }
}
