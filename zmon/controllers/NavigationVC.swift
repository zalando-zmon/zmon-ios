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
        
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = ZmonColor.textPrimary
        
        showZmonStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    func showZmonStatus() {
        if let zmonStatusVC: BaseVC = self.storyboard!.instantiateViewController(withIdentifier: "ZmonStatusVC") as? BaseVC {
            zmonStatusVC.rootVC = self.rootVC
            self.setViewControllers([zmonStatusVC], animated: true)
        }
    }
    
    func showObservedTeams() {
        if let observedTeamsVC: BaseVC = self.storyboard!.instantiateViewController(withIdentifier: "ObservedTeamsVC") as? BaseVC {
            observedTeamsVC.rootVC = self.rootVC
            self.setViewControllers([observedTeamsVC], animated: true)
        }
    }
    
    func showObservedAlerts() {
        if let observedAlertsVC = self.storyboard?.instantiateViewController(withIdentifier: "ObservedAlertsVC") as? ObservedAlertsVC {
            observedAlertsVC.rootVC = rootVC
            observedAlertsVC.fetchRemoteAlerts()
            setViewControllers([observedAlertsVC], animated: true)
        }
    }
    
    func showZmonDashboard() {
        if let zmonDashboardVC: BaseVC = self.storyboard!.instantiateViewController(withIdentifier: "ZmonDashboardVC") as? BaseVC {
            zmonDashboardVC.rootVC = self.rootVC
            self.setViewControllers([zmonDashboardVC], animated: true)
        }
    }
    
    func showSettings() {
    
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            
            }
   }
    
    func showLogout() {
        
        //reset username and password
        CredentialsStore.sharedInstance.clearCredentials()
        //delete the token
        CredentialsStore.sharedInstance.clearToken()
        
        //show the login view
        
        let result = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.present(result!, animated: true, completion: nil)
        
        
    }


}
