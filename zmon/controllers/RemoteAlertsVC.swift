//
//  RemoteAlertsVC.swift
//  zmon
//
//  Created by Wojciech Lukasz Czerski on 25/04/16.
//  Copyright © 2016 Zalando Tech. All rights reserved.
//

import Foundation

class RemoteAlertsVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    let alertService = ZmonAlertsService()
    var remoteAlerts: [ZmonServiceResponse.Alert] = []
    var observedAlerts: [ZmonServiceResponse.Alert] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.title = "RemoteAlerts".localized
    }

    @IBAction func onDoneButtonTap(sender: UIBarButtonItem) {

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchRemoteAlerts() {

        alertService.listRemoteObservableAlertsWithCompletion { alerts in

            if let alerts = alerts {
                
                log.info("Successfully fetched \(alerts.count) alerts!")
                
                self.remoteAlerts = alerts
                self.tableView.reloadData()
                
            } else {
                log.error("Failed to fetch remote alerts")
            }
        }
    }
    
    func subscribeToAlert(alert: ZmonServiceResponse.Alert, indexPath: NSIndexPath) {
        
        alertService.subscribeToAlertWithID("\(alert.id)", success: {
            
            self.observedAlerts.append(alert)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }) { (error) in
            
        }
    }
    
    func unsubscribeFromAlert(alert: ZmonServiceResponse.Alert, indexPath: NSIndexPath) {
        
        alertService.unsubscribeFromAlertWithID("\(alert.id)", success: {
            
            self.removeObservedAlert(alert)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }) { (error) in
            
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
}

extension RemoteAlertsVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remoteAlerts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath)
        let alert = remoteAlerts[indexPath.row];
        
        cell.accessoryType = isAlertObserved(alert) ? .Checkmark : .None
        cell.textLabel?.text = alert.name
        cell.detailTextLabel?.text = "\(alert.id), \(alert.team)"
        
        return cell
    }
}

extension RemoteAlertsVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = remoteAlerts[indexPath.row];
        
        if (isAlertObserved(alert)) {
            unsubscribeFromAlert(alert, indexPath: indexPath)
            
        } else {
            subscribeToAlert(alert, indexPath: indexPath)
        }
    }
}
