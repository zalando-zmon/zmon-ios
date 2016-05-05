//
//  ObservedTeamsVC.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit
import SVProgressHUD

class ObservedTeamsVC: BaseVC, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var table: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    let zmonTeamService: ZmonTeamService = ZmonTeamService()
    var teamList: [String] = []
    var filteredTeamList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ObservedTeams".localized
        self.setupSearch()
        
        self.table.dataSource = self
        self.table.delegate = self
        
        SVProgressHUD.show()
        zmonTeamService.listTeams { (teams: [String]) -> () in
            SVProgressHUD.dismiss()
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
        return isSearching() ? self.filteredTeamList.count : self.teamList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let teamName = isSearching() ? self.filteredTeamList[indexPath.row] : self.teamList[indexPath.row]
        
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
        let teamName = isSearching() ? filteredTeamList[indexPath.row] : teamList[indexPath.row]
        let team: Team = Team(name: teamName, observed: true)
        team.save()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let teamName = isSearching() ? filteredTeamList[indexPath.row] : teamList[indexPath.row]
        let team: Team = Team(name: teamName, observed: false)
        team.save()
    }
    
    //MARK: Searching and UISearchResultsUpdating
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .Black
        searchController.searchBar.keyboardAppearance = .Dark
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
    }
    
    func isSearching() -> Bool {
        return searchController.active && searchController.searchBar.text != ""
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterTeamsForSearchText(searchController.searchBar.text!)
    }
    
    func filterTeamsForSearchText(searchText: String, scope: String = "All") {
        filteredTeamList = teamList.filter { team in
            return team.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        table.reloadData()
    }
}
