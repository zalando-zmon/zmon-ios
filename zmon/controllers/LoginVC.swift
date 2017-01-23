//
//  LoginVC.swift
//  zmon
//
//  Created by Andrej Kincel on 17/12/15.
//  Copyright © 2015 Zalando Tech. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {
    
    fileprivate let oAuthAccessTokenService: OAuthAccessTokenService = OAuthAccessTokenService()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var saveCredentialsLabel: UILabel!
    @IBOutlet weak var saveCredentialsSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameField.delegate = self
        self.usernameField.placeholder = "Username".localized
        
        self.passwordField.delegate = self
        self.passwordField.placeholder = "Password".localized
        
        self.saveCredentialsLabel.text = "SaveCredentials".localized
        
        if let credentials: Credentials = CredentialsStore.sharedInstance.credentials() {
            self.usernameField.text = credentials.username
            self.passwordField.text = credentials.password
        }
        
        if let saveCredentials: Bool = CredentialsStore.sharedInstance.saveCredentials() {
            self.saveCredentialsSwitch.isOn = saveCredentials
        }
        
        
    }
    
    
    //MARK: User actions
    fileprivate func login() {
        if (usernameField.text!.isEmpty || passwordField.text!.isEmpty) {
            let alertController = UIAlertController(
                title: "Login error",
                message:"Empty username or password",
                preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        let credentialsStore = CredentialsStore.sharedInstance
        
        SVProgressHUD.show()
        oAuthAccessTokenService.login(username, password: password,
            success: { (token: String) -> () in
                
                //Store credentials and saving prefs only if they were correct
                if self.saveCredentialsSwitch.isOn {
                    credentialsStore.setSaveCredentials(true)
                    credentialsStore.setCredentials(Credentials(username: username, password: password))
                }
                else {
                    credentialsStore.setSaveCredentials(false)
                }
                
                //Store accessToken
                credentialsStore.setAccessToken(token)
                
                //Register for remote push notifications
                if let deviceToken = GCMTokenStore.sharedInstance.deviceToken() {
                    let zmonAlertsService: ZmonAlertsService = ZmonAlertsService()
                    
                    zmonAlertsService.registerDeviceWithToken(deviceToken,
                        success: { () -> () in
                            log.info("Successfully registered for push notifications!")
                        },
                        failure: { (error: NSError) -> () in
                            log.error(error.debugDescription)
                    })
                }
                
                //Show first screen
                if let rootVC: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "RootVC") {
                    SVProgressHUD.dismiss()
                    self.present(rootVC, animated: true, completion: nil)
                }
            },
            failure: { (error: NSError) -> () in
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(
                    title: "Login error",
                    message: error.description,
                    preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func signInButtonTouched(_ sender: UIButton) {
        self.login()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            self.login()
        }
        
        return false
    }

}
