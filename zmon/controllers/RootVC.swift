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
        
        self.leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("hideSideMenu"))
        self.leftSwipe.direction = .Left
        self.view.addGestureRecognizer(self.leftSwipe)
        
        self.rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("showSideMenu"))
        self.rightSwipe.direction = .Right
        self.view.addGestureRecognizer(self.rightSwipe)
        
        if let navigationVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationVC") as? NavigationVC {
            self.navigationVC = navigationVC
            navigationVC.rootVC = self
            self.view.addSubview(navigationVC.view)
            self.addChildViewController(navigationVC)
            navigationVC.didMoveToParentViewController(self)
        }
        
        if let sideMenuVC = self.storyboard!.instantiateViewControllerWithIdentifier("SideMenuVC") as? SideMenuVC {
            self.sideMenuVC = sideMenuVC
            sideMenuVC.rootVC = self
            sideMenuVC.view.frame = CGRectMake(-self.view.frame.width-self.sideMenuGap, 0, self.view.frame.width-self.sideMenuGap, self.view.frame.height)
            self.view.addSubview(sideMenuVC.view)
            self.addChildViewController(sideMenuVC)
            sideMenuVC.didMoveToParentViewController(self)
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
        UIView.animateWithDuration(0.5) { () -> Void in
            if let sideMenuVC = self.sideMenuVC {
                sideMenuVC.view.frame = CGRectMake(0, 0, sideMenuVC.view.frame.width, sideMenuVC.view.frame.height)
                
                if let navigationVC = self.navigationVC {
                    navigationVC.view.frame = CGRectMake(sideMenuVC.view.frame.width, 0, navigationVC.view.frame.width, navigationVC.view.frame.height)
                }
            }
        }
    }
    
    func hideSideMenu() {
        UIView.animateWithDuration(0.5) { () -> Void in
            if let sideMenuVC = self.sideMenuVC {
                sideMenuVC.view.frame = CGRectMake(-sideMenuVC.view.frame.width, 0, sideMenuVC.view.frame.width, sideMenuVC.view.frame.height)
                
                if let navigationVC = self.navigationVC {
                    navigationVC.view.frame = CGRectMake(0, 0, navigationVC.view.frame.width, navigationVC.view.frame.height)
                }
            }
        }
    }
    
}