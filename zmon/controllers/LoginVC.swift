//
//  LoginVC.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    private let oAuthAccessTokenService: OAuthAccessTokenService = OAuthAccessTokenService()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: User actions
    @IBAction func signInButtonTouched(sender: UIButton) {
        if (usernameField.text!.isEmpty || passwordField.text!.isEmpty) {
            let alertController = UIAlertController(
                title: "Login error",
                message:"Empty username or password",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        let credentialsStore = CredentialsStore.sharedInstance
        credentialsStore.setCredentials(credentials: Credentials(username: username, password: password))
        
        oAuthAccessTokenService.login(username: username, password: password,
            success: { (token: String) -> () in
                credentialsStore.setAccessToken(token)
                if let rootVC: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RootVC") {
                    self.presentViewController(rootVC, animated: true, completion: nil)
                }
            },
            failure: { (error: NSError) -> () in
                let alertController = UIAlertController(
                    title: "Login error",
                    message: error.description,
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            })
    }

}
