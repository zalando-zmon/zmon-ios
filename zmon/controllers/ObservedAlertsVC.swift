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
    var observedAlerts: [ZmonServiceResponse.Alert] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
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
        return observedAlerts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath)
        let alert = observedAlerts[indexPath.row];
        
        cell.textLabel?.text = alert.name
        
        return cell
    }
}
