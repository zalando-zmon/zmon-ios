//
//  ObservedAlertsVC.swift
//  zmon
//
//  Created by Wojciech Lukasz Czerski on 22/04/16.
//  Copyright © 2016 Zalando Tech. All rights reserved.
//

import UIKit
import SVProgressHUD

class ObservedAlertsVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    let alertService = ZmonAlertsService()
    var observedAlerts: [ZmonServiceResponse.Alert] = []
    var remoteAlerts: [ZmonServiceResponse.Alert] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureTableView()
    }
    
    func fetchRemoteAlerts() {
        
        SVProgressHUD.show()
        
        alertService.listRemoteObservableAlertsWithCompletion { alerts in
            
            if let alerts = alerts {
                
                log.info("Successfully fetched \(alerts.count) alerts!")
                
                self.remoteAlerts = alerts
                self.fetchUserObservedAlerts()
                
            } else {
                
                SVProgressHUD.dismiss()
                log.error("Failed to fetch remote alerts")
            }
        }
    }
    
    func fetchUserObservedAlerts() {
        
        alertService.listUserObservedAlertsWithCompletion { alertIDs in
            
            SVProgressHUD.dismiss()
            
            if let alertIDs = alertIDs {
                
                log.info("Successfully fetched user observed alerts (\(alertIDs.count))")

                self.observedAlerts = self.remoteAlerts.filter({ (alert) -> Bool in
                    return alertIDs.contains(alert.id)
                })
                
                self.tableView.reloadData()
                
            } else {
                log.error("Failed to fetch user observed alerts")
            }
        }
    }
    
    func configureTableView() {
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func configureNavigationItem() {
        navigationItem.title = "ObservedAlerts".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(onAddButtonTap))
    }

    func onAddButtonTap() {
        
        let remoteAlertsNavigationVC = storyboard?.instantiateViewControllerWithIdentifier("RemoteAlertsNavigationVC") as! UINavigationController
        let remoteAlertsVC = remoteAlertsNavigationVC.topViewController as! RemoteAlertsVC
        
        remoteAlertsVC.observedAlerts = observedAlerts
        remoteAlertsVC.remoteAlerts = remoteAlerts
        
        remoteAlertsVC.completionCallback = { observedAlerts in

            self.observedAlerts = observedAlerts
            self.tableView.reloadData()
            
            remoteAlertsNavigationVC.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(remoteAlertsNavigationVC, animated: true, completion: nil)
    }
}

extension ObservedAlertsVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observedAlerts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath)
        let alert = observedAlerts[indexPath.row];

        cell.textLabel?.text = alert.name
        cell.detailTextLabel?.text = "\(alert.id), \(alert.team)"
        
        return cell
    }
}

extension ObservedAlertsVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = observedAlerts[indexPath.row];
        
        alertService.unsubscribeFromAlertWithID("\(alert.id)", success: {
            
            self.observedAlerts.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }) { (error) in
            
        }
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "AlertUnsubscribe".localized
    }
}
