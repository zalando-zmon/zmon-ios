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
    
    fileprivate static var teamList: [Team] = {
        //If teamList was previously persisted on disk, fetch it, otherwise return an empty array
        let defaults = UserDefaults.standard
        let teamListData = defaults.object(forKey: Team.teamListPropertyName)
        if teamListData != nil {
            let teamList = NSKeyedUnarchiver.unarchiveObject(with: teamListData as! Data)
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
        let observed = decoder.decodeBool(forKey: Team.observedPropertyName)
        guard let name = decoder.decodeObject(forKey: Team.namePropertyName) as? String
            else {
                return nil;
        }
        self.init(name: name, observed: observed)
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey:Team.namePropertyName)
        coder.encode(self.observed, forKey: Team.observedPropertyName)
    }
    
    
    func save() {
        let idx = Team.teamList.index { (team: Team) -> Bool in
            return team.name == self.name
        }
        
        if (idx == nil) {
            Team.teamList.append(self)
        }
        else {
            Team.teamList.remove(at: idx!)
            Team.teamList.append(self)
        }
        
        self.persistObservedTeams()
    }
    
    func persistObservedTeams() {
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: Team.teamList)
        
        defaults.set(data, forKey: Team.teamListPropertyName);
    }
    
    static func findByName(_ name: String) -> Team? {
        let idx = Team.teamList.index { (team: Team) -> Bool in
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
