//
//  ZmonDashboardVC.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ZmonDashboardVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    let zmonAlertsService: ZmonAlertsService = ZmonAlertsService()
    var dataUpdatesTimer: Timer?
    var alertList: [ZmonAlertStatus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ZmonDashboard".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style:.plain, target: self, action: #selector(ZmonDashboardVC.toggleDataUpdates))
        
        self.table.dataSource = self
        self.table.delegate = self
        
        self.updateZmonDashboard()
        self.startDataUpdates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopDataUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alert: ZmonAlertStatus = self.alertList[indexPath.row]
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlertCell")!
        cell.textLabel!.text = alert.message;
        setBackgroundColor(cell, priority: alert.alertDefinition?.priority ?? 0)
        
        return cell
    }
    
    fileprivate func setBackgroundColor(_ cell: UITableViewCell, priority: Int) {
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
    
    fileprivate func startDataUpdates(){
        stopDataUpdates()
        log.debug("Starting ZMON Dashboard updates")
        self.dataUpdatesTimer = Timer.scheduledTimer(timeInterval: 5.0,
            target: self,
            selector: #selector(ZmonDashboardVC.updateZmonDashboard),
            userInfo: nil,
            repeats: true)
    }
    
    fileprivate func stopDataUpdates(){
        if let timer = self.dataUpdatesTimer {
            log.debug("Stopping ZMON Dashboard updates")
            timer.invalidate()
            self.dataUpdatesTimer = nil
        }
    }
    
    func updateZmonDashboard() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let teamList: [String] = Team.allObservedTeamNames()
            self.zmonAlertsService.listByTeam(teamList.joined(separator: ","), success: { (alerts: [ZmonAlertStatus]) -> () in
                self.alertList = alerts
                self.alertList.sort(by: { (a: ZmonAlertStatus, b: ZmonAlertStatus) -> Bool in
                    return a.alertDefinition?.priority < b.alertDefinition?.priority
                })
                self.table.reloadData()
            })
        }
    }

}
