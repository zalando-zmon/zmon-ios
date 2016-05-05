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
    
    var completionCallback: ((observedAlerts: [ZmonServiceResponse.Alert]) -> ())?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "RemoteAlerts".localized
        
        setupSearch()
    }

    @IBAction func onDoneButtonTap(sender: UIBarButtonItem) {
        completionCallback?(observedAlerts: observedAlerts)
    }

    func subscribeToAlert(alert: ZmonServiceResponse.Alert, indexPath: NSIndexPath) {
        
        SVProgressHUD.show()
        
        alertService.subscribeToAlertWithID("\(alert.id)", success: {
            
            self.observedAlerts.append(alert)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
        }
    }
    
    func unsubscribeFromAlert(alert: ZmonServiceResponse.Alert, indexPath: NSIndexPath) {
        
        SVProgressHUD.show()
        
        alertService.unsubscribeFromAlertWithID("\(alert.id)", success: {
            
            self.removeObservedAlert(alert)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
        }
    }

    func isAlertObserved(alert: ZmonServiceResponse.Alert) -> Bool {
        
        let index = observedAlerts.indexOf { (observedAlert) -> Bool in
            return alert.id == observedAlert.id
        }
        
        return index != nil
    }
    
    func removeObservedAlert(alert: ZmonServiceResponse.Alert) {
        
        let index = observedAlerts.indexOf { (alert) -> Bool in
            return alert.id == alert.id
        }
        
        guard let existingIndex = index else {
            log.warning("Could not remove observed alert - the alert with id = \(alert.id) does not exist")
            return
        }
        
        observedAlerts.removeAtIndex(existingIndex)
    }
    
    func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .Black
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func isSearching() -> Bool {
        return searchController.active && searchController.searchBar.text != ""
    }

    func filterRemoteAlertsForSearchText(searchText: String, scope: String = "All") {

        filteredRemoteAlerts = remoteAlerts.filter { alert in
            
            let nameMatches = alert.name.lowercaseString.containsString(searchText.lowercaseString)
            let teamMatches = alert.team.lowercaseString.containsString(searchText.lowercaseString)
            let idMatches = String(alert.id).hasPrefix(searchText)
            
            return nameMatches || teamMatches || idMatches
        }
        
        tableView.reloadData()
    }
}

extension RemoteAlertsVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching() ? filteredRemoteAlerts.count : remoteAlerts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath)
        let alert = isSearching() ? filteredRemoteAlerts[indexPath.row] : remoteAlerts[indexPath.row];
        
        cell.accessoryType = isAlertObserved(alert) ? .Checkmark : .None
        cell.textLabel?.text = alert.name
        cell.detailTextLabel?.text = "\(alert.id), \(alert.team)"
        
        return cell
    }
}

extension RemoteAlertsVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = isSearching() ? filteredRemoteAlerts[indexPath.row] : remoteAlerts[indexPath.row];
        
        if (isAlertObserved(alert)) {
            unsubscribeFromAlert(alert, indexPath: indexPath)
            
        } else {
            subscribeToAlert(alert, indexPath: indexPath)
        }
    }
}

extension RemoteAlertsVC: UISearchResultsUpdating {

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            filterRemoteAlertsForSearchText(searchText)
        }
    }
}
