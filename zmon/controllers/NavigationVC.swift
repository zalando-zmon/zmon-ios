//
//  NavigationVC.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    weak var rootVC: RootVC?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = ZmonColor.textPrimary
        
        showZmonStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    func showZmonStatus() {
        if let zmonStatusVC: BaseVC = self.storyboard!.instantiateViewControllerWithIdentifier("ZmonStatusVC") as? BaseVC {
            zmonStatusVC.rootVC = self.rootVC
            self.setViewControllers([zmonStatusVC], animated: true)
        }
    }
    
    func showObservedTeams() {
        if let observedTeamsVC: BaseVC = self.storyboard!.instantiateViewControllerWithIdentifier("ObservedTeamsVC") as? BaseVC {
            observedTeamsVC.rootVC = self.rootVC
            self.setViewControllers([observedTeamsVC], animated: true)
        }
    }
    
    func showZmonDashboard() {
        if let zmonDashboardVC: BaseVC = self.storyboard!.instantiateViewControllerWithIdentifier("ZmonDashboardVC") as? BaseVC {
            zmonDashboardVC.rootVC = self.rootVC
            self.setViewControllers([zmonDashboardVC], animated: true)
        }
    }
    
    func showSettings() {
    
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            
            }
   }
    
    func showLogout() {
        
        //reset username and password
        CredentialsStore.sharedInstance.clearCredentials()
        //delete the token
        CredentialsStore.sharedInstance.clearToken()
        
        //show the login view
        
        let result = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC")
        self.presentViewController(result!, animated: true, completion: nil)
        
        
    }


}
