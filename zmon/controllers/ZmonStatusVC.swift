//
//  ZmonStatusVC.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class ZmonStatusVC: BaseVC {
    
    // MARK: - Properties
    @IBOutlet weak var queueLabel: UILabel!
    @IBOutlet weak var workersLabel: UILabel!

    let zmonStatusService: ZmonStatusService = ZmonStatusService()
    var dataUpdatesTimer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ZmonStatus".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style:.plain, target: self, action: #selector(ZmonStatusVC.toggleDataUpdates))
        
        self.updateZmonStatus()
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
        log.debug("Starting ZMON Status updates")
        self.dataUpdatesTimer = Timer.scheduledTimer(timeInterval: 2.0,
            target: self,
            selector: #selector(ZmonStatusVC.updateZmonStatus),
            userInfo: nil,
            repeats: true)
    }
    
    fileprivate func stopDataUpdates(){
        if let timer = self.dataUpdatesTimer {
            log.debug("Stopping ZMON Status updates")
            timer.invalidate()
            self.dataUpdatesTimer = nil
        }
    }
    
    func updateZmonStatus() {
        DispatchQueue.global().async {
            self.zmonStatusService.status({ (zmonStatus: ZmonStatus) -> () in
                let queueText = "\(zmonStatus.queueSize) \("InQueue".localized)"
                if (zmonStatus.queueSize > 1000) {
                    self.queueLabel.attributedText = queueText.setColor(String(zmonStatus.queueSize), color: UIColor.red)
                }
                else {
                    self.queueLabel.attributedText = queueText.setColor(String(zmonStatus.queueSize), color: UIColor.green)
                }
                
                let workers = "\(zmonStatus.workersActive)/\(zmonStatus.workersTotal)"
                let workersText = "\(workers) \("ActiveWorkers".localized)"
                if (zmonStatus.workersActive < zmonStatus.workersTotal) {
                    self.workersLabel.attributedText = workersText.setColor(workers, color: UIColor.red)
                }
                else {
                    self.workersLabel.attributedText = workersText.setColor(workers, color: UIColor.green)
                }
            })
        }
    }
    
}
