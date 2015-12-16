//
//  NavigationVC.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let zmonStatusVC: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ZmonStatusVC")
        self.setViewControllers([zmonStatusVC], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
