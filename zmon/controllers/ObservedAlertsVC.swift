//
//  ObservedAlertsVC.swift
//  zmon
//
//  Created by Wojciech Lukasz Czerski on 22/04/16.
//  Copyright © 2016 Zalando Tech. All rights reserved.
//

import UIKit

class ObservedAlertsVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    let alertService = ZmonAlertsService()
    var observedAlertIDs: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    func fetchUserObservedAlerts() {
        
        alertService.listUserObservedAlertsWithCompletion { alerts in
            
            if let alerts = alerts {
                
                log.info("Successfully fetched user observed alerts (\(alerts.count))")
                self.observedAlertIDs = alerts
                self.tableView.reloadData()
                
            } else {
                log.error("Failed to fetch user observed alerts")
            }
        }
    }
    
    func configureNavigationItem() {
        navigationItem.title = "ObservedAlerts".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(onAddButtonTap))
    }

    func onAddButtonTap() {
        
        let remoteAlertsNavigationVC = storyboard?.instantiateViewControllerWithIdentifier("RemoteAlertsNavigationVC") as! UINavigationController
        let remoteAlertsVC = remoteAlertsNavigationVC.topViewController as! RemoteAlertsVC
        
        remoteAlertsVC.fetchRemoteAlerts()
        
        presentViewController(remoteAlertsNavigationVC, animated: true, completion: nil)
    }
}

extension ObservedAlertsVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observedAlertIDs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath)
        let alert = observedAlertIDs[indexPath.row];
        
        cell.textLabel?.text = "\(alert)"
        
        return cell
    }
}
