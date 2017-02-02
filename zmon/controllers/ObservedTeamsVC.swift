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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching() ? self.filteredTeamList.count : self.teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let teamName = isSearching() ? self.filteredTeamList[indexPath.row] : self.teamList[indexPath.row]
        
        let cell: TeamCell = tableView.dequeueReusableCell(withIdentifier: "TeamCell") as! TeamCell
        cell.configureFor(teamName)
        
        if let team = Team.findByName(teamName) {
            if team.observed {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamName = isSearching() ? filteredTeamList[indexPath.row] : teamList[indexPath.row]
        let team: Team = Team(name: teamName, observed: true)
        team.save()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let teamName = isSearching() ? filteredTeamList[indexPath.row] : teamList[indexPath.row]
        let team: Team = Team(name: teamName, observed: false)
        team.save()
    }
    
    //MARK: Searching and UISearchResultsUpdating
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.tintColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterTeamsForSearchText(searchController.searchBar.text!)
    }
    
    func filterTeamsForSearchText(_ searchText: String, scope: String = "All") {
        filteredTeamList = teamList.filter { team in
            return team.lowercased().contains(searchText.lowercased())
        }
        
        table.reloadData()
    }
}
