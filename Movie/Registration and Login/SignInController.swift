//
//  SignInController.swift
//  Movie
//
//  Created by Jin on 4/13/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import ProgressHUD

class SignInController: UIViewController {
    
    let biometricAuth = BiometricAuth()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var biometricButton: UIButton!
    
    
    @IBOutlet weak var topConstrainHeight: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstanHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        
        topConstrainHeight.constant = 900;
        logoTopConstanHeight.constant = 283
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        super.viewDidLoad()
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let biometricEnabled = UserDefaults.standard.value(forKey: Constants.kBiometricEnabled) as? Bool
        if biometricEnabled != nil && biometricEnabled == true && biometricAuth.canEvaluatePolicy() {
            biometricButton.isHidden = false
            
        } else {
            biometricButton.isHidden = true
        }
        
        switch biometricAuth.biometricType() {
        case .FaceID:
            biometricButton.setImage(#imageLiteral(resourceName: "faceid"), for: UIControl.State.normal)
        default:
            biometricButton.setImage(#imageLiteral(resourceName: "touchid"), for: UIControl.State.normal)
        }
        if let userName = UserDefaults.standard.value(forKey: Constants.kUserName) as? String {
            emailField.text = userName
            //            let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: userName, accessGroup: KeychainConfig.accessGroup)
            //            if let password = try! passwordItem.readPassword() as? String {
            //                passwordField.text = password
            //            }
        }
    }
    
    
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        topConstrainHeight.constant = 900;
        logoTopConstanHeight.constant = 283;
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut,animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        print("close")
        
        
    }
    
    
    @IBAction func signInPressed(_ sender: Any) {
        
        guard let email = emailField.text,
            let password = passwordField.text else {return}
        
        self.displayHUD()
        self.view.endEditing(true)
        
        
        authenticateUserWith(email: email, password: password)
        
        
        
    }
    
    
    func authenticateUserWith(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email,password: password) { (user, error) in
            if error == nil{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let Home = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabBarViewController
                let navigation = UINavigationController.init(rootViewController: Home)
                UIApplication.shared.windows.first?.rootViewController = navigation
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
        /*Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            self.removeHUD()
            
            guard error == nil else {
                self.showAlert(message: error!.localizedDescription)
                return
                
            }
            guard let _ = result?.user else {return}
            
            // save user's credetials in keychain
            if UserDefaults.standard.value(forKey: Constants.kUserName) == nil {
                // save user's username into userdefaults
                let userDefaults = UserDefaults.standard
                userDefaults.set(email, forKey: Constants.kUserName)
                userDefaults.synchronize()
                // save password into keychain
                let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: email, accessGroup: KeychainConfig.accessGroup)
                do {
                    try passwordItem.savePassword(password)
                }
                catch let err {
                    fatalError("Error updating keychain: \(err.localizedDescription)")
                }
            }
            
            let biometricEnabled = UserDefaults.standard.value(forKey: Constants.kBiometricEnabled) as? Bool
            if biometricEnabled != nil && biometricEnabled == true {
                self.performSegue(withIdentifier: "journalHome", sender: self)
            } else if self.biometricAuth.canEvaluatePolicy() == true {
                self.performSegue(withIdentifier: "showBiometric", sender: self)
            } else {
                self.performSegue(withIdentifier: "journalHome", sender: self)
            }
            
            
            
        }*/
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error!", message: message, preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func loginWithBiometricAuth(_ sender: UIButton) {
        
        biometricAuth.authenticateUser { (message) in
            
            self.displayHUD()
            
            if let message = message {
                self.removeHUD()
                self.showAlert(message: message)
                return
            }
            
            if let username = UserDefaults.standard.value(forKey: Constants.kUserName) as? String {
                do {
                    let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: username, accessGroup: KeychainConfig.accessGroup)
                    let password = try passwordItem.readPassword()
                    self.authenticateUserWith(email: username, password: password)
                } catch let err {
                    self.removeHUD()
                    print("Error authenticating: \(err.localizedDescription)")
                }
            }
            
        }
    }
    
    func displayHUD() {
        SHUD.show(self.view, style: SHUDStyle.light, alignment: SHUDAlignment.horizontal, type: SHUDType.loading, text: "Logging in. Please wait...", nil)
    }
    
    func removeHUD() {
        SHUD.hide()
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        
        
        
    }
    
    
    
    @IBAction func showLogInPop(_ sender: Any) {
        topConstrainHeight.constant = 100;
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut,animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        print("clicked")
        
        
    }
    
    
    @IBAction func showSignUpPop(_ sender: Any) {
        //  performSegue on MainStoryBoard
          self.performSegue(withIdentifier: "SignUp", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
