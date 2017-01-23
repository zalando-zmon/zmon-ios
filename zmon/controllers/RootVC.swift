//
//  ViewController.swift
//  zmon
//
//  Created by Andrej Kincel on 15/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    
    var leftSwipe: UISwipeGestureRecognizer!
    var rightSwipe: UISwipeGestureRecognizer!

    let sideMenuGap: CGFloat = 80.0
    
    weak var navigationVC: NavigationVC?
    weak var sideMenuVC: SideMenuVC?
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RootVC.hideSideMenu))
        self.leftSwipe.direction = .left
        self.view.addGestureRecognizer(self.leftSwipe)
        
        self.rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RootVC.showSideMenu))
        self.rightSwipe.direction = .right
        self.view.addGestureRecognizer(self.rightSwipe)
        
        if let navigationVC = self.storyboard!.instantiateViewController(withIdentifier: "NavigationVC") as? NavigationVC {
            self.navigationVC = navigationVC
            navigationVC.rootVC = self
            self.view.addSubview(navigationVC.view)
            self.addChildViewController(navigationVC)
            navigationVC.didMove(toParentViewController: self)
        }
        
        if let sideMenuVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC {
            self.sideMenuVC = sideMenuVC
            sideMenuVC.rootVC = self
            sideMenuVC.view.frame = CGRect(x: -self.view.frame.width-self.sideMenuGap, y: 0, width: self.view.frame.width-self.sideMenuGap, height: self.view.frame.height)
            self.view.addSubview(sideMenuVC.view)
            self.addChildViewController(sideMenuVC)
            sideMenuVC.didMove(toParentViewController: self)
        }
    }
    
    // MARK:- SideMenu control
    func toggleSideMenu() {
        if let sideMenuVC = self.sideMenuVC {
            if sideMenuVC.view.frame.origin.x == 0 {
                hideSideMenu()
            }
            else {
                showSideMenu()
            }
            
        }
    }

    func showSideMenu() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            if let sideMenuVC = self.sideMenuVC {
                sideMenuVC.view.frame = CGRect(x: 0, y: 0, width: sideMenuVC.view.frame.width, height: sideMenuVC.view.frame.height)
                
                if let navigationVC = self.navigationVC {
                    navigationVC.view.frame = CGRect(x: sideMenuVC.view.frame.width, y: 0, width: navigationVC.view.frame.width, height: navigationVC.view.frame.height)
                }
            }
        }) 
    }
    
    func hideSideMenu() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            if let sideMenuVC = self.sideMenuVC {
                sideMenuVC.view.frame = CGRect(x: -sideMenuVC.view.frame.width, y: 0, width: sideMenuVC.view.frame.width, height: sideMenuVC.view.frame.height)
                
                if let navigationVC = self.navigationVC {
                    navigationVC.view.frame = CGRect(x: 0, y: 0, width: navigationVC.view.frame.width, height: navigationVC.view.frame.height)
                }
            }
        }) 
    }
    
}
