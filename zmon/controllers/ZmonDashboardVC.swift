//
//  ZmonDashboardVC.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class ZmonDashboardVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    let zmonAlertsService: ZmonAlertsService = ZmonAlertsService()
    var dataUpdatesTimer: NSTimer?
    var alertList: [ZmonAlertStatus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ZmonDashboard".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style:.Plain, target: self, action: "toggleDataUpdates")
        
        self.table.dataSource = self
        self.table.delegate = self
        
        self.updateZmonDashboard()
        self.startDataUpdates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopDataUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let alert: ZmonAlertStatus = self.alertList[indexPath.row]
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("AlertCell")!
        cell.textLabel!.text = alert.message;
        setBackgroundColor(cell: cell, priority: alert.alertDefinition?.priority ?? 0)
        
        return cell
    }
    
    private func setBackgroundColor(cell cell: UITableViewCell, priority: Int) {
        switch (priority) {
        case 1:
            cell.backgroundColor = ZmonColor.alertCritical
            break;
        case 2:
            cell.backgroundColor = ZmonColor.alertMedium
            break;
        default:
            cell.backgroundColor = ZmonColor.alertLow
            break;
        }
    }
    
    //MARK: - Data tasks
    func toggleDataUpdates() {
        if self.dataUpdatesTimer == nil {
            startDataUpdates()
            self.navigationItem.rightBarButtonItem!.title = "Pause"
        }
        else {
            stopDataUpdates()
            self.navigationItem.rightBarButtonItem!.title = "Start"
        }
    }
    
    private func startDataUpdates(){
        stopDataUpdates()
        log.debug("Starting ZMON Dashboard updates")
        self.dataUpdatesTimer = NSTimer.scheduledTimerWithTimeInterval(5.0,
            target: self,
            selector: "updateZmonDashboard",
            userInfo: nil,
            repeats: true)
    }
    
    private func stopDataUpdates(){
        if let timer = self.dataUpdatesTimer {
            log.debug("Stopping ZMON Dashboard updates")
            timer.invalidate()
            self.dataUpdatesTimer = nil
        }
    }
    
    func updateZmonDashboard() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let teamList: [String] = Team.allObservedTeamNames()
            self.zmonAlertsService.listByTeam(teamName: teamList.joinWithSeparator(","), success: { (alerts: [ZmonAlertStatus]) -> () in
                self.alertList = alerts
                self.alertList.sortInPlace({ (a: ZmonAlertStatus, b: ZmonAlertStatus) -> Bool in
                    return a.alertDefinition?.priority < b.alertDefinition?.priority
                })
                self.table.reloadData()
            })
        }
    }

}
