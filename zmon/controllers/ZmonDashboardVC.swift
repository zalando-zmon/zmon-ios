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
    var alertList: [ZmonAlertStatus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ZmonDashboard".localized
        
        self.table.dataSource = self
        self.table.delegate = self
        
    
        let teamList: [String] = Team.allObservedTeamNames()
        zmonAlertsService.listByTeam(teamName: teamList.joinWithSeparator(","), success: { (alerts: [ZmonAlertStatus]) -> () in
            self.alertList = alerts
            self.alertList.sortInPlace({ (a: ZmonAlertStatus, b: ZmonAlertStatus) -> Bool in
                return a.alertDefinition?.priority < b.alertDefinition?.priority
            })
            self.table.reloadData()
        })
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
            cell.backgroundColor = UIColor.redColor()
            break;
        case 2:
            cell.backgroundColor = UIColor.orangeColor()
            break;
        default:
            cell.backgroundColor = UIColor.yellowColor()
            break;
        }
    }

}
