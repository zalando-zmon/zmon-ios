//
//  ObservedTeamsVC.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class ObservedTeamsVC: BaseVC, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    let zmonTeamService: ZmonTeamService = ZmonTeamService()
    var teamList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ObservedTeams".localized
        
        self.table.dataSource = self
        self.table.delegate = self
        
        zmonTeamService.listTeams { (teams: [String]) -> () in
            self.teamList = teams
            self.table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teamList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let teamName = self.teamList[indexPath.row]
        
        let cell: TeamCell = tableView.dequeueReusableCellWithIdentifier("TeamCell") as! TeamCell
        cell.configureFor(name: teamName)
        
        if let team = Team.findByName(name: teamName) {
            if team.observed {
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        }
        
        return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let teamName = self.teamList[indexPath.row]
        let team: Team = Team(name: teamName, observed: true)
        team.save()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let teamName = self.teamList[indexPath.row]
        let team: Team = Team(name: teamName, observed: false)
        team.save()
    }
}
