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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTap))
    }

    func onAddButtonTap() {
        
        let remoteAlertsNavigationVC = storyboard?.instantiateViewController(withIdentifier: "RemoteAlertsNavigationVC") as! UINavigationController
        let remoteAlertsVC = remoteAlertsNavigationVC.topViewController as! RemoteAlertsVC
        
        remoteAlertsVC.observedAlerts = observedAlerts
        remoteAlertsVC.remoteAlerts = remoteAlerts
        
        remoteAlertsVC.completionCallback = { observedAlerts in

            self.observedAlerts = observedAlerts
            self.tableView.reloadData()
            
            remoteAlertsNavigationVC.dismiss(animated: true, completion: nil)
        }
        
        present(remoteAlertsNavigationVC, animated: true, completion: nil)
    }
}

extension ObservedAlertsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observedAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCell", for: indexPath)
        let alert = observedAlerts[indexPath.row];

        cell.textLabel?.text = alert.name
        cell.detailTextLabel?.text = "\(alert.id), \(alert.team)"
        
        return cell
    }
}

extension ObservedAlertsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = observedAlerts[indexPath.row];
        
        SVProgressHUD.show()
        
        alertService.unsubscribeFromAlertWithID("\(alert.id)", success: {
            
            self.observedAlerts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            SVProgressHUD.dismiss()
            
        }) { (error) in
            
            SVProgressHUD.dismiss()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "AlertUnsubscribe".localized
    }
}
