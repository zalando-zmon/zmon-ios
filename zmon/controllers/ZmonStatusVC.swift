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
    var dataUpdatesTimer: NSTimer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ZmonStatus".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pause", style:.Plain, target: self, action: "toggleDataUpdates")
        
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
        log.debug("Starting ZMON Status updates")
        self.dataUpdatesTimer = NSTimer.scheduledTimerWithTimeInterval(2.0,
            target: self,
            selector: "updateZmonStatus",
            userInfo: nil,
            repeats: true)
    }
    
    private func stopDataUpdates(){
        if let timer = self.dataUpdatesTimer {
            log.debug("Stopping ZMON Status updates")
            timer.invalidate()
            self.dataUpdatesTimer = nil
        }
    }
    
    func updateZmonStatus() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.zmonStatusService.status(success: { (zmonStatus: ZmonStatus) -> () in
                let queueText = "\(zmonStatus.queueSize) \("InQueue".localized)"
                if (zmonStatus.queueSize > 1000) {
                    self.queueLabel.attributedText = queueText.setColor(stringPart: String(zmonStatus.queueSize), color: UIColor.redColor())
                }
                else {
                    self.queueLabel.attributedText = queueText.setColor(stringPart: String(zmonStatus.queueSize), color: UIColor.greenColor())
                }
                
                let workers = "\(zmonStatus.workersActive)/\(zmonStatus.workersTotal)"
                let workersText = "\(workers) \("ActiveWorkers".localized)"
                if (zmonStatus.workersActive < zmonStatus.workersTotal) {
                    self.workersLabel.attributedText = workersText.setColor(stringPart: workers, color: UIColor.redColor())
                }
                else {
                    self.workersLabel.attributedText = workersText.setColor(stringPart: workers, color: UIColor.greenColor())
                }
            })
        }
    }
    
}
