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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
        cell.textLabel?.text = alert.name
        
        return cell
    }
}
