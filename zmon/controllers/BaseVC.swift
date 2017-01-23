//
//  BaseVC.swift
//  zmon
//
//  Created by Andrej Kincel on 16/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    weak var rootVC: RootVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootVC = self.rootVC {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_white"), style:.plain, target: rootVC, action: #selector(RootVC.toggleSideMenu))
        }
    }
}
