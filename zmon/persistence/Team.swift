//
//  Team.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import Foundation

class Team: NSObject, NSCoding {
    
    //MARK: Persistence names
    static let teamListPropertyName = "zmon.team.teamList"
    static let namePropertyName = "zmon.team.name"
    static let observedPropertyName = "zmon.team.observed"
    
    private static var teamList: [Team] = {
        //If teamList was previously persisted on disk, fetch it, otherwise return an empty array
        let defaults = NSUserDefaults.standardUserDefaults()
        let teamListData = defaults.objectForKey(Team.teamListPropertyName)
        if teamListData != nil {
            let teamList = NSKeyedUnarchiver.unarchiveObjectWithData(teamListData as! NSData)
            return teamList as!  [Team]
        }
        
        return []
        
    }()
    
    //MARK: Properties
    var name: String
    var observed: Bool
    
    //MARK: Initialization
    init(name: String, observed: Bool) {
        self.name = name
        self.observed = observed
    }
    
    //MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        let observed = decoder.decodeBoolForKey(Team.observedPropertyName)
        guard let name = decoder.decodeObjectForKey(Team.namePropertyName) as? String
            else {
                return nil;
        }
        self.init(name: name, observed: observed)
    }
    
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey:Team.namePropertyName)
        coder.encodeBool(self.observed, forKey: Team.observedPropertyName)
    }
    
    
    func save() {
        let idx = Team.teamList.indexOf { (team: Team) -> Bool in
            return team.name == self.name
        }
        
        if (idx == nil) {
            Team.teamList.append(self)
        }
        else {
            Team.teamList.removeAtIndex(idx!)
            Team.teamList.append(self)
        }
        
        self.persistObservedTeams()
    }
    
    func persistObservedTeams() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(Team.teamList)
        
        defaults.setObject(data, forKey: Team.teamListPropertyName);
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
