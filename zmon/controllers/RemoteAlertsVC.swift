//
//  RemoteAlertsVC.swift
//  zmon
//
//  Created by Wojciech Lukasz Czerski on 25/04/16.
//  Copyright © 2016 Zalando Tech. All rights reserved.
//

import Foundation
import SVProgressHUD

class RemoteAlertsVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let alertService = ZmonAlertsService()
    var remoteAlerts: [ZmonServiceResponse.Alert] = []
    var filteredRemoteAlerts: [ZmonServiceResponse.Alert] = []
    var observedAlerts: [ZmonServiceResponse.Alert] = []
    
    var completionCallback: ((_ observedAlerts: [ZmonServiceResponse.Alert]) -> ())?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "RemoteAlerts".localized
        
        setupSearch()
    }

    @IBAction func onDoneButtonTap(_ sender: UIBarButtonItem) {
        completionCallback?(observedAlerts)
    }

    func subscribeToAlert(_ alert: ZmonServiceResponse.Alert, indexPath: IndexPath) {
        
        SVProgressHUD.show()
        
        alertService.subscribeToAlertWithID("\(alert.id)", success: {
            
            self.observedAlerts.append(alert)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
        }
    }
    
    func unsubscribeFromAlert(_ alert: ZmonServiceResponse.Alert, indexPath: IndexPath) {
        
        SVProgressHUD.show()
        
        alertService.unsubscribeFromAlertWithID("\(alert.id)", success: {
            
            self.removeObservedAlert(alert)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
        }
    }

    func isAlertObserved(_ alert: ZmonServiceResponse.Alert) -> Bool {
        
        let index = observedAlerts.index { (observedAlert) -> Bool in
            return alert.id == observedAlert.id
        }
        
        return index != nil
    }
    
    func removeObservedAlert(_ alert: ZmonServiceResponse.Alert) {
        
        let index = observedAlerts.index { (observedAlert) -> Bool in
            return alert.id == observedAlert.id
        }
        
        guard let existingIndex = index else {
            log.warning("Could not remove observed alert - the alert with id = \(alert.id) does not exist")
            return
        }
        
        observedAlerts.remove(at: existingIndex)
    }
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.tintColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func isSearching() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }

    func filterRemoteAlertsForSearchText(_ searchText: String, scope: String = "All") {

        filteredRemoteAlerts = remoteAlerts.filter { alert in
            
            let nameMatches = alert.name.lowercased().contains(searchText.lowercased())
            let teamMatches = alert.team.lowercased().contains(searchText.lowercased())
            let idMatches = String(alert.id).hasPrefix(searchText)
            
            return nameMatches || teamMatches || idMatches
        }
        
        tableView.reloadData()
    }
}

extension RemoteAlertsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching() ? filteredRemoteAlerts.count : remoteAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath)
        let alert = isSearching() ? filteredRemoteAlerts[indexPath.row] : remoteAlerts[indexPath.row];
        
        cell.accessoryType = isAlertObserved(alert) ? .checkmark : .none
        cell.textLabel?.text = alert.name
        cell.detailTextLabel?.text = "\(alert.id), \(alert.team)"
        
        return cell
    }
}

extension RemoteAlertsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = isSearching() ? filteredRemoteAlerts[indexPath.row] : remoteAlerts[indexPath.row];
        
        if (isAlertObserved(alert)) {
            unsubscribeFromAlert(alert, indexPath: indexPath)
            
        } else {
            subscribeToAlert(alert, indexPath: indexPath)
        }
    }
}

extension RemoteAlertsVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterRemoteAlertsForSearchText(searchText)
        }
    }
}
