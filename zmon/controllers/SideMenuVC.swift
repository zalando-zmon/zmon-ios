//
//  SideMenuVC.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var table: UITableView!
    
    weak var rootVC: RootVC?
    
    let menuItems : [[String:String]] = [
        ["name": "ZmonStatus".localized, "action": "showZmonStatus"],
        ["name": "ZmonDashboard".localized, "action": "showZmonDashboard"],
        ["name": "ObservedTeams".localized, "action": "showObservedTeams"]
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table.dataSource = self
        self.table.delegate = self
        self.table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let menuRecord: [String:String] = menuItems[indexPath.row]
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell")!
        cell.textLabel!.text = menuRecord["name"]!
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuRecord: [String:String] = menuItems[indexPath.row]

        if let action = menuRecord["action"] {
            if let rootVC = self.rootVC {
                
                let control: UIControl = UIControl()
                control.sendAction(Selector(action), to: rootVC.navigationVC, forEvent: nil)
                rootVC.hideSideMenu()
            }
        }
    }

    
}
